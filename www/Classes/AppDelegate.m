//
//  AppDelegate.m
//  ExampleAudioStreamer
//
//  Created by Carlos Williams on 7/09/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

#ifdef PHONEGAP_FRAMEWORK
	#import <PhoneGap/PhoneGapViewController.h>
#else
	#import "PhoneGapViewController.h"
#endif

@implementation AppDelegate

@synthesize invokeString;

- (id) init
{	
	/** If you need to do any extra app-specific initialization, you can do it here
	 *  -jm
	 **/
CLLocationManager* locationManager = [[CLLocationManager alloc] init];
[locationManager startUpdatingLocation];
    return [super init];
}

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
        NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];

	// ivar, initialized to UIBackgroundTaskInvalid in awakeFromNib
	
	UIBackgroundTaskIdentifier bgTask; 
	if ([audioPlayer play]) {
	  bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
	}

	NSArray *keyArray = [launchOptions allKeys];
	if ([launchOptions objectForKey:[keyArray objectAtIndex:0]]!=nil) 
	{
		NSURL *url = [launchOptions objectForKey:[keyArray objectAtIndex:0]];
		self.invokeString = [url absoluteString];
		NSLog(@"ExampleAudioStreamer launchOptions = %@",url);
	}
	
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if ExampleAudioStreamer.plist specifies a protocol to handle
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    // must call super so all plugins will get the notification, and their handlers will be called 
	// super also calls into javascript global function 'handleOpenURL'
    return [super application:application handleOpenURL:url];
}

-(id) getCommandInstance:(NSString*)className
{
	/** You can catch your own commands here, if you wanted to extend the gap: protocol, or add your
	 *  own app specific protocol to it. -jm
	 **/
	return [super getCommandInstance:className];
}

/**
 Called when the webview finishes loading.  This stops the activity view and closes the imageview
 */

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)success
{
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;

    if (self.haveMoreAudioToPlay) {
        newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
        [self playNextAudioFile];
    }

    if (bgTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask: bgTaskId];
    }

    bgTaskId = newTaskId;
}      

// if the iOS device allows background execution,
// this Handler will be called
- (void)backgroundHandler {

    NSLog(@"### -->VOIP backgrounding callback");

    UIApplication*    app = [UIApplication sharedApplication];

    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];

    // Start the long-running task 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    while (1) {
        NSLog(@"BGTime left: %f", [UIApplication sharedApplication].backgroundTimeRemaining);
           [self doSomething];
        sleep(1);
    }   
});     

- (void)applicationDidEnterBackground:(UIApplication *)application {

    UIApplication*    app = [UIApplication sharedApplication];

    // it's better to move "dispatch_block_t expirationHandler"
    // into your headerfile and initialize the code somewhere else
    // i.e. 
    // - (void)applicationDidFinishLaunching:(UIApplication *)application {
//
// expirationHandler = ^{ ... } }
    // because your app may crash if you initialize expirationHandler twice.
    dispatch_block_t expirationHandler;
    expirationHandler = ^{

        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;


        bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    };

    bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];


    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // inform others to stop tasks, if you like
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyApplicationEntersBackground" object:self];

        // do your background work here     
    }); 

- (void)webViewDidFinishLoad:(UIWebView *)theWebView 
{
	// only valid if ExampleAudioStreamer.plist specifies a protocol to handle
	if(self.invokeString)
	{
		// this is passed before the deviceready event is fired, so you can access it in js when you receive deviceready
		NSString* jsString = [NSString stringWithFormat:@"var invokeString = \"%@\";", self.invokeString];
		[theWebView stringByEvaluatingJavaScriptFromString:jsString];
	}
	return [ super webViewDidFinishLoad:theWebView ];
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView 
{
	return [ super webViewDidStartLoad:theWebView ];
}

/**
 * Fail Loading With Error
 * Error - If the webpage failed to load display an error with the reason.
 */
- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error 
{
	return [ super webView:theWebView didFailLoadWithError:error ];
}

/**
 * Start Loading Request
 * This is where most of the magic happens... We take the request(s) and process the response.
 * From here we can re direct links and other protocalls to different internal methods.
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return [ super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType ];
}


- (BOOL) execute:(InvokedUrlCommand*)command
{
	return [ super execute:command];
}

- (void)dealloc
{
	[ super dealloc ];
}

@end
