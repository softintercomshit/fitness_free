//
//  GuideAppDelegate.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/8/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstGuideMaster.h"
#import "SecondGuideMaster.h"
#import "ThirdGuideMaster.h"
#import "HistoryViewController.h"
#import "FeedbackViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface GuideAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UnZipperDelegate,VideoDownloaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, readwrite) int isInApp;
@property (strong, nonatomic) UINavigationController *firstNavigator,*secondNavigator,*thirdNavigator, *historyNavigator, *historyNavigator1;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

-(NSArray*)getAllexercises;

@end
