//
//  ShowExercises.h
//  iKa4iok
//
//  Created by Johnny Bravo on 12/7/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowExercises : UIViewController<UIScrollViewDelegate>{
    
    NSString *localString;
    NSMutableArray * dataArray;
   
}


@property (retain, nonatomic) IBOutlet UILabel *pageCount;
@property (retain, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain)NSString *globalPath;


@end
