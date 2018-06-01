//
//  GraphViewController.h
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/17/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GraphViewController : UIViewController<CPTPlotDataSource, CPTScatterPlotDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CPTGraphHostingView *perfView;
    CPTGraphHostingView *repsView;
    CPTGraphHostingView *weightView;
    
    CPTXYGraph *perfGraph;
	CPTXYGraph *repsGraph;
	CPTXYGraph *weighGraph;
    CPTXYAxis *x;
    CPTXYAxis *y;
    
    NSTimeInterval oneDay;
    
	NSArray *weightData;

    NSMutableArray *perfData;
    NSArray *repsData;
    
    NSMutableArray * exerciseArray;
    NSMutableArray *uniquedatesArray;
    NSArray *fetchArray;
}
@property (retain, nonatomic) IBOutlet UITableView *histTableView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedButtons;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSString *referencialDate;
@property (nonatomic , retain) NSString *nameOfexercise;

-(IBAction)changeSeg;

@end
