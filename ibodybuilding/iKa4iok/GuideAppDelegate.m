//
//  GuideAppDelegate.m
//  iKa4iok
//
//  Created by Johnny Bravo on 11/8/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "GuideAppDelegate.h"
#import "IBVideoPlayer.h"
#import "SICAds4.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import "GADRequest.h"



@interface UITabBarController (Custom)

@end


@implementation UITabBarController (Custom)
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
}


@end


@implementation GuideAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)dealloc
{
    [_window release];
    [_firstNavigator release];
    [_secondNavigator release];
    [_thirdNavigator release];
    [super dealloc];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
     FirstGuideMaster *rootViewController = [[FirstGuideMaster alloc]initWithNibName:nil bundle:nil];
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    [aNavigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.firstNavigator = aNavigationController;
    [aNavigationController release];
    [rootViewController release];
    
    SecondGuideMaster *viewController1 = [[SecondGuideMaster alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *aNavigationController1 = [[UINavigationController alloc]initWithRootViewController:viewController1];
    [aNavigationController1.navigationBar setBarStyle:UIBarStyleDefault];
    self.secondNavigator = aNavigationController1;
    [aNavigationController1 release];
    [viewController1 release];
    
    ThirdGuideMaster *viewController2 = [[ThirdGuideMaster alloc]initWithNibName:nil bundle:nil];
    UINavigationController *aNavigationController2 = [[UINavigationController alloc]initWithRootViewController:viewController2];
    [aNavigationController2.navigationBar setBarStyle:UIBarStyleDefault];
    self.thirdNavigator = aNavigationController2;
    [aNavigationController2 release];
    [viewController2 release];
    
//    HistoryViewController *viewController3 = [[HistoryViewController alloc]initWithStyle:UITableViewStyleGrouped];
//    UINavigationController *aNavigationController3 = [[UINavigationController alloc]initWithRootViewController:viewController3];
//    [aNavigationController3.navigationBar setBarStyle:UIBarStyleDefault];
//    self.historyNavigator = aNavigationController3;
//    [aNavigationController3 release];
//    [viewController3 release];
    
    FeedbackViewController *viewController4 = [[FeedbackViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *aNavigationController4 = [[UINavigationController alloc]initWithRootViewController:viewController4];
    [aNavigationController4.navigationBar setBarStyle:UIBarStyleDefault];
    self.historyNavigator1 = aNavigationController4;
    [aNavigationController4 release];
    [viewController4 release];
    
    self.isInApp = 1;
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Exercises", nil) image:[UIImage imageNamed:@"exercises.png"] tag:444];
    [self.firstNavigator setTabBarItem:item1];
    [item1 release];
    
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Workouts", nil) image:[UIImage imageNamed:@"workout.png"] tag:555];
    [self.secondNavigator setTabBarItem:item2];
    [item2 release];
    
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Custom", nil) image:[UIImage imageNamed:@"custom.png"] tag:666];
    [self.thirdNavigator setTabBarItem:item3];
    [item3 release];
    
//    UITabBarItem *item4 = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"History", nil) image:[UIImage imageNamed:@"history.png"] tag:777];
//    [self.historyNavigator setTabBarItem:item4];
//    [item4 release];
    
    UITabBarItem *item5 = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"More", nil) image:[UIImage imageNamed:@"feedback.png"] tag:888];
    [self.historyNavigator1 setTabBarItem:item5];
    [item5 release];
 
    
    self.tabBarController = [[[UITabBarController alloc]init]autorelease];

    
    self.tabBarController.viewControllers = @[self.firstNavigator,self.secondNavigator,self.thirdNavigator, /*self.historyNavigator,*/ self.historyNavigator1];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
//    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ @"4ca92f45476b322f7c1484f0f1bf1319" ];
//    
//    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
//    bannerView.rootViewController = (id)self;
//    bannerView.delegate = (id<GADBannerViewDelegate>)self;
//    
//    bannerView.frame = CGRectMake(0, self.window.frame.size.height - 100, 320, 50);
//    NSLog(@"Frame : %@", NSStringFromCGRect(bannerView.frame));
//    
//    [bannerView loadRequest:request];
//    bannerView.layer.zPosition++;
//    
////    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//    [self.window addSubview: bannerView];
    
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    

    
    [[VideoDownloader instance]applicationHasBeenBackgrounded];
    [[IBVideoPlayer sharedVPlayer] removeVideoController];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
     
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [SICAds4 debug];
    [SICAds4 startAuto];
    
//    self.isInApp = 1;
    [[IBVideoPlayer sharedVPlayer] removeVideoController];
    [[VideoDownloader instance]applicationHasBeenForgrounded];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.

}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

// 0

+ (GuideAppDelegate *)get {
    return (GuideAppDelegate *) [[UIApplication sharedApplication] delegate];
}

// 1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
//    NSString *urlString = [[self applicationDocumentsDirectory] absoluteString];
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"iKa4iokBD.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator
         addPersistentStoreWithType:NSSQLiteStoreType
         configuration:nil
         URL:storeUrl
         options:nil
         error:&error])
    {
        /*Error for store creation should be handled in here*/
    }
    return _persistentStoreCoordinator;
}



-(NSArray*)getAllexercises;

{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    // Returning Fetched Records
    return fetchedRecords;
}

//Facebook Sharing
#pragma mark - Facebook Sharing

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Parse the incoming URL to look for a target_url parameter
                                      NSString *query = [url fragment];
                                      if (!query) {
                                          query = [url query];
                                      }
                                      NSDictionary *params = [self parseURLParams:query];
                                      // Check if target URL exists
                                      NSString *targetURLString = [params valueForKey:@"target_url"];
                                      if (targetURLString) {
                                          // Show the incoming link in an alert
                                          // Your code to direct the user to the appropriate flow within your app goes here
                                          [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                                                      message:targetURLString
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil] show];
                                      }
                                  }];
    
    return urlWasHandled;
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}



@end
