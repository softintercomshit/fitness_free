//
//  EditExerciseControll.m
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/7/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "EditExerciseControll.h"
#import "GuideAppDelegate.h"
#import "Exercise.h"
#import "Detail.h"
#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface EditExerciseControll ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchArray;

@end

@implementation EditExerciseControll
//@synthesize delegate;


-(void)setWorkout:(NSString *)workout
{
    _workout = [workout copy];
}

-(void) setDayOfExercise:(int *)dayOfExercise
{
    _dayOfExercise = dayOfExercise;
}

-(void)setPhotoArr:(NSMutableArray *)photoArrs
{
    _photoArr = [photoArrs copy];
}

-(void)setExerciseName:(NSString *)exerciseName
{
    _exerciseName = NSLocalizedString(exerciseName, nil);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"Will appear");
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Did load");
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        [fontNames release];
    }
    [familyNames release];
    sec = 0;
    self.closeCalBtn.enabled = NO;
    NSLog(@"closecalbtn: %d", (int) self.closeCalBtn.enabled);
    self.dateButton.enabled = NO;
    
    if( SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        if (IS_HEIGHT_GTE_568) {
            [self.stopwatchView setFrame:CGRectMake(0, 520, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 530, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
        }
    }else{
        if (IS_HEIGHT_GTE_568) {
            [self.backImgView setFrame:CGRectMake(self.backImgView.frame.origin.x, 65, self.backImgView.frame.size.width, self.backImgView.frame.size.height)];
            [self.dateButton setFrame:CGRectMake(self.dateButton.frame.origin.x, 77, self.dateButton.frame.size.width, self.dateButton.frame.size.height)];
            [self.auxDateBtn setFrame:CGRectMake(self.auxDateBtn.frame.origin.x, 77, self.auxDateBtn.frame.size.width, self.auxDateBtn.frame.size.height)];
            [self.dateBtnImg setFrame:CGRectMake(self.dateBtnImg.frame.origin.x, 80, self.dateBtnImg.frame.size.width, self.dateBtnImg.frame.size.height)];
            [self.closeCalBtn setFrame:CGRectMake(self.closeCalBtn.frame.origin.x, 80, self.closeCalBtn.frame.size.width, self.closeCalBtn.frame.size.height)];
            [self.closeClaImg setFrame:CGRectMake(self.closeClaImg.frame.origin.x, 75, self.closeClaImg.frame.size.width, self.closeClaImg.frame.size.height)];
            [self.repsButton setFrame:CGRectMake(self.repsButton.frame.origin.x, 155, self.repsButton.frame.size.width, self.repsButton.frame.size.height)];
            [self.weightButton setFrame:CGRectMake(self.weightButton.frame.origin.x, 120, self.weightButton.frame.size.width, self.weightButton.frame.size.height)];
            [self.stopwatchView setFrame:CGRectMake(0, 522, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.secBtn setFrame:CGRectMake(0, 522, self.secBtn.frame.size.width, self.secBtn.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 532, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
            
            
        }else{
            NSLog(@"Iphone 4 with ios 7");
            [self.backImgView setFrame:CGRectMake(self.backImgView.frame.origin.x, 65, self.backImgView.frame.size.width, self.backImgView.frame.size.height)];
            [self.dateButton setFrame:CGRectMake(self.dateButton.frame.origin.x, 77, self.dateButton.frame.size.width, self.dateButton.frame.size.height)];
            [self.dateBtnImg setFrame:CGRectMake(self.dateBtnImg.frame.origin.x, 80, self.dateBtnImg.frame.size.width, self.dateBtnImg.frame.size.height)];
            [self.auxDateBtn setFrame:CGRectMake(self.auxDateBtn.frame.origin.x, 77, self.auxDateBtn.frame.size.width, self.auxDateBtn.frame.size.height)];
            [self.closeCalBtn setFrame:CGRectMake(self.closeCalBtn.frame.origin.x, 80, self.closeCalBtn.frame.size.width, self.closeCalBtn.frame.size.height)];
            [self.closeClaImg setFrame:CGRectMake(self.closeClaImg.frame.origin.x, 75, self.closeClaImg.frame.size.width, self.closeClaImg.frame.size.height)];
            [self.repsButton setFrame:CGRectMake(self.repsButton.frame.origin.x, 155, self.repsButton.frame.size.width, self.repsButton.frame.size.height)];
            [self.weightButton setFrame:CGRectMake(self.weightButton.frame.origin.x, 120, self.weightButton.frame.size.width, self.weightButton.frame.size.height)];
            [self.stopwatchView setFrame:CGRectMake(0, 435, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.secBtn setFrame:CGRectMake(0, 435, self.secBtn.frame.size.width, self.secBtn.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 445, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
        }
    }
    
    [self.repsButton setTitle:NSLocalizedString(@"Repetitions", nil) forState:UIControlStateNormal];
    [self.weightButton setTitle:NSLocalizedString(@"Weight(kg)", nil) forState:UIControlStateNormal];
    self.stopwatchLabel.font=[UIFont fontWithName:@"DS-Digital" size:40.0f];
    [self.stopwatchLabel setTextColor:[UIColor whiteColor]];
    [self.stopwatchLabel setText:@"00:00:00"];
    //    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [closeBtn addTarget:self
    //                 action:@selector(dateButtonPressed:)
    //       forControlEvents:UIControlEventTouchDown];
    //    closeBtn.frame = CGRectMake(200,0, 120, 50.0);
    //    [self.view addSubview:closeBtn];
    
    [self.stopTickingBtn setBackgroundColor:[UIColor redColor]];
    
    GuideAppDelegate* appDelegate = (GuideAppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchArray = [appDelegate getAllexercises];
    [_managedObjectContext release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myFunc) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    i=0;
    r=2;
    w=3;
    tapCount = YES;
    poundsCheck = 1;
    sDate = [NSDate new];
    
    
    if (dateString == nil)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        
        //    [format setDateFormat:@"dd MMM yyyy"];
        dateString = [format stringFromDate:[NSDate date]];
        [format release];
    };
    [_dateButton setTitle:dateString forState:normal];
    //    [_secBtn setTitle:@"30" forState:UIControlStateNormal];
    repsArray = [[NSMutableArray alloc] init];
    weightArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonSystemItemCancel target:self action:@selector(saveToFile)];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];
    [saveButtonItem release];
    [_secBtn setAlpha:0.7];
    [self filltextFieldsWithData];
    //    [self setTitleForExercise:self.exerciseName];
    //    self.secbutton.layer.anchorPoint = CGPointMake(1, 1);
    
    //set the calendar
    //    calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    //
    //    calendar.delegate = self;
    //    [calendar setInnerBorderColor:[UIColor clearColor]];
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    //    minimumDate = [dateFormatter dateFromString:@"20/09/2012"];
    //    [minimumDate retain];
    disabledDates = [[NSMutableArray alloc] init];
    for (NSManagedObject *product in self.fetchArray)
        
    {
        Exercise *exercise = (Exercise*)product;
        NSString *date = [dateFormatter stringFromDate:exercise.date];
        NSLog(@"date: %@", date);
        NSDate *newDate = [dateFormatter dateFromString:date];
        NSLog(@"New date: %@", newDate);
        [disabledDates addObject:newDate];
        //        [newDate release];
        
    }
    NSLog(@"Disabled dates: %@", disabledDates);
    //    [disabledDates retain];
    //    [calendar setMonthButtonColor:nil];
    //    calendar.onlyShowCurrentMonth = NO;
    //    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
    //    [calendar setBackgroundColor:[UIColor clearColor]];
    //    [calendar setDateBorderColor:[UIColor clearColor]];
    //    calendar.frame = CGRectMake(self.dateButton.frame.origin.x,self.dateButton.frame.origin.y, 300, 300);
    //    calendar.alpha = 0.0;
    //    [self.calendarView setFrame:CGRectMake(self.calendarView.frame.origin.x, self.dateButton.frame.origin.y, self.calendarView.frame.size.width, self.calendarView.frame.size.height)];
    //    [self.calendarView setAlpha:0.0];
    //    [self.view insertSubview:calendar belowSubview:self.auxDateBtn];
    //    UIView *calView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 400)];
    
    
}

-(void)viewDidLayoutSubviews
{
    NSLog(@"Did layout subviews");
    if( SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        if (IS_HEIGHT_GTE_568) {
            [self.stopwatchView setFrame:CGRectMake(0, 460, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 470, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
            [self.secBtn setFrame:CGRectMake(0, 460, self.secBtn.frame.size.width, self.secBtn.frame.size.height)];
        }else
        {
            [self.stopwatchView setFrame:CGRectMake(0, 370, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 380, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
            [self.secBtn setFrame:CGRectMake(0, 370, self.secBtn.frame.size.width, self.secBtn.frame.size.height)];
        }
    }else{
        if (IS_HEIGHT_GTE_568) {
            [self.backImgView setFrame:CGRectMake(self.backImgView.frame.origin.x, 65, self.backImgView.frame.size.width, self.backImgView.frame.size.height)];
            [self.dateButton setFrame:CGRectMake(self.dateButton.frame.origin.x, 77, self.dateButton.frame.size.width, self.dateButton.frame.size.height)];
            [self.auxDateBtn setFrame:CGRectMake(self.auxDateBtn.frame.origin.x, 77, self.auxDateBtn.frame.size.width, self.auxDateBtn.frame.size.height)];
            [self.dateBtnImg setFrame:CGRectMake(self.dateBtnImg.frame.origin.x, 80, self.dateBtnImg.frame.size.width, self.dateBtnImg.frame.size.height)];
            [self.closeCalBtn setFrame:CGRectMake(self.closeCalBtn.frame.origin.x, 80, self.closeCalBtn.frame.size.width, self.closeCalBtn.frame.size.height)];
            [self.closeClaImg setFrame:CGRectMake(self.closeClaImg.frame.origin.x, 75, self.closeClaImg.frame.size.width, self.closeClaImg.frame.size.height)];
            [self.repsButton setFrame:CGRectMake(self.repsButton.frame.origin.x, 155, self.repsButton.frame.size.width, self.repsButton.frame.size.height)];
            [self.weightButton setFrame:CGRectMake(self.weightButton.frame.origin.x, 120, self.weightButton.frame.size.width, self.weightButton.frame.size.height)];
            [self.stopwatchView setFrame:CGRectMake(0, 522, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.secBtn setFrame:CGRectMake(0, 522, self.secBtn.frame.size.width, self.secBtn.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 532, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
            
            
        }else{
            NSLog(@"Iphone 4 with ios 7");
            [self.backImgView setFrame:CGRectMake(self.backImgView.frame.origin.x, 65, self.backImgView.frame.size.width, self.backImgView.frame.size.height)];
            [self.dateButton setFrame:CGRectMake(self.dateButton.frame.origin.x, 77, self.dateButton.frame.size.width, self.dateButton.frame.size.height)];
            [self.dateBtnImg setFrame:CGRectMake(self.dateBtnImg.frame.origin.x, 80, self.dateBtnImg.frame.size.width, self.dateBtnImg.frame.size.height)];
            [self.auxDateBtn setFrame:CGRectMake(self.auxDateBtn.frame.origin.x, 77, self.auxDateBtn.frame.size.width, self.auxDateBtn.frame.size.height)];
            [self.closeCalBtn setFrame:CGRectMake(self.closeCalBtn.frame.origin.x, 80, self.closeCalBtn.frame.size.width, self.closeCalBtn.frame.size.height)];
            [self.closeClaImg setFrame:CGRectMake(self.closeClaImg.frame.origin.x, 75, self.closeClaImg.frame.size.width, self.closeClaImg.frame.size.height)];
            [self.repsButton setFrame:CGRectMake(self.repsButton.frame.origin.x, 155, self.repsButton.frame.size.width, self.repsButton.frame.size.height)];
            [self.weightButton setFrame:CGRectMake(self.weightButton.frame.origin.x, 120, self.weightButton.frame.size.width, self.weightButton.frame.size.height)];
            [self.stopwatchView setFrame:CGRectMake(0, 435, self.stopwatchView.frame.size.width, self.stopwatchView.frame.size.height)];
            [self.secBtn setFrame:CGRectMake(0, 435, self.secBtn.frame.size.width, self.secBtn.frame.size.height)];
            [self.stopwatchLabel setFrame:CGRectMake(self.stopwatchLabel.frame.origin.x, 445, self.stopwatchLabel.frame.size.width, self.stopwatchLabel.frame.size.height)];
        }
    }
}

-(void)myFunc{
    NSLog(@"DidEnterBackground");
    time2Tick = [tickPlayer currentTime];
    NSLog(@"tickplayer: %f", [tickPlayer currentTime]);
    //    [tickPlayer retain];
    isPlaying = tickPlayer.isPlaying;
    [tickPlayer stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playPips)
                                               object:nil];
    
    
}
- (NSString *)getLocalizedStringFromString:(NSString *)string
{
    NSString *localizedString = nil;
    
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    // Result.
    int number = [numberString integerValue];
    
    localizedString = NSLocalizedStringFromTable([string substringFromIndex:[numberString length]+1], @"content", nil);
    
    // Intermediate
    
    
    localizedString = [[NSString stringWithFormat:@"%i ",number] stringByAppendingString:localizedString];
    
    return localizedString;
}
-(void)viewDidAppear:(BOOL)animated
{
    self.exerciseName = NSLocalizedString(_exerciseName, nil);
    
    calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        calView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 400)];
    }else
    {
        calView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 400)];
    }
    
    [calView addSubview:calendar];
    [calView setAlpha:0];
    [self.view insertSubview:calView belowSubview:self.auxDateBtn];
    [calendar setAlpha:1];
    [calendar release];
    if (![self checkFileInFolderWithName:[[_videoPath stringByDeletingLastPathComponent] lastPathComponent]])
    {
        [self.nameLabel setTextColor:[UIColor blackColor]];
        if ([self.photoArr count] !=0){
            NSString *path;
            NSArray *comps = [[self.photoArr objectAtIndex:0]pathComponents];
            if ([[comps objectAtIndex:5] isEqualToString:@"Library"]) {
                NSLog(@"1 - %@", [comps objectAtIndex:5]);
                path = [[NSBundle mainBundle] resourcePath];
                path = [path stringByDeletingLastPathComponent];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-2]];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-1]];
            }else{
                NSLog(@"2 - %@", [comps objectAtIndex:5]);
                path = [[NSBundle mainBundle] resourcePath];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-4]];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-2]];
                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-1]];
            }
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
            if (imageView.frame.size.width == 200) {
                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                    if (IS_HEIGHT_GTE_568) {
                        [imageView setFrame:CGRectMake(20, 0, 280, 460)];
                        
                    }else
                        [imageView setFrame:CGRectMake(20, -20, 280, 460)];
                }else{
                    
                    [imageView setFrame:CGRectMake(20, 62, 280, 460)];
                }
                
            }else{
                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                    if (IS_HEIGHT_GTE_568) {
                        [imageView setFrame:CGRectMake(-30, 100, 370, 230)];
                        
                    }else
                        [imageView setFrame:CGRectMake(-90, 80, 480, 310)];
                }else{
                    [imageView setFrame:CGRectMake(-30, 170, 370, 230)];
                }
                
            }
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [self.view insertSubview:imageView belowSubview:self.stopwatchView];
            [imageView release];}
        
    } else{
        
        [self openMoviePlayer];
    }
    [self setHistData];
    [self.histView setAlpha:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
    
    
}

