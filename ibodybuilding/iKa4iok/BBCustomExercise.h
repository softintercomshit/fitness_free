//
//  BBCustomExercise.h
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/11/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataInputCller.h"
#import "DescriptionViewController.h"

@interface BBCustomExercise : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,InputDataProtocol,descriptionProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIScrollView    *imageScrollView;
    UIButton        *addButton;
    UIImagePickerController *imagePicker;
    UITextView *comment;
    int timerTick;
    NSTimer *timerus;
    NSMutableDictionary *contentDict;

    
}
@property (nonatomic, readwrite) int getObjectIndex;
@property (nonatomic, retain) NSString          *exerciseTitle;
@property (nonatomic, retain) NSString          *exerciseDescription;
@property (nonatomic, retain) NSString          *exerciseRepetitions;

@property (nonatomic, readwrite) int isEditing;

@property (nonatomic, retain) NSMutableArray    *photoArray;
@property (nonatomic, retain) NSString          *folderPath;
@property (nonatomic, retain) NSString          *plistString;

@property (retain, nonatomic) IBOutlet UITableView *contentTableView;
@end
