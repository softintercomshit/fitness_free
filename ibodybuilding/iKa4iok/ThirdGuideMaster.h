//
//  ThirdGuideMaster.h
//  iBodybuilding-Update
//
//  Created by Cibota Olga on 11/7/14.
//  Copyright (c) 2014 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdGuideMaster : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    
    int editButtonChecker;
    NSIndexPath *red;
    NSInteger rocket;
    int selectedRow;
    
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *customExerciseFolder;
@property (nonatomic, strong) NSMutableIndexSet *mutableIndexSet ;
@property (nonatomic, strong) NSMutableArray *selectedPhotoTracker;


@end
