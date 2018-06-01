//
//  NSObject_Constant.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/12/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//
#import <Availability.h>

#ifndef __IPHONE_4_0
#warning "This project uses features only available in iOS SDK 4.0 and later."
#endif

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#define MAIN_LINK @"http://ciberya.net/iBodyBuilding/iBody3.zip"
#define VIDEO_PATH @"video.mp4"
#define SINGLE_DOWNLOAD_LINK @"http://ciberya.net/iBodyBuilding"

#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2
#define PHOTO_TAG 3

    //Random Keys:
#define FIRST_TITLE @"Exercises"
#define SECOND_TITLE @"Workouts"
#define THIRD_TITLE @"Custom"




#endif