-(void) forwardAnimationWithLabel:(UILabel *) label andScrollView:(UIScrollView*)scrollView
{
    if (label.frame.size.width > scrollView.frame.size.width)
    {
        [UIView animateWithDuration:2.5f
                         animations:^{
                             [label setFrame:CGRectMake((185                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    -label.frame.size.width), 0 , label.frame.size.width, 20)];
                         } completion:^(BOOL finished) {
                             [self backwardAnimationWithLabel:label andScrollView:scrollView];
                         }];
        [UIView commitAnimations];
        
    }
}


-(void) backwardAnimationWithLabel:(UILabel *)label andScrollView:(UIScrollView*)scrollView
{
    [UIView animateWithDuration:2.5f
                     animations:^{
                         [label setFrame:CGRectMake(0, 0 , label.frame.size.width, 20)];
                     } completion:^(BOOL finished) {
                         [self forwardAnimationWithLabel:label andScrollView:scrollView];
                     }];
    [UIView commitAnimations];
    
    
}


-(void) setHistData
{
    NSLog(@"Setting Histiry");
    UIScrollView *histScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(110, 30, 240, 50)];
    
    NSArray *sortedArray = [self.fetchArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([[obj1 date] compare: [obj2 date]]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (![[obj1 date] compare: [obj2 date]]) {
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
    
    
    
    for (NSManagedObject *product in sortedArray)
    {
        Exercise *exercise = (Exercise*)product;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSDate *btnDate =[format dateFromString:self.dateButton.titleLabel.text];
        [format release];
        NSString *newString = [[self.exerciseName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] componentsJoinedByString:@""];
        NSString *newStr = [newString substringFromIndex:1];
        if ([exercise.name isEqualToString:newStr])
        {
            NSLog(@"1: %@", exercise.date);
            NSLog(@"2: %@", btnDate);
            if ([exercise.date compare:btnDate] == NSOrderedAscending)
            {
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateStyle:NSDateFormatterShortStyle];
                NSLocale *locale = [NSLocale currentLocale];
                [format setTimeZone:[NSTimeZone systemTimeZone]];
                [format setLocale:locale];
                
                //    [format setDateFormat:@"dd MMM yyyy"];
                NSString *dateStr = [format stringFromDate:exercise.date];
                [format release];
                [self.dateLabel setBackgroundColor:[UIColor clearColor]];
                [self.dateLabel setText:dateStr];
                
                
                NSMutableArray *dataArray = [[[NSMutableArray alloc] init] autorelease];
                for (int v = 0; v < [[exercise.detail allObjects] count]; v++) {
                    Detail *detail = (Detail*)[[exercise.detail allObjects] objectAtIndex:v];
                    [dataArray addObject:detail];
                }
                NSArray *sortedArray = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                    
                    if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                
                for (int d = 0; d < [sortedArray count]; d++)
                {
                    if ([[sortedArray objectAtIndex:d]reps] != nil)
                    {
                        UILabel *repsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50* d, 33, 40, 10)];
                        [repsLabel setFont:[UIFont systemFontOfSize:13]];
                        [repsLabel setBackgroundColor:[UIColor clearColor]];
                        [repsLabel setTextColor:[UIColor darkGrayColor]];
                        [repsLabel setText:[NSString stringWithFormat:@"%@",[[sortedArray objectAtIndex:d]reps] ]];
                        UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(50* d, 0, 40, 10)];
                        [weightLabel setFont:[UIFont systemFontOfSize:13]];
                        [weightLabel setBackgroundColor:[UIColor  clearColor]];
                        [weightLabel setTextColor:[UIColor darkGrayColor]];
                        [weightLabel setText:[NSString stringWithFormat:@"%.2f", [[[sortedArray objectAtIndex:d]weight] floatValue]]];
                        [histScroll addSubview:repsLabel];
                        [histScroll addSubview:weightLabel];
                        [repsLabel release];
                        [weightLabel release];
                        
                    }
                }
                
                [histScroll setContentSize:CGSizeMake([sortedArray count]* 50, 50)];
                self.wLabrl.text = NSLocalizedString(@"Weight", nil);
                self.rLabel.text = NSLocalizedString(@"Repetitions", nil);
                [self.lvLabel setText:NSLocalizedString(@"Last values", nil)];
                [histScroll setUserInteractionEnabled:YES];
                [self.histView addSubview:histScroll];
                [histScroll release];
                NSLog(@"datelabel: %@", self.dateLabel);
                
                return;
            }else{
                NSLog(@"datelabel: %@", self.dateLabel);
                [self.dateLabel setText:@""];
                self.wLabrl.text = NSLocalizedString(@"Weight", nil);
                self.rLabel.text = NSLocalizedString(@"Reps", nil);
                [self.lvLabel setText:NSLocalizedString(@"Last values", nil)];
                
            }
            
            
        }
        
    }
}

