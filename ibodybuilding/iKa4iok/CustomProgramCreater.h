//
//  CustomProgramCreater.h
//  iKa4iok
//
//  Created by Johnny Bravo on 12/4/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataInputCller.h"
@interface CustomProgramCreater : UIViewController<UITextFieldDelegate,InputDataProtocol>{
    int checkTextField;
    NSString *daysString,*nameString;
    
}
@property (assign, nonatomic) BOOL  isEditing;
@property (retain, nonatomic) IBOutlet UITableView *settingTableView;
@property (retain, nonatomic) IBOutlet UITextField *programDays;
@property (retain, nonatomic) IBOutlet UIButton *doneButton;
@property (retain, nonatomic) IBOutlet UITextField *programName;
@end
