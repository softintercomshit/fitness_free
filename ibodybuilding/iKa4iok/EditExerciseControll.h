//
//  EditExerciseControll.h
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/7/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "IBVideoPlayer.h"

@class IBVideoPlayer;
@protocol EditExerciseControllDelegate <NSObject>

-(void)back;

@end
@interface EditExerciseControll : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, VRGCalendarViewDelegate>
{
    int calCheck;
    UIBarButtonItem *backBtnAux;
    MPMoviePlayerController *player;
    VRGCalendarView *calendar;
//    NSString *exerciseName;
    NSMutableArray *arrayWithExercisePaths;
    UIScrollView *repsScroll;
    UITextField *repsTxt;
    UITextField *weightTxt;
    NSMutableArray *repsArray;
    NSMutableArray *weightArray;
    int i;
    int r, w;
    BOOL goBack;
    BOOL tapCount;
    bool checkEdit;
    BOOL poundsCheck;
    NSDate *sDate;
    NSString *videoURl1;
    NSString *dateString;
    NSDateFormatter *dateFormatter;
    NSDate  *minimumDate;
    NSMutableArray *disabledDates;
    NSString *plistPathString;
    AVAudioPlayer *tickPlayer;
     NSTimer *timer;
    float j;
    NSString *timerString;
    NSString *labelString;
    UILabel *titleLabel;
    UIScrollView *labelScroll;
    UILabel *lbl;
    NSString *trtansStyle;
    UIView *calView;
    NSTimeInterval time2Tick;
    int sec;
    BOOL isPlaying;
    NSDate *selectedDate;
    AVAudioPlayer *pipPlayer;

}
@property (retain, nonatomic) IBOutlet UIImageView *dateBtnImg;
@property (retain, nonatomic) IBOutlet UILabel *lvLabel;
@property (retain, nonatomic) IBOutlet UILabel *rLabel;
@property (retain, nonatomic) IBOutlet UILabel *wLabrl;
@property (retain, nonatomic) IBOutlet UIImageView *closeClaImg;
@property (retain, nonatomic) IBOutlet UIImageView *backImgView;
@property (retain, nonatomic) IBOutlet UIButton *repsButton;
@property (retain, nonatomic) IBOutlet UIButton *auxDateBtn;
@property (retain, nonatomic) IBOutlet UIImageView *stopwatchView;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *calendarView;
@property (retain, nonatomic) IBOutlet UIButton *secbutton;
@property (retain, nonatomic) IBOutlet UIViewController *controll;
@property (retain, nonatomic) IBOutlet UIView *histView;
@property (readwrite, nonatomic) BOOL canEdit;
@property (readwrite, nonatomic) BOOL isNew;
@property (retain, nonatomic) IBOutlet UIButton *closeCalBtn;

@property (retain, nonatomic) IBOutlet UIButton *keyBoardBtn;
@property (nonatomic, retain) NSString *videoPath;
@property (retain, nonatomic) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) NSString *exerciseName;
@property (retain, nonatomic) IBOutlet UIButton *secBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, readwrite) int *dayOfExercise;
@property (nonatomic, retain) NSString *folderString;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSMutableArray *workoutDaysArray;
@property (nonatomic, retain) NSMutableArray *photoArr;
@property (nonatomic, retain) NSString *workout;
@property (nonatomic, retain) id <EditExerciseControllDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *weightButton;
@property (retain, nonatomic) IBOutlet UIButton *stopTickingBtn;
@property (retain, nonatomic) IBOutlet UILabel *stopwatchLabel;


//-(IBAction)makeKeyboardGoAway;
- (void) makeTransitionfor:(UIViewController *)aController withTransitionStyle:(NSString *)aStyle;
-(IBAction)setSeconds:(id)sender;
- (IBAction)convertToPounds:(id)sender;
-(IBAction)stopTickcing:(id)sender;
@end