//-(void)back
//{
//    NSLog(@"Back");
//    [self.navigationController popViewControllerAnimated:YES];
//    [tickPlayer stop];
//}

-(void)saveToFile
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playPips)
                                               object:nil];
    BOOL fill = NO;
    if ([repsArray count] != 0) {
        for (int k = 0; k< ([weightArray count]-1); k++) {
            if (([[[repsArray objectAtIndex:k] text] isEqualToString:@""])  || ([[repsArray objectAtIndex:k] text] == nil) ){
                if ([[[weightArray objectAtIndex:k] text] intValue]== 0) {
                    
                }
                else{
                    UITextField *textField = [repsArray objectAtIndex:k];
                    
                    [textField setBorderStyle:UITextBorderStyleLine];
                    textField.layer.borderColor=[[UIColor redColor]CGColor];
                    textField.layer.borderWidth= 1.0f;
                    fill = YES;
                }
            }
            
        }
    }else {
        
        [self.delegate back];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (fill) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil)
                                                          message:NSLocalizedString(@"Fill up all the blank repetitions boxes.", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                otherButtonTitles:nil];
        [message show];
        [message release];
        return;
    }
    
    checkEdit = NO;
    [self DeletExercise];
    //    if(!poundsCheck){
    //        [self performSelector:@selector(convertToPounds:)];
    //    }
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [format setTimeZone:[NSTimeZone systemTimeZone]];
    [format setLocale:locale];
    NSDate *exercDate = [format dateFromString:self.dateButton.titleLabel.text];
    [format release];
    if ([repsArray count] != 1)
    {
        NSLog(@"reps array: %@", repsArray);
        Exercise * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise"
                                                            inManagedObjectContext:self.managedObjectContext];
        NSString *newString = [[self.exerciseName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"1234567890"] ] componentsJoinedByString:@""];
        NSLog(@"New string: %@", newString);
        NSString *newStr = [newString substringFromIndex:1];
        newEntry.name = newStr;
        newEntry.workout = self.workout;
        if ([self.photoArr count] != 0) {
            newEntry.link = [self.photoArr objectAtIndex:0];
        }
        
        newEntry.date = exercDate;
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (int  c = 0; c < [repsArray count]; c++)
        {
            Detail * detail = [NSEntityDescription insertNewObjectForEntityForName:@"Detail"
                                                            inManagedObjectContext:self.managedObjectContext];
            if ([[[repsArray objectAtIndex:c] text] isEqualToString:@""] || ([[[repsArray objectAtIndex:c] text] intValue] == 0)) {continue;
            }else
            {
                detail.reps = [NSNumber numberWithInt:[[[repsArray objectAtIndex:c] text] intValue] ];
                if (c< [weightArray count])
                {
                    detail.weight = [NSNumber numberWithFloat:[[[weightArray objectAtIndex:c] text] floatValue] ];
                }
                [dataArray addObject:detail];
                
                detail.sort = [NSNumber numberWithInt:c] ;
                //                NSLog(@"Poundscheck : %d", (int)[poundsCheck boolValue]);
                
                //                if (poundsCheck == 1) {
                detail.kg_lbs = [NSNumber numberWithBool:poundsCheck];
                //                }else{
                //
                //                    detail.kg_lbs = 0;
                //            }
            }
            
        }
        newEntry.detail = [NSSet setWithArray:dataArray];
        
        [dataArray release];
        NSLog(@"exercise %@", newEntry);
        NSLog(@"weight array: %@", weightArray);
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error");
        }
        
    }
    
    //    [UIView animateWithDuration:0.5
    //                     animations:^{
    //                         titleLabel.frame = CGRectMake(500, 10, 240, 16);
    //                         titleLabel.alpha = 0.0;
    //                     }
    //                     completion:^(BOOL finished){
    [titleLabel removeFromSuperview];
    //
    //
    //                     }
    //     ];
    //    [UIView commitAnimations];
    [self.delegate back];
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void) saveDataForDate
{
    NSLog(@"save data");
    checkEdit = NO;
    BOOL fill = NO;
    if ([repsArray count] > 1) {
        for (int k = 0; k< ([weightArray count]-1); k++) {
            if (([[[repsArray objectAtIndex:k] text] isEqualToString:@""])  || ([[repsArray objectAtIndex:k] text] == nil) ){
                
                fill = YES;
                
            }
            
        }
    }else {
        
        return;
    }
    
    [self DeletExercise];
    //    if(!poundsCheck){
    //        [self performSelector:@selector(convertToPounds:)];
    //    }
    if (!fill)
    {
        NSLog(@"Fill");
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSDate *exercDate = [format dateFromString:self.dateButton.titleLabel.text];
        [format release];
        if ([repsArray count] != 1)
        {
            NSLog(@"reps array: %@", repsArray);
            Exercise * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise"
                                                                inManagedObjectContext:self.managedObjectContext];
            NSString *newString1 = [[self.exerciseName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] componentsJoinedByString:@""];
            NSString *newStr = [newString1 substringFromIndex:1];
            newEntry.name = newStr;
            newEntry.workout = self.workout;
            if ([self.photoArr count] !=0) {
                newEntry.link = [self.photoArr objectAtIndex:0];
            }
            
            newEntry.date = exercDate;
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (int  c = 0; c < [repsArray count]; c++)
            {
                Detail * detail = [NSEntityDescription insertNewObjectForEntityForName:@"Detail"
                                                                inManagedObjectContext:self.managedObjectContext];
                if ([[[repsArray objectAtIndex:c] text] isEqualToString:@""] || ([[[repsArray objectAtIndex:c] text] intValue] == 0)) {continue;
                }else
                {
                    detail.reps = [NSNumber numberWithInt:[[[repsArray objectAtIndex:c] text] intValue] ];
                    if (c< [weightArray count])
                    {
                        detail.weight = [NSNumber numberWithFloat:[[[weightArray objectAtIndex:c] text] floatValue] ];
                    }
                    [dataArray addObject:detail];
                    
                    detail.sort = [NSNumber numberWithInt:c] ;
                    //                NSLog(@"Poundscheck : %d", (int)[poundsCheck boolValue]);
                    
                    //                if (poundsCheck == 1) {
                    detail.kg_lbs = [NSNumber numberWithBool:poundsCheck];
                    //                }else{
                    //
                    //                    detail.kg_lbs = 0;
                    //            }
                }
                
            }
            newEntry.detail = [NSSet setWithArray:dataArray];
            
            [dataArray release];
            NSLog(@"exercise %@", newEntry);
            NSLog(@"weight array: %@", weightArray);
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Error");
            }
            
        }
    }
    
}

