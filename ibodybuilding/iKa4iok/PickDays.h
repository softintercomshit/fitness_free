//
//  DaysControllerViewController.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/30/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Days.h"
@interface PickDays : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableViews;
    
}

-(id)initWithType:(NSString *)type;
@end
