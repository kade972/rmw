#import "AppDelegate.h"
@implementation AppDelegate



- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    application.idleTimerDisabled = YES;

[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];


NSError *setCategoryErr = nil;
 NSError *activationErr  = nil;
 [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
 [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    // Override point for customization after app launch    
   }


- (void)dealloc {
    [super dealloc];
}


@end