- (void)DeletExercise
{
    GuideAppDelegate *appDelegate = (GuideAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    for (NSManagedObject *product in self.fetchArray) {
        Exercise *exercise = (Exercise*)product;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSString *exercDate = [format stringFromDate:exercise.date];
        NSString *newString = [[self.exerciseName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] componentsJoinedByString:@""];
        NSString *newStr = [newString substringFromIndex:1];
        NSString *newString1 = [[exercise.name componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] componentsJoinedByString:@""];
        
        if (([exercDate isEqualToString:self.dateButton.titleLabel.text]) && ([newString1 isEqualToString:newStr])){
            [context deleteObject:product];
            NSLog(@"Deleting...");
        }
        [format release];
        
    }
    NSError *error;
    [context save:&error];
}


-(void)setTitleForExercise:(NSString *)stringForTitle
{
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)] autorelease];
    [self.nameLabel setFont:[UIFont fontWithName:@"Lucida Grande" size:18]];
    [self.nameLabel setText:[[NSString stringWithFormat:@"%@",NSLocalizedString(@"", nil)] stringByAppendingString:stringForTitle]];
    [self.nameLabel setBackgroundColor:[UIColor clearColor]];
    [self.nameLabel setTextColor:[UIColor clearColor]];
    CGSize maximumLabelSize = CGSizeMake(9999, 9999);
    CGSize expectedLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.nameLabel.lineBreakMode];
    
    //adjust the label the the new width.
    CGRect newFrame = self.nameLabel.frame;
    newFrame.size.width = expectedLabelSize.width;
    self.nameLabel.frame = newFrame;
    [self.view insertSubview:self.nameLabel aboveSubview:self.dateButton];
    if (self.nameLabel.frame.size.width > self.view.frame.size.width)
    {
        [self forwardLabelAnimation];
        
    }
}

