//
//  IBVideoPlayer.m
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 5/25/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "IBVideoPlayer.h"
#import "VideoDownloader.h"

static IBVideoPlayer *instance_;

@implementation IBVideoPlayer
@synthesize delegate;

#pragma mark - Singletone Magic




static void singleton_remover() {
    [instance_ release];
}

+ (IBVideoPlayer*)sharedVPlayer {
    @synchronized(self) {
        if( instance_ == nil ) {
            [[self alloc] init];
        }
    }
    
    return instance_;
}

- (id)init {
    self = [super init];
    instance_ = self;
    
    atexit(singleton_remover);
    
    return self;
}

- (void)dealloc {
    [playerVC release];
    [super dealloc];
}



-(void)playVideoWithURL:(NSURL*)videoPath onViewController:(UIViewController *)viewController
{
    
    
    
    playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:videoPath];
            
            
    [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerVC.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerVC.moviePlayer];
    
    // Set the modal transition style of your choice
    playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // Present the movie player view controller
    [viewController presentModalViewController:playerVC animated:YES];
    landscape = YES;

    // Start playback
    [playerVC.moviePlayer prepareToPlay];
    [playerVC.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    [playerVC.moviePlayer play];
}


-(void)removeVideoController
{
    if ([playerVC respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [playerVC dismissModalViewControllerAnimated:YES];
        
    } else {
        NSLog(@"Panda dno");
    }
}


- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];

        [delegate didFinishPlayingVideo:YES];
        // Dismiss the view controller
        [playerVC dismissModalViewControllerAnimated:YES];
       
    }
    else
    {
        [[VideoDownloader instance]hideAlertView];
    }
}



@end
