//
//  EditViewController.h
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/16/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataInputCller.h"

@interface EditViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,InputDataProtocol>{
    
    
    
    NSString *workoutPath,*workoutTitle;
    
}

-(id)initWithWorkoutTitle:(NSString *)title andWorkoutPath:(NSString *)folderPath;




@end
