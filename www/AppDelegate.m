#import "AppDelegate.h"
@implementation AppDelegate



- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    application.idleTimerDisabled = YES;

Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");

if (playingInfoCenter) {
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Some artist", MPMediaItemPropertyArtist,
                             @"Some title", MPMediaItemPropertyTitle,
                             @"Some Album", MPMediaItemPropertyAlbumTitle,
                             nil];
    center.nowPlayingInfo = songInfo;
}

    // Override point for customization after app launch    
   }


- (void)dealloc {
    [super dealloc];
}


@end
