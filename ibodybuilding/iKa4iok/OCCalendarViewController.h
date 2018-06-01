//
//  OCCalendarViewController.h
//  OCCalendar
//
//  Created by Oliver Rickard on 3/31/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarView.h"
#import "OCSelectionView.h"


@class OCCalendarView;
@class OCSelectionView;
@protocol OCCalendarDelegate <NSObject>

-(void)completedWithStartDate:(NSDate *)startDate;

-(void)completedWithNoSelection;

- (void)changeButtonName;

@end

@interface OCCalendarViewController : UIViewController <UIGestureRecognizerDelegate, OCSelectionViewDelegate, OCCalendarViewDelegate> {
    id <OCCalendarDelegate> delegate;
    id <OCSelectionViewDelegate> ocsdelegate;
    UILabel *toolTipLabel;
    OCCalendarView *calView;
    
    CGPoint insertPoint;
    OCArrowPosition arrowPos;
    
    UIView *parentView;
    
    NSDate *startDate;
    NSDate *endDate;
    OCSelectionMode selectionMode;
    
    int startCellX;
    int startCellY;
    int endCellX;
    int endCellY;
}

@property (nonatomic, retain) id <OCCalendarDelegate> delegate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) OCSelectionMode selectionMode;



- (id)initAtPoint:(CGPoint)point inView:(UIView *)v;
- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap;
- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap selectionMode:(OCSelectionMode)sm;
- (void)removeCalView;



@end
