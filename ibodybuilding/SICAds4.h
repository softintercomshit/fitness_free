//
// Created by kivlara on 6/26/13.
// Copyright (c) 2013 Softintercom & Co. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SICAds4 : NSObject



+ (void) debug;

+ (void) startAuto;
+ (void) startManually;

+ (void) rate:(int)delay_seconds;
+ (NSMutableArray*) sicadsGallery;

@end