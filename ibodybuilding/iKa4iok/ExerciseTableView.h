//
//  ExerciseTableView.h
//  iKa4iok
//
//  Created by Alexandr Dzerjitchii on 12/10/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTableView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *photoArray;
    NSMutableArray *exerciseContentArray;
    UITableView *exerciseTable;
}

@property (nonatomic, retain)NSString *plistPath;
-(id)initWithCategory:(NSString *)category andVideoURL:(NSString *)videoURL;
@end
