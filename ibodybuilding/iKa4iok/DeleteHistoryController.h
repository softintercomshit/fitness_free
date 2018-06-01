//
//  DeleteHistoryController.h
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 9/10/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideAppDelegate.h"

@interface DeleteHistoryController : UITableViewController
{
    NSMutableArray *exercisesArray;
    NSMutableArray *uniqueExerciseArray;
    BOOL checkeditStatus;
}


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchArray;

@property (nonatomic, retain)NSString *dateOfExerc;

@end
