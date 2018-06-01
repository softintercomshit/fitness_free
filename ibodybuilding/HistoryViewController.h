//
//  HistoryViewController.h
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/16/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteHistoryController.h"

@interface HistoryViewController : UITableViewController
{
    NSMutableArray *datesArray;
    NSMutableArray *uniqueDatesArray;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSString *exerciseName;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchArray;

-(void) fetchDates;
@end
