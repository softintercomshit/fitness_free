//
//  ExercisePicker.h
//  iKa4iok
//
//  Created by Johnny Bravo on 12/5/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExercisePicker : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    int pageNum;
    NSString *plistPath;
    
   
    
}

@property (nonatomic, readwrite) int isPreviewing;
@property (nonatomic, readwrite) int isEditing;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPathLink:(NSString *)path;

@end
