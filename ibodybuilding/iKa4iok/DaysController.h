//
//  DaysController.h
//  iBodybuilding-Update
//
//  Created by Cibota Olga on 11/7/14.
//  Copyright (c) 2014 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    int checkEditStatus;
    int ButtonSenderTag;
    NSIndexPath *red;
    NSInteger rocket;
    NSMutableDictionary * sectionData;
    NSMutableDictionary *  imageSectionData;
    NSMutableArray *workArray;
    UILabel *repsLabel;

}

@property (nonatomic, readwrite) int isCustom;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite) int isPreview;
@property (nonatomic, readwrite) int isEditing;
@property (nonatomic, retain)NSMutableDictionary *contentDictionary;
-(id)initWithDataArray:(NSArray *)dataArray andMane:(NSString *)eTitle;
@end