-(void)forwardLabelAnimation
{
    [UIView animateWithDuration:2.5f
                     animations:^{
                         [self.nameLabel setFrame:CGRectMake((self.view.frame.size.width - self.nameLabel.frame.size.width), self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                     } completion:^(BOOL finished) {
                         [self backwardLAbelAnimation];
                     }];
}

-(void)backwardLAbelAnimation
{
    [UIView animateWithDuration:2.5f
                     animations:^{
                         [self.nameLabel setFrame:CGRectMake(0, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(forwardLabelAnimation) withObject:nil afterDelay:3.0f];
                     }];
}

-(void)filltextFieldsWithData
{
    i=0;
    r=2;
    w=3;
    BOOL a = NO ;
    if( SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        repsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(74, 50, 230, 65)];
    }else{
        
        if (IS_HEIGHT_GTE_568) {
            repsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(74, 120, 230, 65)];
        }else{
            repsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(74, 120, 230, 65)];
        }
    }
    [repsArray removeAllObjects];
    [weightArray removeAllObjects];
    if ([self.fetchArray count] != 0)
    {
        [lbl  removeFromSuperview];
        [self.repsButton setAlpha:1];
        [self.weightButton setAlpha:1];
        for (int f = 0; f < [self.fetchArray count]; f++) {
            Exercise * record = [self.fetchArray objectAtIndex:f];
            NSString *newString = [[self.exerciseName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] componentsJoinedByString:@""];
            NSString *newStr = [newString substringFromIndex:1];
            NSString *newString1 = [[[[self.fetchArray objectAtIndex:f] name] componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] componentsJoinedByString:@""];
            //            NSString *newStr1 = [newString1 substringFromIndex:1];
            NSLog(@"Name ; %@", record.name);
            NSLog(@"work 2 ; %@", record.workout);
            
            if ([newString1 isEqualToString:newStr])
            {
                NSMutableArray *dataArray = [[[NSMutableArray alloc] init] autorelease];
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateStyle:NSDateFormatterShortStyle];
                NSLocale *locale = [NSLocale currentLocale];
                [format setTimeZone:[NSTimeZone systemTimeZone]];
                [format setLocale:locale];
                NSString * str = [format stringFromDate:record.date];
                [format release];
                if ([_dateButton.titleLabel.text isEqualToString:str])
                {
                    for (int v = 0; v < [[record.detail allObjects] count]; v++)
                    {
                        Detail *detail = (Detail*)[[record.detail allObjects] objectAtIndex:v];
                        [dataArray addObject:detail];
                        poundsCheck = [detail.kg_lbs boolValue];
                        NSLog(@" %d",(int)poundsCheck);
                    }
                    NSArray *sortedArray = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                        
                        if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue])
                        {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        
                        if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue])
                        {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
                    
                    for (int d = 0; d < [sortedArray count]; d++)
                    {
                        if ([[sortedArray objectAtIndex:d]reps] != nil)
                        {
                            a = YES;
                            repsTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 35, 50, 25)];
                            [repsTxt setBorderStyle:UITextBorderStyleBezel];
                            repsTxt.keyboardType = UIKeyboardTypeDecimalPad;
                            repsTxt.font = [UIFont systemFontOfSize:14];
                            repsTxt.borderStyle = UITextBorderStyleNone;
                            repsTxt.textAlignment = 1;
                            repsTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                            //                        [repsTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                            repsTxt.textColor =UIColorFromRGB(0x133361);
                            repsTxt.delegate = self;
                            repsTxt.tag = r;
                            repsTxt.text =[NSString stringWithFormat:@"%.0f", [[[sortedArray objectAtIndex:d]reps] floatValue]] ;
                            [repsTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                            weightTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 0, 50, 25)];
                            [weightTxt setBorderStyle:UITextBorderStyleNone];
                            weightTxt.textAlignment = 1;
                            weightTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                            
                            //                        [weightTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                            weightTxt.keyboardType = UIKeyboardTypeDecimalPad;
                            weightTxt.font = [UIFont systemFontOfSize:14];
                            weightTxt.borderStyle = UITextBorderStyleNone;
                            weightTxt.textColor = UIColorFromRGB(0x133361);
                            weightTxt.delegate = self;
                            weightTxt.tag = w;
                            weightTxt.text = [NSString stringWithFormat:@"%.2f", [[[sortedArray objectAtIndex:d]weight] floatValue]];
                            [weightTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                            [repsScroll addSubview:weightTxt];
                            [repsScroll addSubview:repsTxt];
                            [repsScroll setAlpha:0.7];
                            [repsArray addObject:repsTxt];
                            [weightArray addObject:weightTxt];
                            [repsTxt release];
                            [weightTxt release];
                            w += 2;
                            r += 2;
                            i++;
                            
                        }
                        
                    }
                    
                }
                
                
                
                
            }
            
        }
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [format setTimeZone:[NSTimeZone localTimeZone]];
    [format setLocale:locale];
    NSDate * checkDate = [format dateFromString:self.dateButton.titleLabel.text];
    [format release];
    if ([selectedDate compare:[NSDate date]] <=0)
    {
        a = YES;
        [lbl  removeFromSuperview];
        [self.repsButton setAlpha:1];
        [self.weightButton setAlpha:1];
        repsTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 35, 50, 25)];
        repsTxt.keyboardType = UIKeyboardTypeDecimalPad;
        repsTxt.font = [UIFont systemFontOfSize:14];
        repsTxt.textAlignment = 1;
        repsTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        repsTxt.borderStyle = UITextBorderStyleNone;
        repsTxt.textColor = UIColorFromRGB(0x133361);
        [repsTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
        repsTxt.delegate = self;
        repsTxt.tag = r;
        weightTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 0, 50, 25)];
        weightTxt.keyboardType = UIKeyboardTypeDecimalPad;
        weightTxt.font = [UIFont systemFontOfSize:14];
        weightTxt.textAlignment = 1;
        weightTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        weightTxt.borderStyle = UITextBorderStyleNone;
        weightTxt.textColor = UIColorFromRGB(0x133361);
        [weightTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
        weightTxt.delegate = self;
        weightTxt.tag = w;
        [repsScroll addSubview:weightTxt];
        [repsScroll addSubview:repsTxt];
        [repsScroll setAlpha:0.7];
        [repsArray addObject:repsTxt];
        [weightArray addObject:weightTxt];
        [repsTxt release];
        [weightTxt release];
        w += 2;
        r += 2;
        i++;
        
    }
    if (!a) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, 270, 100)];
        }else{
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 90, 270, 100)];
        }
        
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[UIColor darkGrayColor]];
        [lbl setText:NSLocalizedString(@"You can't input data for future dates.", nil)];
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.numberOfLines = 2;
        [self.view insertSubview:lbl belowSubview:self.dateButton];
        [self.repsButton setAlpha:0];
        [self.weightButton setAlpha:0];
    }
    if (poundsCheck == 1) {
        [self.weightButton setTitle:NSLocalizedString(@"Weight(kg)", nil) forState:UIControlStateNormal];
    } else
        
    {
        [self.weightButton setTitle:NSLocalizedString(@"Weight(lbs)", nil) forState:UIControlStateNormal];
    }
    repsScroll.contentSize =CGSizeMake((float)50*(r/2), 54);
    [self.view insertSubview:repsScroll belowSubview:_dateButton];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"Should end editing");
    for (UITextField *textFieldA in weightArray){
        if (textField == textFieldA) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            textField.text = [ NSString stringWithFormat:@"%.2f",[[textField text] floatValue]];
            [textField resignFirstResponder];
        }
    }
    if ([textField.text intValue]>500) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil)
                                                          message:NSLocalizedString(@"You can't use values bigger than 500.", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                otherButtonTitles:nil];
        [message show];
        [message release];
        textField.text = @"0.0";
    }
    
    return  YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    //    textField.text = @"";
    
    //    textField.layer.borderColor = [[UIColor blueColor] CGColor];
    //    textField.layer.borderWidth = 0.01;
    ////    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    ////    [textField setBorderStyle:UITextBorderStyleNone];
    
    
    
    checkEdit = YES;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [format setTimeZone:[NSTimeZone systemTimeZone]];
    [format setLocale:locale];
    
    //    NSString * str = [format stringFromDate:[NSDate date]];
    NSDate *checkDate = [format dateFromString:_dateButton.titleLabel.text];
    [format release];
    NSString *string = textField.text;
    
    //    if ([_dateButton.titleLabel.text isEqualToString: str])
    if ([selectedDate compare:[NSDate date]] <=0)
        if (string.length == 0)
        {
            if (textField.tag  == w -2)
            {
                repsTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 35, 50, 25)];
                repsTxt.keyboardType = UIKeyboardTypeDecimalPad;
                repsTxt.font = [UIFont systemFontOfSize:14];
                repsTxt.textAlignment = 1;
                repsTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                repsTxt.borderStyle = UITextBorderStyleNone;
                repsTxt.textColor =UIColorFromRGB(0x133361);
                [repsTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                repsTxt.delegate = self;
                repsTxt.tag = r;
                weightTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 0, 50, 25)];
                weightTxt.keyboardType = UIKeyboardTypeDecimalPad;
                weightTxt.font = [UIFont systemFontOfSize:14];
                weightTxt.textAlignment = 1;
                weightTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                weightTxt.borderStyle = UITextBorderStyleNone;
                weightTxt.textColor = UIColorFromRGB(0x133361);
                [weightTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                weightTxt.delegate = self;
                weightTxt.tag = w;
                
                repsScroll.contentSize =CGSizeMake((float)50*(r/2), 54);
                if ( i  >= 4)
                {
                    
                    [repsScroll setContentOffset:CGPointMake(repsScroll.contentOffset.x+50, 0) animated:YES];
                }
                
                
                [repsScroll addSubview:repsTxt];
                [repsScroll addSubview:weightTxt];
                [repsArray addObject:repsTxt];
                [weightArray addObject:weightTxt];
                [repsTxt release];
                [weightTxt release];
                i++;
                r +=2;
                w +=2;
            }
            else if (textField.tag  == r -2)
            {
                
                repsTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 35, 50, 25)];
                repsTxt.keyboardType = UIKeyboardTypeDecimalPad;
                repsTxt.font = [UIFont systemFontOfSize:14];
                repsTxt.textAlignment = 1;
                repsTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                repsTxt.borderStyle = UITextBorderStyleNone;
                repsTxt.textColor =UIColorFromRGB(0x133361);
                [repsTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                repsTxt.delegate = self;
                repsTxt.tag = r;
                weightTxt = [[UITextField alloc] initWithFrame:CGRectMake(i*50, 0, 50, 25)];
                weightTxt.keyboardType = UIKeyboardTypeDecimalPad;
                weightTxt.font = [UIFont systemFontOfSize:14];
                weightTxt.textAlignment = 1;
                weightTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                weightTxt.borderStyle = UITextBorderStyleNone;
                weightTxt.textColor = UIColorFromRGB(0x133361);
                [weightTxt setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
                weightTxt.delegate = self;
                weightTxt.tag = w;
                
                repsScroll.contentSize =CGSizeMake((float)50*(r/2), 54);
                if ( i  >= 4)
                {
                    
                    [repsScroll setContentOffset:CGPointMake(repsScroll.contentOffset.x+50, 0) animated:YES];
                }
                
                
                [repsScroll addSubview:repsTxt];
                [repsScroll addSubview:weightTxt];
                [repsArray addObject:repsTxt];
                [weightArray addObject:weightTxt];
                [repsTxt release];
                [weightTxt release];
                i++;
                r +=2;
                w +=2;
            }
        }
    [textField setBackground:[UIImage imageNamed:@"cell_completat@2x.png"]];
    return YES;
}



-(IBAction)makeKeyboardGoAway
{
    //    for (int count1 = 0; count1 < [repsScroll.subviews count]; count1 ++) {
    //        [[repsScroll.subviews objectAtIndex:count1] resignFirstResponder];
    //    }
    [self.view endEditing:YES];
    //    [self.histView setAlpha:0];
}

-(void)backToParrent
{
    [self.delegate back];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem.leftBarButtonItem setStyle:nil];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonSystemItemDone target:self action:@selector(makeKeyboardGoAway)];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];
    [saveButtonItem release];
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonSystemItemEdit];
    
    //Assign new frame to your view
    if ([self.dateLabel.text isEqualToString:@""]){
    }else{
        [self.histView setFrame:CGRectMake(0, 500, self.histView.frame.size.width, self.histView.frame.size.height)];
        [self.histView setAlpha:1.0];
        
        [UIView animateWithDuration:0.4f animations:^{
            //    [self.view setFrame:CGRectMake(0,-75,self.view.frame.size.width,self.view.frame.size.height)];
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                if (IS_HEIGHT_GTE_568) {
                    [self.histView setFrame:CGRectMake(0, 206.5, self.histView.frame.size.width, self.histView.frame.size.height)];
                }else{
                    [self.histView setFrame:CGRectMake(0, 115, self.histView.frame.size.width, self.histView.frame.size.height)];}
            }else{
                if (IS_HEIGHT_GTE_568) {
                    [self.histView setFrame:CGRectMake(0, 266.5, self.histView.frame.size.width, self.histView.frame.size.height)];
                }else{
                    [self.histView setFrame:CGRectMake(0, 180, self.histView.frame.size.width, self.histView.frame.size.height)];
                }
            }
            
        }];
    }
    
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //   self.navigationItem.leftBarButtonItem = backBtnAux;
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonSystemItemCancel target:self action:@selector(saveToFile)];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];
    [saveButtonItem release];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonSystemItemCancel target:self action:@selector(backToParrent)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    
    
    if ([self.dateLabel.text isEqualToString:@""]){
        
    }else{
        [UIView animateWithDuration:0.2f animations:^{
            [self.histView setFrame:CGRectMake(0, 600, self.histView.frame.size.width, self.histView.frame.size.height)];
            
        }completion:^(BOOL finished){
            [self.secBtn setAlpha:1.0];
            [self.secbutton setAlpha:1.0];
            //    [self.stopwatchView setAlpha:1];
        }];
        
    }
    
}

