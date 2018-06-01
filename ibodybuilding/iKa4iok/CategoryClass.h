//
//  CategoryClass.h
//  iKa4iok
//
//  Created by Johnny Bravo on 12/7/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryClass : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *categoryTable;
    
}





@property (nonatomic, retain)NSString *plistPath;

@end
