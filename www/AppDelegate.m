#import "AppDelegate.h"
@implementation AppDelegate



- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    application.idleTimerDisabled = YES;


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


- (void)dealloc {
    [super dealloc];
}


@end
