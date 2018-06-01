//
//  NewExercisePreviewer.m
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/21/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "NewExercisePreviewer.h"


@interface NewExercisePreviewer ()
{
    AGAlertViewWithProgressbar *alertViewWithProgressbar;
}

@property (retain) AGAlertViewWithProgressbar *alertViewWithProgressbar;

@end

@implementation NewExercisePreviewer
@synthesize photoArray,descriptionString,titleString,videoURL;
@synthesize alertViewWithProgressbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setContentDict:(NSMutableDictionary *)contentDicts
{
    _contentDict = [[NSMutableDictionary alloc] initWithDictionary:contentDicts];
}
-(void) setWorkout:(NSString *)workout

{
    _workout = [workout copy];
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


-(id)initWithNibName:(NSString *)nibNameOrNil image:(NSMutableDictionary*)data title:(NSString*)title isPickingEx:(BOOL)isPicking{
    
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        
        if (self.isCustom==1) {
            if (isPicking == 0) {
                
                if ([[data objectForKey:@"description"] length]!=0)
                {
                    descriptionString = [[data objectForKey:@"description"] retain];
                }else
                {
                    descriptionString = @" ";
                }
                
                photoArray = [[NSMutableArray alloc]initWithArray:[data objectForKey:@"images"] copyItems:YES];
                isPickingExercise = isPicking;
                titleString = [title retain];
            }else{
                
                
                if ([[data objectForKey:@"description"] length]!=0)
                {
                    descriptionString = [[data objectForKey:@"description"] retain];
                }else
                {
                    descriptionString = @" ";
                }
                photoArray = [[[NSMutableArray alloc]initWithArray:[data objectForKey:@"images"] copyItems:YES] retain];
                isPickingExercise = isPicking;
                titleString = [title retain];
            }
        }else
        {
            if ([[data objectForKey:@"description"] length]!=0)
            {
                descriptionString = [[data objectForKey:@"description"] retain];
            }else
            {
                descriptionString = @" ";
            }
            
            photoArray = [[NSMutableArray alloc]initWithArray:[data objectForKey:@"images"] copyItems:YES];
            isPickingExercise = isPicking;
            titleString = [title retain];
            
        }
        
        if ([[VideoDownloader instance] delegate]!=nil) {
        } else {
            [[VideoDownloader instance] setDelegate:self];
        }
        
    }
    return self;
}

-(void)setProgressViewValue:(float)progressValue
{
}

-(void)videoDownloaderDidFinishDownloadingZipFileWithValue:(BOOL)downloadValue andPath:(NSString *)filePath
{
    
}

-(void)setVideoURL:(NSString *)videoURLs
{
    videoURL = [videoURLs copy];
    videoURL = [videoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    videoURL = [videoURL stringByAppendingPathComponent:VIDEO_PATH];
    videoURL = [[SINGLE_DOWNLOAD_LINK stringByAppendingPathComponent:videoURL] retain];
}

#pragma mark - Content ScrollView Setting up


-(void)populateContentScrollView:(UIScrollView *)scrollView WithPhotos:(NSMutableArray *)picArray andPageControl:(UIPageControl *)pageContr{
    NSMutableArray * array = [NSMutableArray arrayWithArray:picArray];
    NSLog(@"Pick array: %@", picArray);
    
    CGRect frame;
    NSFileManager *man = [NSFileManager defaultManager];
    
    for (int i = 0; i < array.count; i++)
    {
        NSString *path;
        NSArray *comps = [[picArray objectAtIndex:i]pathComponents];
        if ([comps containsObject:@"Library"]) {
            NSLog(@"1 - %@", [comps objectAtIndex:5]);
            path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //                path = [path stringByDeletingLastPathComponent];
            //                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
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
        BOOL b = [man fileExistsAtPath:path];
        NSLog(@"File exists: %d", (int)b);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]] ;
        //        NSLog(@"Image path 1: %@", [array objectAtIndex:i]);
        //        NSLog(@"Image path 2: %@", path);
        frame=imageView.frame;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        imageView.tag = i;
        
        if (imageView.frame.size.width>scrollView.frame.size.width)
        {
            CGFloat scale=imageView.frame.size.width/scrollView.frame.size.width;
            frame.size.width=scrollView.frame.size.width;
            frame.size.height=frame.size.height*scale;
        }
        if (imageView.frame.size.height>scrollView.frame.size.height)
        {
            CGFloat scale=imageView.frame.size.height/scrollView.frame.size.height;
            frame.size.height=scrollView.frame.size.height;
            frame.size.width=frame.size.width*scale;
        }
        CGFloat offset=scrollView.frame.size.width * i;
        frame.origin.x = (scrollView.frame.size.width - frame.size.width)/2+offset;
        frame.origin.y = (scrollView.frame.size.height - frame.size.height)/2;
        
        
        if (imageView.image == nil)
        {
            [pageContr setHidden:YES];
        }
        else
        {
            [pageContr setHidden:NO];
        }
        //		frame.size = CGSizeMake(imageView.image.size.width, imageView.image.size.height);
        
        [imageView setFrame:frame];
        [scrollView addSubview:imageView];
        [imageView release];
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * array.count, 0);
    pageContr.currentPage = 0;
    pageContr.numberOfPages = array.count;
    
}


