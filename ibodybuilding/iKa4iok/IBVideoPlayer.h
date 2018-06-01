//
//  IBVideoPlayer.h
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 5/25/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"


@protocol VideoPlayerDelegate <NSObject>

-(void)didFinishPlayingVideo:(BOOL)isFinished;

@end

@interface IBVideoPlayer : NSObject
{
    Reachability    *networkReachability;
    NetworkStatus   networkStatus;
    MPMoviePlayerViewController *playerVC;
    
    BOOL landscape;
}

@property (nonatomic, assign)id<VideoPlayerDelegate>delegate;
-(void)removeVideoController;
+ (id)sharedVPlayer;
-(void)playVideoWithURL:(NSURL*)videoPath onViewController:(UIViewController *)viewController;
@end
