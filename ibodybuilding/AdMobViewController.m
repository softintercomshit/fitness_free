//
//  AdMobViewController.m
//  iBodybuilding-Update
//
//  Created by Cibota Olga on 11/4/14.
//  Copyright (c) 2014 com.softintercom. All rights reserved.
//

#import "AdMobViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
static AdMobViewController *sharedAdMobController = nil;
@implementation AdMobViewController
@synthesize bannerView;

+ (id)sharedAdMob {
    @synchronized(self) {
        if(sharedAdMobController == nil)
            sharedAdMobController = [[super allocWithZone:NULL] init];
    }
    return sharedAdMobController;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedAdMob] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}
- (oneway void)release {
    // never release
}
- (id)autorelease {
    return self;
}

- (id)init {
    if (self = [super init]) {
         UIWindow* mainWindow = [[[UIApplication sharedApplication] delegate] window];
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ @"4ca92f45476b322f7c1484f0f1bf1319", @"a815cabf3e1c9ad3fdc714d6a999cfd2", @"166cc55ed9425694bcd84a46f527aa5e" ];
        
        bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView.adUnitID = @"ca-app-pub-6299356723726253/9590853920";
        bannerView.rootViewController = (id)self;
        bannerView.delegate = (id<GADBannerViewDelegate>)self;
        
        bannerView.frame = CGRectMake(0, 568 - 200, 320, 50);
        NSLog(@"Frame : %@", NSStringFromCGRect(bannerView.frame));
        
        [bannerView loadRequest:request];
//        bannerView.layer.zPosition++;
        
       
        [mainWindow addSubview: bannerView];
    }
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [bannerView release];
    [super dealloc];
}

- (BOOL)connectedToInternet
{
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode]==200)?YES:NO;
}

-(void)bannerFrame:(CGRect)frame{
    GADRequest *request = [GADRequest request];
    [bannerView loadRequest:request];
    bannerView.frame = frame;
}


@end
