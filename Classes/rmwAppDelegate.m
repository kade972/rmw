#import "AppDelegate.h"

 

@implementation AppDelegate

 

@synthesize window = _window;

 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{

// Set AudioSession
NSError *sessionError = nil;
[[AVAudioSession sharedInstance] setDelegate:self];
[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

/* Pick any one of them */
// 1. Overriding the output audio route
UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);

// 2. Changing the default output audio route
// UInt32 doChangeDefaultRoute = 1;
// AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

    // Override point for customization after application launch.
application.idleTimerDisabled = YES;
    return YES;

}

                            

- (void)applicationWillResignActive:(UIApplication *)application

{

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.

    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

 

- (void)applicationDidEnterBackground:(UIApplication *)application

{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 

    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

 

- (void)applicationWillEnterForeground:(UIApplication *)application

{

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

 

- (void)applicationDidBecomeActive:(UIApplication *)application

{

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

 

- (void)applicationWillTerminate:(UIApplication *)application

{

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

-(void) initAudioSession {
// Registers this class as the delegate of the audio session to listen for audio interruptions
[[AVAudioSession sharedInstance] setDelegate: self];
//Set the audio category of this app to playback.
NSError *setCategoryError = nil; [[AVAudioSession sharedInstance]
  setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
if (setCategoryError) {
//RESPOND APPROPRIATELY
}

// Registers the audio route change listener callback function
// An instance of the audio player/manager is passed to the listener
AudioSessionAddPropertyListener ( kAudioSessionProperty_AudioRouteChange,
audioRouteChangeListenerCallback, self );

//Activate the audio session
NSError *activationError = nil;
[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
if (activationError) {
//RESPOND APPROPRIATELY
}
}

//interface
void audioRouteChangeListenerCallback ( void     *inUserData,
AudioSessionPropertyID    inPropertyID,
UInt32                    inPropertyValueSize,
const void                *inPropertyValue );
//implementation
void audioRouteChangeListenerCallback (
void                      *inUserData,
AudioSessionPropertyID    inPropertyID,
UInt32                    inPropertyValueSize,
const void                *inPropertyValue ) {

// ensure that this callback was invoked for a route change
if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;

// Determines the reason for the route change,
// to ensure that it is not because of a category change.
CFDictionaryRef routeChangeDictionary = inPropertyValue;
CFNumberRef routeChangeReasonRef = CFDictionaryGetValue ( routeChangeDictionary,
CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );

SInt32 routeChangeReason;
CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);

// "Old device unavailable"
// headset was unplugged, or device was removed from a dock connector
// that supports audio output. A test for when audio is paused

YOURPLAYERINSTANCE *playerInstance = (YOURPLAYERINSTANCE*) inUserData;

if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
// player might respond appropriately - pause
} else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable){
//audio plugged back in, player might respond appropriately - play }
}
-(void) viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];
[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
[self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
[self resignFirstResponder]; [super viewWillDisappear:animated];
}

- (BOOL) canBecomeFirstResponder {
return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
if (receivedEvent.type == UIEventTypeRemoteControl) {
switch (receivedEvent.subtype) {
case UIEventSubtypeRemoteControlTogglePlayPause: {
//RESPOND TO PLAY/PAUSE EVENT HERE
break;
}
default:
break;
}
}
}

@end
