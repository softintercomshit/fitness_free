//
//  Detail.h
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 10/10/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise;

@interface Detail : NSManagedObject

@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * kg_lbs;
@property (nonatomic, retain) Exercise *exercise;

@end