- (IBAction)convertToPounds:(id)sender
{
    
    if (poundsCheck == 1)
        for (int count = 0; count< [weightArray count]; count++) {
            //            NSLog(@"String: %@", [[weightArray objectAtIndex:count] text]);
            NSString *stri = [[weightArray objectAtIndex:count] text];
            float pounds = [stri floatValue];
            [[weightArray objectAtIndex:count] setText:[[[NSString alloc] initWithFormat:@"%.2f",(pounds * 1000/453.59237)] autorelease]];
            [self.weightButton setTitle:NSLocalizedString(@"Weight(lbs)", nil) forState:UIControlStateNormal];
            poundsCheck = 0;
        }else
            if (!poundsCheck)
                for (int count = 0; count< [weightArray count]; count++)
                {
                    NSString *stri = [[weightArray objectAtIndex:count] text];
                    float pounds = [stri floatValue];
                    [[weightArray objectAtIndex:count] setText:[[[NSString alloc] initWithFormat:@"%.2f",(pounds*453.59237 / 1000)] autorelease]];
                    poundsCheck = 1;
                    [self.weightButton setTitle:NSLocalizedString(@"Weight(kg)", nil) forState:UIControlStateNormal];
                    
                }
    
}



#pragma mark - DateButton Methods


-(IBAction)dateButtonPressed:(id)sender
{
    //    VRGCalendarView *calendar;
    [self makeKeyboardGoAway];
    
    if(tapCount == YES)
    {
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             [calView setAlpha:1.0f];
                             //                             [self.calendarView setAlpha:1.0f];
                             [self.closeClaImg setAlpha:1.0f];
                             [self.closeCalBtn setHidden:NO];
                             
                         }
         ];
        
        [UIView commitAnimations];
        tapCount = NO;
        self.auxDateBtn.enabled = NO;
        self.closeCalBtn.enabled = YES;
        
        
    }
    else if (tapCount == NO)
    {
        //        [repsScroll removeFromSuperview];
        //        [repsScroll release];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [calView setAlpha:0.0f];
                             
                             //                             [self.calendarView setAlpha:0.0f];
                             [self.closeClaImg setAlpha:0.0f];
                             [self.closeCalBtn setHidden:YES];
                             
                         }completion:^(BOOL finished) {
                             //                             [calendar removeFromSuperview];
                             
                         }
         ];
        [UIView commitAnimations];
        
        tapCount = YES;
        self.auxDateBtn.enabled = YES;
        self.closeCalBtn.enabled = NO;
        //        [self filltextFieldsWithData];
    }
    
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    //    if (month==[[NSDate date] month]) {
    //        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
    //        [calendarView markDates:dates];
    //    }
    //    NSArray *date = [NSArray arrayWithObjects:[NSDate date], nil];
    
    NSArray *color = [NSArray arrayWithObjects:[UIColor redColor],nil];
    NSLog(@"Disable ddates: %@" , disabledDates);
    [calendarView markDates:[disabledDates retain] withColors:color];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [calView setAlpha:0.0f];
                         [self.closeClaImg setAlpha:0.0f];
                         
                         //                             [self.calendarView setAlpha:0.0f];
                         //                             [self.closeClaImg setAlpha:0.0f];
                     }completion:^(BOOL finished) {
                         //                             [calendar removeFromSuperview];
                         
                     }
     ];
    [UIView commitAnimations];
    [self saveDataForDate];
    GuideAppDelegate* appDelegate = (GuideAppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchArray = [appDelegate getAllexercises];
    disabledDates = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:locale];
    
    for (NSManagedObject *product in self.fetchArray)
        
    {
        Exercise *exercise = (Exercise*)product;
        NSString *date = [formatter stringFromDate:exercise.date];
        NSLog(@"date: %@", date);
        NSDate *newDate = [formatter dateFromString:date];
        NSLog(@"New date: %@", newDate);
        [disabledDates addObject:newDate];
        //        [newDate release];
        
    }
    [formatter release];
    NSArray *color = [NSArray arrayWithObjects:[UIColor redColor],nil];
    NSLog(@"Disable ddates: %@" , disabledDates);
    [calendarView markDates:[disabledDates retain] withColors:color];
    tapCount = YES;
    self.auxDateBtn.enabled = YES;
    self.closeCalBtn.enabled = NO;
    
    [repsScroll removeFromSuperview];
    [repsScroll release];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setTimeZone:[NSTimeZone systemTimeZone]];
    [format setLocale:locale];
    sDate = date;
    
    dateString = [format stringFromDate:date];
    [format release];
    [_dateButton setTitle:[NSString stringWithFormat:@"%@", dateString] forState:UIControlStateNormal];
    //    [UIView animateWithDuration:0.2f
    //                     animations:^{
    //                         [calendar setAlpha:0.0f];
    //                         [self.closeClaImg setAlpha:0.0f];
    //                         [self.calendarView setAlpha:0.0f];
    //                     }completion:^(BOOL finished) {
    //                     }
    //     ];
    //    [UIView commitAnimations];
    //    tapCount = YES;
    selectedDate = date;
    [self filltextFieldsWithData];
    
    
    
    
}


//- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
//    // If the date has been chosen by the user, go ahead and style it differently
//
//    if ([disabledDates containsObject:date]) {
//        //        dateItem.backgroundColor = [UIColor greenColor];
//        UIImageView *markImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark_calendar@2x.png"]];
//        [markImg setFrame:CGRectMake(10, 20, markImg.frame.size.width, markImg.frame.size.height)];
//        dateItem.markDayImage = markImg;
//        [markImg release];
//    }else{
//        dateItem.markDayImage = nil;
//    }
//
//}
//
//
//- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date
//{
//    calendar.onlyShowCurrentMonth = NO;
//    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
//    [calendar setBackgroundColor:[UIColor clearColor]];
//    [calendar setDateBorderColor:[UIColor clearColor]];
//    calendar.frame = CGRectMake(self.dateButton.frame.origin.x,self.dateButton.frame.origin.y, 300, 300);;
//
//}
//
//- (BOOL)dateIsDisabled:(NSDate *)date
//{
//    return NO;
//}
//
//- (BOOL)calendar:(CKCalendarView *)calendars willSelectDate:(NSDate *)date {
//    return ![self dateIsDisabled:date];
//}
//
//- (BOOL)calendar:(CKCalendarView *)calendars willChangeToMonth:(NSDate *)date {
//    if ([date laterDate:minimumDate] == date) {
//        calendar.backgroundColor = [UIColor blueColor];
//        return YES;
//    } else {
//        calendar.backgroundColor = [UIColor blueColor];
//        return NO;
//    }
//    //    calendar = nil;
//    //    [calendar release];
//    //    disabledDates = nil;
//    //    disabledDates = @[
//    //                      [dateFormatter dateFromString:@"05/09/2013"],
//    //                      [dateFormatter dateFromString:@"06/10/2013"],
//    //                      [dateFormatter dateFromString:@"07/08/2013"]
//    //                      ];
//
//    //    calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
//
//}
//
//- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
//}
//- (void)calendar:(CKCalendarView *)calendars didSelectDate:(NSDate *)date {
//    [repsScroll removeFromSuperview];
//    [repsScroll release];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateStyle:NSDateFormatterShortStyle];
//    NSLocale *locale = [NSLocale currentLocale];
//    [format setTimeZone:[NSTimeZone systemTimeZone]];
//    [format setLocale:locale];
//    sDate = date;
//
//    dateString = [format stringFromDate:date];
//    [format release];
//    [_dateButton setTitle:[NSString stringWithFormat:@"%@", dateString] forState:UIControlStateNormal];
//    [UIView animateWithDuration:0.2f
//                     animations:^{
//                         [calendar setAlpha:0.0f];
//                         [self.closeClaImg setAlpha:0.0f];
//                         [self.calendarView setAlpha:0.0f];
//                     }completion:^(BOOL finished) {
//                     }
//     ];
//    [UIView commitAnimations];
//    tapCount = YES;
//    [self filltextFieldsWithData];
//
//}
//
//
//- (NSDate *)_nextDay:(NSDate *)date {
//    NSDateComponents *comps = [[NSDateComponents new] autorelease];
//    [comps setDay:1];
//    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    return [gregorian dateByAddingComponents:comps toDate:date options:0];
//}


