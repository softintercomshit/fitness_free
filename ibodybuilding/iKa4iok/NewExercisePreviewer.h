//
//  NewExercisePreviewer.h
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/21/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IBVideoPlayer.h"
#import "Reachability.h"
#import "EditExerciseControll.h"
#import "AFHTTPRequestOperation.h"
#import "AGAlertViewWithProgressbar.h"
#import "EditExerciseControll.h"

#import "VideoDownloader.h"

@class IBVideoPlayer;

@interface NewExercisePreviewer : UIViewController<UIScrollViewDelegate,VideoPlayerDelegate,VideoDownloaderDelegate,UIAlertViewDelegate, EditExerciseControllDelegate>{
    EditExerciseControll *controll;
    BOOL isPickingExercise;
    BOOL pageControlBeginUsed;
     Reachability* hostReach;
    int animationCounter;
    NSTimer *animationTimer;
    AFHTTPRequestOperation *operations;
    
BOOL landscape;
}

@property (retain, nonatomic) NSString *folderPaf;
@property (nonatomic, readwrite) int day;
@property (retain, nonatomic) NSMutableArray *photoArray;
@property (retain, nonatomic) NSString *descriptionString;
@property (retain, nonatomic) NSString *titleString;
@property (retain, nonatomic) NSString *videoURL;

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionlabel;
@property (retain, nonatomic) IBOutlet UIPageControl *contentPageControll;
@property (retain, nonatomic) NSString *plistStringPath;
@property (retain, nonatomic) NSMutableDictionary *contentDict;

@property (nonatomic, readwrite) int isCustom;
@property (nonatomic, readwrite) int isWithVideo;
@property (nonatomic, readwrite) BOOL isWorkout;
@property (nonatomic, retain)NSString *workout;


-(id)initWithNibName:(NSString *)nibNameOrNil image:(NSMutableDictionary*)data title:(NSString*)title isPickingEx:(BOOL)isPicking;

@end
