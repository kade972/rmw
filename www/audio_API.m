static AVAudioPlayer* player = nil;


@implementation audio_API


+ (void)play:(ForgeTask*)task {

    // parse the file url from the file object
    ForgeFile* file = [[ForgeFile alloc] initWithFile:[task.params objectForKey:@"file"]];
    NSString* fileURL = [file url];

    NSLog(@"Playing file at %@", fileURL);

    NSURL* url = [NSURL URLWithString:fileURL];


    // TESTING
    url = [[NSBundle mainBundle] URLForResource:@"http://173.255.137.32:7050/;stream.mp3" withExtension:nil];
    // END TESTING

    NSAssert(url, @"URL is invalid.");

    // create the player
    NSError* error = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(!player)
    {
        NSLog(@"Error creating player: %@", error);
    };

//    player.delegate = audio_API;

    [player play];

    [task success:nil];
}


+ (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [ForgeLog d:@"Audio finished playing successfully."];
    } else {
        [ForgeLog d:@"Audio did not finish playing successfully."];
    }

    // call the audio.finishedPlaying event
    [[ForgeApp sharedApp] event:@"audio.finishedPlaying" withParam:nil];
}

+ (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [ForgeLog d:@"Audio had error decoding."];
    [ForgeLog e:error];

    // call the audio.decodeErrorOccurred event
    [[ForgeApp sharedApp] event:@"audio.decodeErrorOccurred" withParam:nil];
}

@end
