#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
BOOL ok;
NSError *setCategoryError = nil;
ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                         error:&setCategoryError];

    return YES;
}


@end
