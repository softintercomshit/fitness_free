//
//  Exercise.h
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/14/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Detail;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * workout;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSSet *detail;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addDetailObject:(Detail *)value;
- (void)removeDetailObject:(Detail *)value;
- (void)addDetail:(NSSet *)values;
- (void)removeDetail:(NSSet *)values;

@end
