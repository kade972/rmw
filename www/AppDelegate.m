#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Init and set the interrupt listener.  last parameter is passed to interruptlistener
AudioSessionInitialize(NULL, NULL, interruptlistener, NULL);

//Allow the app sound to continue to play when the screen is locked.
UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);

//Force current audio out through speaker
UInt32 routeSpeaker = kAudioSessionOverrideAudioRoute_Speaker;
AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(routeSpeaker), &routeSpeaker);

//Turn on the ability to mix with others
UInt32 doSetProperty = 1;
AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
    return YES;
}


@end