#pragma mark - timer shit

-(IBAction)stopTickcing:(id)sender
{
    [tickPlayer stop];
    [[MPMusicPlayerController applicationMusicPlayer] play];
}

-(IBAction)setSeconds:(id)sender
{
    if (![timer isValid]){
        NSString *actionSheetTitle = NSLocalizedString(@"Set seconds", nil); //Action Sheet Title
        NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"30", @"45", @"60", @"90", @"120", @"180", nil];
        [actionSheet showInView:self.view];}else{
            NSString *actionSheetTitle = NSLocalizedString(@"Set seconds", nil); //Action Sheet Title
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          destructiveButtonTitle:NSLocalizedString(@"Stop", nil)
                                          otherButtonTitles:@"30", @"45", @"60", @"90", @"120", @"180", nil];
            [actionSheet showInView:self.view];
        }
}

-(void)repeatJobWithTime:(NSString *)time
{
    NSDateFormatter *timerFormat = [[NSDateFormatter alloc] init];
    [timerFormat setDateFormat:@"mm:ss:SS"];
    
    NSString *date;
    date = [timerFormat stringFromDate:[NSDate dateWithTimeInterval:(j) sinceDate:[timerFormat dateFromString:@"00:00:00"]]] ;
    [timerFormat release];
    [self.stopwatchLabel setText:date];
    
    j= j+ 0.1;
    
    if ([date isEqualToString:timerString]) {
        [timer invalidate];
        timer = nil;
        [tickPlayer stop];
        
        [self.stopwatchLabel setText:labelString];
        [[MPMusicPlayerController applicationMusicPlayer] play];
    }
    
    
}

//- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag
//{
//    if (appSoundPlayer.duration > 3) {
//        [tickPlayer stop];
//    }
//
//
//}

-(void)playPips
{
    NSURL* path2 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                           pathForResource:@"clock_pips"
                                           ofType:@"mp3"]];
    pipPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path2 error:nil];
    [pipPlayer retain];
    [pipPlayer prepareToPlay];
    [pipPlayer play];
    
    [pipPlayer setDelegate:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [UIApplication sharedApplication].idleTimerDisabled = sleep ;
    [UIApplication sharedApplication].idleTimerDisabled = !sleep ;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playPips)
                                               object:nil];
    if (actionSheet.destructiveButtonIndex == 0) {
        buttonIndex --;
    }
    if (buttonIndex == -1) {
        [timer invalidate];
        [tickPlayer stop];
        [pipPlayer stop];
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(playPips)
                                                   object:nil];
        
        timer = nil;
        sec = 0;
    }
    if  ( buttonIndex == 0) {
        
        NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"clock_pips_2.1_sek"
                                              ofType:@"mp3"]];
        [tickPlayer stop];
        [tickPlayer release];
        tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        
        [tickPlayer retain];
        [tickPlayer prepareToPlay];
        [tickPlayer setDelegate:self];
        [tickPlayer setNumberOfLoops:-1];
        j = 0.00;
        
        [timer invalidate];
        timer = nil;
        
        // Creating a timer that call repeatJob every 1.0 sec
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(repeatJobWithTime:) userInfo:nil repeats:YES];
        
        timerString = @"00:30:00";
        labelString = timerString;
        [tickPlayer retain];
        [tickPlayer play];
        tickPlayer.numberOfLoops = 15;
        //        //killing timer
        //        if([timer isValid]){
        //            [timer invalidate];
        //            timer = nil;
        //        }
        sec = 30;
        [self performSelector:@selector(playPips) withObject:nil afterDelay:26];
        
    }
    if (buttonIndex == 1) {
        NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"clock_pips_2.1_sek"
                                              ofType:@"mp3"]];
        [tickPlayer stop];
        [tickPlayer release];
        tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        [tickPlayer retain];
        tickPlayer.delegate = self;
        [tickPlayer setNumberOfLoops:-1];
        [tickPlayer prepareToPlay];
        [timer invalidate];
        j = 0.00;
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(repeatJobWithTime:) userInfo:nil repeats:YES];
        timerString = @"00:45:00";
        labelString = timerString;
        [tickPlayer retain];
        [tickPlayer play];
        
        tickPlayer.numberOfLoops = 23;
        [self performSelector:@selector(playPips) withObject:nil afterDelay:41];
        sec = 45;
    }
    if (buttonIndex == 2) {
        NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"clock_pips_2.1_sek"
                                              ofType:@"mp3"]];
        [tickPlayer stop];
        [tickPlayer release];
        tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        [tickPlayer retain];
        [tickPlayer prepareToPlay];
        tickPlayer.delegate = self;
        tickPlayer.numberOfLoops = -1;
        [timer invalidate];
        j = 0.00;
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(repeatJobWithTime:) userInfo:nil repeats:YES];
        timerString = @"01:00:00";
        labelString = @"01:00:00";
        [tickPlayer retain];
        [tickPlayer play];
        tickPlayer.numberOfLoops = 30;
        [self performSelector:@selector(playPips) withObject:nil afterDelay:56];
        sec = 60;
    }
    if (buttonIndex == 3) {
        NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"clock_pips_2.1_sek"
                                              ofType:@"mp3"]];
        [tickPlayer stop];
        [tickPlayer release];
        tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        [tickPlayer retain];
        [tickPlayer prepareToPlay];
        tickPlayer.delegate = self;
        tickPlayer.numberOfLoops = -1;
        [timer invalidate];
        j = 0.00;
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(repeatJobWithTime:) userInfo:nil repeats:YES];
        timerString = @"01:30:09";
        labelString = @"01:30:00";
        [tickPlayer retain];
        [tickPlayer play];
        tickPlayer.numberOfLoops = 45;
        [self performSelector:@selector(playPips) withObject:nil afterDelay:86];
        sec = 90;
    }
    if (buttonIndex == 4) {
        NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"clock_pips_2.1_sek"
                                              ofType:@"mp3"]];
        [tickPlayer stop];
        [tickPlayer release];
        tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        [tickPlayer retain];
        [tickPlayer prepareToPlay];
        tickPlayer.delegate = self;
        tickPlayer.numberOfLoops = -1;
        [timer invalidate];
        j=0.00;
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(repeatJobWithTime:) userInfo:nil repeats:YES];
        timerString = @"02:00:09";
        labelString = @"02:00:00";
        [tickPlayer retain];
        [tickPlayer play];
        tickPlayer.numberOfLoops = 60;
        [self performSelector:@selector(playPips) withObject:nil afterDelay:116];
        sec = 120;
    }
    if (buttonIndex == 5) {
        NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"clock_pips_2.1_sek"
                                              ofType:@"mp3"]];
        [tickPlayer stop];
        [tickPlayer release];
        tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        [tickPlayer retain];
        [tickPlayer prepareToPlay];
        tickPlayer.delegate = self;
        tickPlayer.numberOfLoops = -1;
        j = 0.00;
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(repeatJobWithTime:) userInfo:nil repeats:YES];
        timerString = @"03:00:00";
        labelString = timerString;
        [tickPlayer retain];
        [tickPlayer play];
        tickPlayer.numberOfLoops = 90;
        [self performSelector:@selector(playPips) withObject:nil afterDelay:176];
        sec = 180;
    }
}


#pragma mark - transition



- (void) makeTransitionfor:(UIViewController *)aController withTransitionStyle:(NSString *)aStyle{
    NSLog(@"Make transition");
    self.controll = aController;
    trtansStyle = aStyle;
    if (checkEdit) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil)
                                                          message:NSLocalizedString(@"Would you like to leave without saving?", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
        [message show];
        [message release];
    }else
    {
        [self  transitionMake];
    }
    
    
    
    
}

