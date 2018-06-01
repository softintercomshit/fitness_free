//
//  ExercisePreview.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/13/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXImageView.h"
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ExercisePreview : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate>{
    
    BOOL pageControlBeginUsed;
    BOOL isPickingExercise;
    NSMutableArray *picArray;
    
}
@property (retain, nonatomic) NSString *plistPath;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) NSString *info,*titleString;
@property (strong, nonatomic) TWTweetComposeViewController *tweetView;  
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;


-(id)initWithNibName:(NSString *)nibNameOrNil image:(NSMutableDictionary*)data title:(NSString*)title isPickingEx:(BOOL)isPicking;
-(IBAction)showActionSheet:(id)sender;
@end
