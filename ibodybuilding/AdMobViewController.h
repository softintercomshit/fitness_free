//
//  AdMobViewController.h
//  iBodybuilding-Update
//
//  Created by Cibota Olga on 11/4/14.
//  Copyright (c) 2014 com.softintercom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GADBannerView;
@interface AdMobViewController : NSObject
{
    GADBannerView *bannerView;
}

@property (nonatomic, retain) GADBannerView *bannerView;

//+ (void)createBanner:(UIViewController *)sender;
+ (id)sharedAdMob;
-(void)bannerFrame:(CGRect)frame;
- (BOOL)connectedToInternet;
@end
