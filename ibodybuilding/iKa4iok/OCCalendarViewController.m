//
//  OCCalendarViewController.m
//  OCCalendar
//
//  Created by Oliver Rickard on 3/31/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "OCCalendarViewController.h"
#import "OCCalendarView.h"
#import <QuartzCore/QuartzCore.h>

@interface OCCalendarViewController ()

@end

@implementation OCCalendarViewController
@synthesize delegate, startDate, endDate, selectionMode;

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap selectionMode:(OCSelectionMode)sm {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        insertPoint = point;
        parentView = v;
        arrowPos = OCArrowPositionCentered;
        selectionMode = sm;
    }
    
    return self;
}




-(void) delegateMethod
{
    NSLog(@"Delegate works!");
    
    [self.delegate changeButtonName];
//    [self.view removeGestureRecognizer:tapDateGesture];
    [self.view removeFromSuperview];
    
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap {
    return [self initAtPoint:point inView:v arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionDateRange];
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v {
    return [self initAtPoint:point inView:v arrowPosition:OCArrowPositionCentered];
}

- (void)loadView {
    [super loadView];
//    self.view.frame = parentView.frame;
    
    
    //this view sits behind the calendar and receives touches.  It tells the calendar view to disappear when tapped.
//    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
//    bgView.backgroundColor = [UIColor clearColor];

//
//    [self.view addSubview:bgView];
//

    
    int width = 390;
    int height = 300;
    self.view.frame = CGRectMake(-21, 10, width, height);
//
//    float arrowPosX = 208;
//
//    if(arrowPos == OCArrowPositionLeft) {
//        arrowPosX = 67;
//    } else if(arrowPos == OCArrowPositionRight) {
//        arrowPosX = 346;
//    }
    
    calView = [[OCCalendarView alloc] initAtPoint:CGPointMake(-21, 10) withFrame:CGRectMake(-21, 10, width, height) arrowPosition:0];
    calView.delegate = self;
    [calView setSelectionMode:selectionMode];
    if(self.startDate) {
        [calView setStartDate:startDate];
    }
    if(self.endDate) {
        [calView setEndDate:endDate];
    }
    [self.view addSubview:calView ];
    
    NSLog(@"Cal view: %@", [calView subviews]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setStartDate:(NSDate *)sDate {
    if(startDate) {

        startDate = nil;
    }
    startDate = sDate;
    [calView setStartDate:startDate];
    [calView removeFromSuperview];
}

- (void)setEndDate:(NSDate *)eDate {
    if(endDate) {
    
        endDate = nil;
    }

    [calView setEndDate:endDate];
    [calView removeFromSuperview];
}

- (void)removeCalView {
    startDate = [calView getStartDate];
    endDate = [calView getEndDate];

    
    if([calView selected]) {
        if([startDate compare:endDate] == NSOrderedAscending)
            [self.delegate completedWithStartDate:startDate];
        else
            [self.delegate completedWithStartDate:endDate];
    } else {
        [self.delegate completedWithNoSelection];
    }
    
    [UIView beginAnimations:@"animateOutCalendar" context:nil];
    [UIView setAnimationDuration:0.4f];
    calView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    calView.alpha = 0.0f;
    [UIView commitAnimations];
    
    [calView removeFromSuperview];
    calView = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    self.startDate = nil;
    self.endDate = nil;
    [super dealloc];
}

@end
