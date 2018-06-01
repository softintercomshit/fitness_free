//
//  DaysTableViewController.h
//  iKa4iok
//
//  Created by Johnny Bravo on 12/4/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *exerciseCountArray;
    UITableView *daysTableView;
    NSMutableDictionary *contentDictionary;
}


@property (nonatomic, readwrite) int isPreview;
@property (nonatomic, readwrite) int isEditing;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDataArray:(NSArray *)dataArray name:(NSString *)name;
@end