#pragma mark - Title & Description Strings


-(void)setTitleForExercise:(NSString *)stringForTitle{
    
    if (self.isCustom==0 || self.isWithVideo == 1)
    {
        [self.nameLabel setText:[[NSString stringWithFormat:@" %@: ",NSLocalizedString(@"Title", nil)] stringByAppendingString:[self getLocalizedStringFromString:stringForTitle]]];
        
    }else
    {
        [self.nameLabel setText:[[NSString stringWithFormat:@" %@: ",NSLocalizedString(@"Title", nil)] stringByAppendingString:stringForTitle]];
    }
    
    
    CGSize maximumLabelSize = CGSizeMake(9999, 9999);
    CGSize expectedLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.nameLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = self.nameLabel.frame;
    newFrame.size.width = expectedLabelSize.width;
    NSLog(@"EXPECTED: %f", expectedLabelSize.width);
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        newFrame.origin.y = 0;
    }else
    {
        newFrame.origin.y = 70;
        
        newFrame.size.width = newFrame.size.width + 1 ;
    }
    self.nameLabel.frame = newFrame;
    
    if (self.nameLabel.frame.size.width > self.view.frame.size.width)
    {
        [self forwardLabelAnimation];
        
    }
    NSLog(@"Name: %f", self.nameLabel.frame.size.width);
    
}