-(void)transitionMake{
    
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = trtansStyle;
    transition.duration = 0.25f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    
    //    [self.navigationController popToViewController:controll animated:NO];
    //    [controll release];
    [self.navigationController popViewControllerAnimated:NO];
    [CATransaction commit];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked");
    if (buttonIndex == 0) {
        [self transitionMake];
    }else{
        
    }
}


#pragma mark - Play The Movie
- (BOOL)jailbroken
{
    //    NSFileManager * fileManager = [NSFileManager defaultManager];
    //    NSString *filePath = @"/Applications/Cydia.app";
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    //    {
    //        return YES;
    //    }
    //    return [fileManager fileExistsAtPath:@"/private/var/lib/apt/"];
    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    return [[UIApplication sharedApplication] canOpenURL:url];
}
-(void)didEnterForeground
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playPips)
                                               object:nil];
    
    NSLog(@"Did enter Foreground");//    // must be ≥ 0
    if (isPlaying)
    {
        if (sec !=0) {
            
            NSString *secStr = [NSString stringWithFormat:@"clock_pips_2.1_sek"];
            NSLog(@"Peeps: %@", secStr);
            
            NSURL* path = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                  pathForResource:secStr
                                                  ofType:@"mp3"]];
            tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
            [tickPlayer retain];
            [tickPlayer prepareToPlay];
            [tickPlayer retain];
            [tickPlayer setDelegate:self];
            tickPlayer.numberOfLoops = -1;
            //    if (IS_IPOD) {
            //        time2Tick = time2Tick - 2;
            //    }
            //            [tickPlayer setCurrentTime:j-0.2];
            [tickPlayer play];
            
            
            float delay = sec -j-4;
            NSLog(@"Delay: %f", delay);
            [self performSelector:@selector(playPips) withObject:nil afterDelay:delay];
            //    [tickPlayer play];
            //    [tickPlayer playAtTime:time2Tick];
            NSLog(@"tickplayer: %f", [tickPlayer currentTime]);
        }
    }
    //    [player setRepeatMode:MPMovieRepeatModeOne];
}



-(void)openMoviePlayer
{
    if ([self checkFileInFolderWithName:[[_videoPath stringByDeletingLastPathComponent] lastPathComponent]])
    {
        //        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        player = [[MPMoviePlayerController alloc] init];
        player.view.backgroundColor = [UIColor whiteColor];
        
        player.movieSourceType = MPMovieSourceTypeFile;
        player.contentURL = [NSURL fileURLWithPath:[self getExistingVideoURLWithName:[[_videoPath stringByDeletingLastPathComponent] lastPathComponent] ]];
        [player setControlStyle:MPMovieControlStyleNone];
        //        [player setRepeatMode:MPMovieRepeatModeOne];
        //this is where you create your `embedded` view size
        [player prepareToPlay];
        NSError *error;
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(setPreferredInputNumberOfChannels:error:)]) {
            [[AVAudioSession sharedInstance] setPreferredInputNumberOfChannels:2 error:&error];
        };
        
        player.repeatMode = MPMovieRepeatModeOne;
        UIImage *thumbImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        float width = thumbImage.size.width;
        float height = thumbImage.size.height;
        UIView *videoView;
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            if (IS_HEIGHT_GTE_568){
                if (width < height){
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-15, 10, 380, 580)];
                    
                }else{
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-80, 50, 570, 320)];
                }
                
            }else{
                if (width < height){
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 360, 560)];
                    
                }else{
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-70, 20, 570, 320)];
                }}
            
        }else{
            if (IS_HEIGHT_GTE_568){
                if (width < height){
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-15, 10, 380, 580)];
                    
                }else{
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-80, 50, 570, 320)];
                }
                
            }else{
                if (width < height){
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 360, 560)];
                    
                }else{
                    videoView = [[UIView alloc] initWithFrame:CGRectMake(-70, 50, 570, 320)];
                }}
        }
        //
        UIView *movieBackgroundView = [[UIView alloc] initWithFrame:[videoView bounds]];
        movieBackgroundView.backgroundColor = [UIColor whiteColor];
        [player.backgroundView addSubview:movieBackgroundView];
        [movieBackgroundView release];
        [videoView addSubview:player.view];
        player.view.frame = videoView.frame;
        
        player.initialPlaybackTime = 0;
        [self.view insertSubview:videoView belowSubview:self.stopwatchView];
        
        //        NSError *activationError = nil;
        //        [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
        //        AudioSessionSetActive (false);
        //        player.useApplicationAudioSession = NO;
        [player play];
        //        [[MPMusicPlayerController applicationMusicPlayer] play];
        [videoView release];
        //        //        [player release];
        //        [pool drain];
    }
}


- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)note
{
    //    [player setRepeatMode:MPMovieRepeatModeOne];
    //    [player play];
    //    NSLog(@"player did finosh");
    //
    //
    //        NSInteger reason = [[note.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    //        if (reason == MPMovieFinishReasonPlaybackEnded)
    //        {
    //
    [player play];
    //        }else{
    //
    //        }
    //    [player release];
    //are we currently playing?
    
    
}

-(BOOL)checkFileInFolderWithName:(NSString *)extensionName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",extensionName]];
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return fileExists;
}

-(NSString *)getExistingVideoURLWithName:(NSString *)videName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videName]];
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return path;
}

#pragma mark - timer satff

-(void)makeRotationWithDuration:(float)duration andDegreez:(int)degreez
{
    
    
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation
                                           animationWithKeyPath:@"transform.rotation.z"];
    
    [rotationAnimation setFromValue:DegreesToNumber(0)];
    [rotationAnimation setToValue:DegreesToNumber(degreez)];
    [rotationAnimation setDuration:duration ];
    [rotationAnimation setRepeatCount:1];
    [[[self secbutton] layer] addAnimation:rotationAnimation forKey:@"rotate"];
    
}

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

NSNumber* DegreesToNumber(CGFloat degrees)
{
    return [NSNumber numberWithFloat:
            DegreesToRadians(degrees)];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [tickPlayer stop];
    [timer invalidate];
    timer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playPips)
                                               object:nil];
    [labelScroll removeFromSuperview];
    [calendar setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //    [player stop];
    //    [player.view removeFromSuperview];
    //    [player release];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [UIApplication sharedApplication].idleTimerDisabled = sleep ;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playPips)
                                               object:nil];
    //    for (UITextField *field in repsScroll) {
    //        [field release];
    //    };
    NSLog(@"Deallocating");
    //    [sDate release];
    [lbl release];
    [disabledDates removeAllObjects];
    [disabledDates release];
    [repsScroll release];
    [_dateButton release];
    [_nameLabel release];
    [_secBtn release];
    [_keyBoardBtn release];
    [repsArray removeAllObjects];
    [repsArray release];
    [weightArray removeAllObjects];
    [weightArray release];
    [_secbutton release];
    [_photoArr release];
    [_folderString release];
    [videoURl1 release];
    [plistPathString release];
    [_histView release];
    [_dateLabel release];
    [tickPlayer stop];
    [tickPlayer release];
    [_stopwatchView release];
    [_weightButton release];
    [_stopTickingBtn release];
    [_stopwatchLabel release];
    [_auxDateBtn release];
    [_repsButton release];
    [_backImgView release];
    [_closeClaImg release];
    [_controll release];
    [trtansStyle release];
    [calView release];
    [_closeCalBtn release];
    [player release];
    
    [_wLabrl release];
    [_rLabel release];
    [_lvLabel release];
    [_dateBtnImg release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    NSLog(@"Did unload");
    [self setDateButton:nil];
    [self setNameLabel:nil];
    [self setSecBtn:nil];
    [self setKeyBoardBtn:nil];
    [self setSecbutton:nil];
    [self setHistView:nil];
    [self setCalendarView:nil];
    [self setDateLabel:nil];
    [self setStopwatchView:nil];
    [self setWeightButton:nil];
    [self setStopTickingBtn:nil];
    [self setStopwatchLabel:nil];
    [self setAuxDateBtn:nil];
    [self setRepsButton:nil];
    [self setBackImgView:nil];
    [self setCloseClaImg:nil];
    [self setCloseCalBtn:nil];
    
    [self setWLabrl:nil];
    [self setRLabel:nil];
    [self setLvLabel:nil];
    [self setDateBtnImg:nil];
    [super viewDidUnload];
}
@end
