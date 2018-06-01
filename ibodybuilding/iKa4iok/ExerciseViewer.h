//
//  ExerciseViewer.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/13/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"


@interface ExerciseViewer : UIViewController<UITableViewDelegate,UITableViewDataSource>{

   NSMutableArray *photoArray;
    UITableView * tableViews;
    NSMutableArray *exerciseContentArray;
  
}



-(id)initWithCategory:(NSString *)category andVideoURL:(NSString *)videoURL;



@end