-(void)setDescriptionForExercise:(NSString *)stringForDescription{
    
    if (self.isCustom!=1 || self.isWithVideo == 1)
    {
        stringForDescription = NSLocalizedStringFromTable(stringForDescription, @"content", nil);
    }
    
    
    [self.descriptionlabel setText:stringForDescription];
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    CGSize expectedLabelSize = [stringForDescription sizeWithFont:self.descriptionlabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.descriptionlabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = self.descriptionlabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    self.descriptionlabel.frame = newFrame;
    [self.descriptionlabel setTextAlignment:NSTextAlignmentLeft];
    
}



-(void)forwardLabelAnimation
{
    if (self.nameLabel.frame.size.width < 500) {
        [UIView animateWithDuration:2.5f
                         animations:^{
                             [self.nameLabel setFrame:CGRectMake((self.view.frame.size.width - self.nameLabel.frame.size.width), self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                         } completion:^(BOOL finished) {
                             [self backwardLAbelAnimation];
                         }];
    }else{
        [UIView animateWithDuration:6.0f
                         animations:^{
                             [self.nameLabel setFrame:CGRectMake((self.view.frame.size.width - self.nameLabel.frame.size.width), self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                         } completion:^(BOOL finished) {
                             [self backwardLAbelAnimation];
                         }];
    }
    
}

-(void)backwardLAbelAnimation
{
    if (self.nameLabel.frame.size.width < 500) {
        
        [UIView animateWithDuration:2.5f
                         animations:^{
                             [self.nameLabel setFrame:CGRectMake(0, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                         } completion:^(BOOL finished) {
                             [self performSelector:@selector(forwardLabelAnimation) withObject:nil afterDelay:3.0f];
                         }];
    }else{
        [UIView animateWithDuration:6.0f
                         animations:^{
                             [self.nameLabel setFrame:CGRectMake(0, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                         } completion:^(BOOL finished) {
                             [self performSelector:@selector(forwardLabelAnimation) withObject:nil afterDelay:3.0f];
                         }];
    }
}

#pragma mark - ScrollView and Page Control delegate


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeginUsed) {
        
        CGFloat pageWidth = self.contentScrollView.frame.size.width;
        int page = floor((self.contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.contentPageControll.currentPage = page;
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeginUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeginUsed = NO;
}

- (IBAction)changePage {
    
    CGRect frame;
    frame.origin.x = self.contentScrollView.frame.size.width * self.contentPageControll.currentPage;
    frame.origin.y = 0;
    frame.size = self.contentScrollView.frame.size;
    [self.contentScrollView scrollRectToVisible:frame animated:YES];
    
    pageControlBeginUsed = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    [[VideoDownloader instance] setDelegate:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[VideoDownloader instance] setDelegate:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    landscape = NO;
    
    [self.nameLabel setFont:[UIFont fontWithName:@"Lucida Grande" size:18]];
    [self.descriptionlabel setFont:[UIFont fontWithName:@"Lucida Grande" size:16]];
    [self.descriptionlabel setTextColor:[UIColor grayColor]];
    int canupload;
    
    if ([photoArray count]==0)
    {
        canupload = 0;
        
    }else
    {  
        canupload = 1;
    }

    if (canupload != 0) {
        
        
        [self populateContentScrollView:self.contentScrollView WithPhotos:photoArray andPageControl:self.contentPageControll];
        [self.contentPageControll setHidden:NO];
    }else
    {
        UIImageView *imageViewSuka = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no-photo" ofType:@"png"]]];
        [imageViewSuka setFrame:CGRectMake(0, 40, 320, 200)];
        [self.view addSubview:imageViewSuka];
        [self.contentPageControll setHidden:YES];
    }
     
    [self setTitleForExercise:titleString];
    [self setDescriptionForExercise:descriptionString];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.mainScrollView.contentSize = CGSizeMake(320, self.nameLabel.frame.size.height+self.descriptionlabel.frame.size.height+self.contentScrollView.frame.size.height+40+50);
    }else{
        self.mainScrollView.contentSize = CGSizeMake(320, self.nameLabel.frame.size.height+self.descriptionlabel.frame.size.height+self.contentScrollView.frame.size.height+70+50);
    }
    
    [self.mainScrollView setUserInteractionEnabled:YES];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.mainScrollView setFrame:self.view.frame];
    }
    NSLog(@"main scrollView:  %d", (int)self.mainScrollView.frame.size.height);

    
    if (self.plistStringPath != nil)
    {
        UIBarButtonItem *addNewExercise = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStyleDone target:self action:@selector(addExercise)];
        self.navigationItem.rightBarButtonItem = addNewExercise;
        [addNewExercise release];
    }
    else
    {
//        if (!self.isCustom)
//        {
//            
//            if (self.isWorkout == YES) {
//                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//                    UIButton *videoStreamButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 41 , 30)];
//                    [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"video_passive2" ofType:@"png"]] forState:UIControlStateNormal];
//                    [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"video_active2" ofType:@"png"]] forState:UIControlStateHighlighted];
//                    [videoStreamButton addTarget:self action:@selector(openMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
//                    UIBarButtonItem *videoStream = [[UIBarButtonItem alloc]initWithCustomView:videoStreamButton];
//                    UIBarButtonItem *startButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(openExerciseController)];
//                    self.navigationItem.rightBarButtonItems = @[startButton,videoStream];
//                    [startButton release];
//                    [videoStream release];
//                    [videoStreamButton release];
//
//                }else
//                {
//                    UIButton *videoStreamButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 30)];
//                    [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"play@2x" ofType:@"png"]] forState:UIControlStateNormal];
//                    [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"play@2x" ofType:@"png"]] forState:UIControlStateHighlighted];
//                    [videoStreamButton addTarget:self action:@selector(openMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
//                    UIBarButtonItem *videoStream = [[UIBarButtonItem alloc]initWithCustomView:videoStreamButton];
//                    UIBarButtonItem *startButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(openExerciseController)];
//                    self.navigationItem.rightBarButtonItems = @[startButton,videoStream];
//                    [startButton release];
//                    [videoStream release];
//                    [videoStreamButton release];
//                }
//            }
//            else
//            {
//                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//                UIButton *videoStreamButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 41 , 30)];
//                [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"video_passive2" ofType:@"png"]] forState:UIControlStateNormal];
//                [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"video_active2" ofType:@"png"]] forState:UIControlStateHighlighted];
//                [videoStreamButton addTarget:self action:@selector(openMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
//                UIBarButtonItem *videoStream = [[UIBarButtonItem alloc]initWithCustomView:videoStreamButton];
//                self.navigationItem.rightBarButtonItems = @[videoStream];
//                UIBarButtonItem *startButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(openExerciseController)];
//                self.navigationItem.rightBarButtonItems = @[startButton,videoStream];
//                [startButton release];
//
//                [videoStream release];
//                [videoStreamButton release];
//                }else{
//                    UIButton *videoStreamButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 30)];
//                    [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"play@2x" ofType:@"png"]] forState:UIControlStateNormal];
//                    [videoStreamButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"play@2x" ofType:@"png"]] forState:UIControlStateHighlighted];
//                    [videoStreamButton addTarget:self action:@selector(openMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
//                    UIBarButtonItem *videoStream = [[UIBarButtonItem alloc]initWithCustomView:videoStreamButton];
//                    self.navigationItem.rightBarButtonItems = @[videoStream];
//                    UIBarButtonItem *startButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(openExerciseController)];
//                    self.navigationItem.rightBarButtonItems = @[startButton,videoStream];
//                    [startButton release];
//                    
//                    [videoStream release];
//                    [videoStreamButton release];
//                }
//
//            }
//    }else{
//        UIBarButtonItem *startButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(openExerciseController)];
//        self.navigationItem.rightBarButtonItems = @[startButton];
//        [startButton release];
//
//    }
    }
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {

    }else
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 50)];
        [self.contentPageControll setFrame:CGRectMake(self.contentPageControll.frame.origin.x, self.contentPageControll.frame.origin.y + 50, self.contentPageControll.frame.size.width, self.contentPageControll.frame.size.height)];
        [self.descriptionlabel setFrame:CGRectMake(self.descriptionlabel.frame.origin.x, self.descriptionlabel.frame.origin.y + 50, self.descriptionlabel.frame.size.width, self.descriptionlabel.frame.size.height)];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}
-(void)back
{
    
    NSLog(@"Going back");
    
    [controll makeTransitionfor:self withTransitionStyle:kCATransitionFromTop];
}

-(void)openExerciseController
{
    NSLog(@"Pushed");
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    controll = [[EditExerciseControll alloc]initWithNibName:@"EditExerciseControll" bundle:nil];
    [controll.navigationItem setLeftBarButtonItem:backButtonItem];
    [backButtonItem release];
    controll.dayOfExercise = self.day;
    [controll setDelegate:self];
    [controll setWorkout:self.workout];
    NSLog(@"Self.workout: %@", self.workout);
    controll.videoPath = videoURL;
    [videoURL release];
    controll.isNew = self.isCustom;
    controll.exerciseName = self.titleString;
    [controll setDayOfExercise:self.day];
    [controll setPhotoArr:photoArray];
    controll.folderString = self.folderPaf;
    
    [self makeTransition];
    [controll release];
    //    [videoURL release];
}

- (void) makeTransition{
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.duration = 0.25f;
    //    transition.fillMode = kCAFillMode;
    //    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    
    [self.navigationController pushViewController:controll animated:NO];
    
    
    [CATransaction commit];
    
}


-(void)openMoviePlayer
{
    if (!videoURL) return;
    
    if ([self checkFileInFolderWithName:[[videoURL stringByDeletingLastPathComponent] lastPathComponent]])
    {
        
        [[IBVideoPlayer sharedVPlayer]playVideoWithURL:[NSURL fileURLWithPath:[self getExistingVideoURLWithName:[[videoURL stringByDeletingLastPathComponent] lastPathComponent] ]] onViewController:self];
        //video check
    }
    else
    {
        
        [[VideoDownloader instance] downloadVideoFromServerWithPath:videoURL andVideoName:[[[videoURL stringByDeletingLastPathComponent] lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}


-(void)videoDownloaderDidFinishDownloadingWithValue:(BOOL)downloadValue andPath:(NSString *)filePath
{
    if (downloadValue == YES)
    {
        [[IBVideoPlayer sharedVPlayer]playVideoWithURL:[NSURL fileURLWithPath:filePath] onViewController:self];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [operations cancel];
        [[NSFileManager defaultManager]removeItemAtPath:[self getExistingVideoURLWithName:[[[videoURL stringByDeletingLastPathComponent] lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] error:nil];
        
    }
    
    
}


-(NSString *)getExistingVideoURLWithName:(NSString *)videName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videName]];
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    //video check
    //    NSString *auxPath = [[NSBundle mainBundle] resourcePath];
    //    path = [auxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videName]];
    //    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return path;
}

-(BOOL)checkFileInFolderWithName:(NSString *)extensionName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",extensionName]];
    //video check
    //    NSString *auxPath = [[NSBundle mainBundle] resourcePath];
    //    path = [auxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",extensionName]];
    //    //video check finished
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return fileExists;
}


-(void)didFinishPlayingVideo:(BOOL)isFinished
{
    if (isFinished==YES) landscape = NO;
    
}


-(NSUInteger)supportedInterfaceOrientations { return UIInterfaceOrientationMaskPortrait; }

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
        
        // Dismiss the view controller
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)addExercise
{
    [self addExerciseToProgramWithPhotos:photoArray title:titleString andDescription:descriptionString];
}


-(void)addExerciseToProgramWithPhotos:(NSArray *)array title:(NSString *)title andDescription:(NSString *)descript{
    
    
    NSMutableArray *checkArray = [[NSMutableArray alloc]initWithContentsOfFile:self.plistStringPath];
    NSMutableDictionary *dataDict =[[NSMutableDictionary alloc] init];
    
    if (checkArray != nil)
    {
        [dataDict setObject:array forKey:@"images"];
        [dataDict setObject:title forKey:@"title"];
        if ([descript length] == 0)
        {
            [dataDict setObject:@"" forKey:@"description"];
        }
        else
        {
            [dataDict setObject:descript forKey:@"description"];
        }
        
        [checkArray addObject:dataDict];
        [checkArray writeToFile:self.plistStringPath atomically:YES];
    }
    else
    {
        [dataDict setObject:array forKey:@"images"];
        [dataDict setObject:title forKey:@"title"];
        
        if ([descript length] == 0)
        {
            [dataDict setObject:@"" forKey:@"description"];
        }
        else
        {
            [dataDict setObject:descript forKey:@"description"];
        }
        
        [[NSMutableArray arrayWithObject:dataDict] writeToFile:self.plistStringPath atomically:YES];
    }
    
    [checkArray release];
    [dataDict release];
    
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4];
    [self.navigationController popToViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memmory warning");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"New exercise previewer deallocationg...");
    [operations release];
    [videoURL release];
    self.alertViewWithProgressbar = nil;
    [titleString release];
    [_mainScrollView release];
    [_contentScrollView release];
    [_nameLabel release];
    [_descriptionlabel release];
    [_contentPageControll release];
    [_plistStringPath release];
    [photoArray release];
    [_contentDict removeAllObjects];
    [_contentDict release];
    [_folderPaf release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScrollView:nil];
    [self setContentScrollView:nil];
    [self setNameLabel:nil];
    [self setDescriptionlabel:nil];
    [self setContentPageControll:nil];
    [super viewDidUnload];
}
@end
