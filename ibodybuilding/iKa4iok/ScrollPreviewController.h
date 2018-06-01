//
//  ScrollPreviewController.h
//  iKa4iok
//
//  Created by Alexandr Dzerjitchii on 12/10/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollPreviewController : UIViewController<UIScrollViewDelegate>{
    
    BOOL pageControlBeginUsed;
}
@property (retain, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain, nonatomic) IBOutlet UILabel *pageLabel;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControler;


-(id)initWithNibName:(NSString *)nibNameOrNil andRequiredData:(NSMutableArray *)dataArray andDescription:(NSString *)exDescription;
@end
