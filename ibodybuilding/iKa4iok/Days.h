//
//  Days.h
//  iKa4iok
//
//  Created by Johnny Bravo on 12/3/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Days : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    
    UITableView * tableViews;
    NSMutableDictionary *sectionData,*imageSectionData;
     NSMutableDictionary *daysDictionaryContent;
}


-(id)initWithDay:(NSString *)day;
@end
