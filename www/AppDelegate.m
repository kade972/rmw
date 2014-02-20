#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }


    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: vc];
    self.window.rootViewController = nav;


    //WEBVIEW
    UIWebView *myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 200, 320, vc.view.frame.size.height)];
    myWeb.mediaPlaybackRequiresUserAction = NO;
    myWeb.allowsInlineMediaPlayback = YES;
    [vc.view addSubview:myWeb];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.radiomedweb.com/audio.html"]];
    [myWeb loadRequest: request];


    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
