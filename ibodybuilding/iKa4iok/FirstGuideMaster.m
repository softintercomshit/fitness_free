//
//  FirstGuideMaster.m
//  iKa4iok
//
//  Created by Johnny Bravo on 11/12/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "FirstGuideMaster.h"
#import "CustomCell.h"
#import "ExerciseViewer.h"
#import "DownloadCell.h"
#import <mach/mach.h>
#import "GADBannerView.h"
#import "GADRequest.h"


#define kCellHeight 44.0

@interface FirstGuideMaster (private)

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath;

@end

@interface FirstGuideMaster ()
@property (nonatomic, strong) NSMutableArray *categoryArray;

@end


@implementation FirstGuideMaster

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(FIRST_TITLE, nil);

    }
    return self;
    
}




- (void)fetchCategorys
{
    // Fetch Notes
     self.categoryArray = [NSMutableArray arrayWithArray:[self getCategoryFolderList]];

}

-(NSArray*)getCategoryFolderList{

    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [bundlePath stringByAppendingString:@"/Default"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (int i =0 ; i<fileList.count; i++)
    {
        [resultArray addObject:[path stringByAppendingPathComponent:[fileList objectAtIndex:i]]];
    }
    
    return resultArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[VideoDownloader instance] setDelegate:self];
    [[UnZipper instance]setDelegate:self];
    if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
        [tableViews setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 100,320,50)];
        
        NSLog(@"Internet connection established");
    }else{
        NSLog(@"No Internet connection established");
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 140,0,0)];
        
        [tableViews setFrame:self.view.frame];
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
        [tableViews setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 100,320,50)];
        
        NSLog(@"Internet connection established");
    }else{
        NSLog(@"No Internet connection established");
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 140,0,0)];
        
        [tableViews setFrame:self.view.frame];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
//    self.bannerView.rootViewController = (id)self;
//    self.bannerView.rootViewController = self;
   
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (IS_HEIGHT_GTE_568)
        {
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
        }else{
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 370) style:UITableViewStyleGrouped];
        }
    }else{
    if (IS_HEIGHT_GTE_568)
    {
//         tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 520) style:UITableViewStyleGrouped];
        CGRect tvFrame = self.view.frame;
        tvFrame.size.height -= 100;
         tableViews = [[UITableView alloc] initWithFrame:tvFrame];
        
    }else{
//        tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 440) style:UITableViewStyleGrouped];
        CGRect tvFrame = self.view.frame;
        tvFrame.size.height -= 100;
        tableViews = [[UITableView alloc] initWithFrame:tvFrame];
    }
    }
    [self.view addSubview:tableViews];
    [tableViews setDelegate:self];
    [tableViews setDataSource:self];
    [tableViews setShowsVerticalScrollIndicator:NO];
    
    actionType = 0;
    
    selectedIndexes = [[NSMutableDictionary alloc] init];
    
//    [self.tableView setDataSource:self];
//    [self.tableView setDelegate:self];
//    [self.tableView setShowsVerticalScrollIndicator:NO];

//    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(320, 50)) origin:CGPointMake(0, 0)];
//    [self.view addSubview:bannerView];
//    bannerView.delegate = (id<GADBannerViewDelegate>)self;
//    GADRequest *request = [GADRequest request];
//    // Enable test ads on simulators.
//    request.testDevices = @[ GAD_SIMULATOR_ID, @"4ca92f45476b322f7c1484f0f1bf1319" ];
//    [self.bannerView loadRequest:request];

//    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ @"4ca92f45476b322f7c1484f0f1bf1319", @"a815cabf3e1c9ad3fdc714d6a999cfd2", @"166cc55ed9425694bcd84a46f527aa5e" ];
//    
//    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    bannerView.adUnitID = @"ca-app-pub-6299356723726253/9590853920";
//    bannerView.rootViewController = (id)self;
//    bannerView.delegate = (id<GADBannerViewDelegate>)self;
//    
//    bannerView.frame = CGRectMake(0, 568 - 100, 320, 50);
//    NSLog(@"Frame : %@", NSStringFromCGRect(bannerView.frame));
//    
//    [bannerView loadRequest:request];
//    [self.view addSubview:bannerView];
    
    [self fetchCategorys];
    [self report_memory];
    
}

#pragma mark - #---TableView delegate---#

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSUserDefaults *sharedDef = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0)
    {
        return 80;
    }
    else if(indexPath.section == 1 || [sharedDef boolForKey:@"isUnziped1"] == YES)
    {
        
        // If our cell is selected, return double height
        if([self cellIsSelected:indexPath]) {
            return kCellHeight * 2.0;
            
        }
        
        // Cell isn't selected so return single height
        return kCellHeight;
        
    }
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//     NSUserDefaults *sharedDef = [NSUserDefaults standardUserDefaults];
//    
//    if ([sharedDef boolForKey:@"isUnziped1"] == YES)
//    {
//        return 1;
//    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults *sharedDef = [NSUserDefaults standardUserDefaults];
    if(section == 0) return [self.categoryArray count];
    if(section == 1 || [sharedDef boolForKey:@"isUnziped1"] == YES) return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
     NSUserDefaults *sharedDef = [NSUserDefaults standardUserDefaults];
    if (indexPath.section == 0)
    {
        CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = nil;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
               
                    nib = [[NSBundle mainBundle] loadNibNamed:NSLocalizedString(@"CustomCell", nil) owner:self options:nil];
              
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:NSLocalizedString(@"CustomCell", nil) owner:self options:nil];
            }
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[CustomCell class]]) {
                    cell = (CustomCell *)oneObject;
                }
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        [[cell fxImageView]setAsynchronous:YES];
        [[cell fxImageView]setImageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"cat%i",indexPath.row] ofType:@"png"]];
       
        [[cell titleLabel] setText:NSLocalizedStringFromTable([[self.categoryArray objectAtIndex:indexPath.row] lastPathComponent], @"content", nil)];
        
        return cell;
    }
    else if(indexPath.section == 1 /*|| [sharedDef boolForKey:@"isUnziped1"] == YES*/)
    {
        DownloadCell *cell = (DownloadCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = nil;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
               // исковое заевление в суд
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
            }
            
            for (id oneObject in nib)
                
                if ([oneObject isKindOfClass:[DownloadCell class]])
                {
                    cell = (DownloadCell *)oneObject;
                    
                    switch (actionType) {
                        case 0:
                        {
                            [[cell headerLabel] setText:NSLocalizedString(@"Download Pro Version", nil)];
                             break;
                        }
                        case 1:
                        {
                            [[cell headerLabel] setText:NSLocalizedString(@"Downloading Videos", nil)];
                            break;
                        }
                        case 2:
                        {
                            [[cell headerLabel] setText:NSLocalizedString(@"Unzipping Files", nil)];
                            break;
                        }
                            
                        default:
                            break;
                    }
                 
                    
                }
            
            BOOL isSelected = ![self cellIsSelected:indexPath];
            
            [[cell progressTitleLabel]setHidden:isSelected];
            [[cell downloadProgressView]setHidden:isSelected];
            
        }
        
        return cell;
    }
  
    return nil;
}





- (BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
	return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

#pragma mark - Download Manager Delegates

-(void)videoDownloaderDidFinishDownloadingZipFileWithValue:(BOOL)downloadValue andPath:(NSString *)filePath
{
    
    if (downloadValue == YES)
    {
        isDownloading = NO;
        [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] headerLabel] setText:NSLocalizedString(@"Unzipping Files", nil)];
        NSLog(@"File path");
        [[UnZipper instance] startUnZipingWithFilePath:filePath];
        actionType = 2;
    }
    else
    {
    }
    
    
}

-(void)setUnZipProgressInPercents:(int)zipPercents andNumOfFiles:(int)numberOfFiles andFilePath:(NSString *)filePath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] downloadProgressView]setProgress:(float)zipPercents/100.0f animated:YES];
        [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] progressTitleLabel]setText:[NSString stringWithFormat:@"%i %@",numberOfFiles,NSLocalizedString(@"Files", nil)]];
        isUnziping = YES;
        if ((float)zipPercents/100.0f == 1.0f)
        {
            NSUserDefaults *sharedDef = [NSUserDefaults standardUserDefaults];
            [sharedDef setBool:YES forKey:@"isUnziped"];
            [sharedDef setBool:YES forKey:@"isUnziped1"];
            [sharedDef synchronize];
            [tableViews reloadData];
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
            isUnziping = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:NSLocalizedString(@"All videos were saved successfully!", nil)
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            actionType = 0;
            
        }
    });
}

-(void)setProgressViewValue:(float)progressValue
{
    isDownloading = YES;
    [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] downloadProgressView]setProgress:0.0f animated:YES];
    [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] downloadProgressView]setProgress:progressValue animated:YES];
    [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] progressTitleLabel]setText:[NSString stringWithFormat:@"%0.f%%",progressValue*100]];
}


#pragma mark - UIAlertView Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        NSNumber *selectedIndex = [NSNumber numberWithBool:NO];
        [selectedIndexes setObject:selectedIndex forKey:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        // This is where magic happens...
        [tableViews beginUpdates];
        [tableViews endUpdates];
        [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] progressTitleLabel] setHidden:!NO];
        [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] downloadProgressView] setHidden:!NO];
        [[VideoDownloader instance] startDownloadingFileWithisSelectedValue:NO];
        [[(DownloadCell*)[tableViews cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] headerLabel] setText:NSLocalizedString(@"Download all videos", nil)];
    }
    

}


#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *sharedDef = [NSUserDefaults standardUserDefaults];
    if (indexPath.section == 1 /*&& ![sharedDef boolForKey:@"isUnziped1"] == YES*/)
    {
       /* if (isUnziping == NO)
        {
            // Deselect cell
            [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
            
            // Toggle 'selected' state
            BOOL isSelected = ![self cellIsSelected:indexPath];
            
            if (isSelected == NO)
            {
                UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Warning!", nil)
                                                                message:NSLocalizedString(@"Do you really want to cancel the download process? All progress will be lost!", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
                [alerts show];
                [alerts release];

            }else
            {
                NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
                [selectedIndexes setObject:selectedIndex forKey:indexPath];
                
                // This is where magic happens...
                [tableViews beginUpdates];
                [tableViews endUpdates];
                [tableViews scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
                [[(DownloadCell*)[tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] headerLabel] setText:NSLocalizedString(@"Downloading Videos", nil)];
                [[(DownloadCell*)[tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] progressTitleLabel] setHidden:!isSelected];
                [[(DownloadCell*)[tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]] downloadProgressView] setHidden:!isSelected];
                [[VideoDownloader instance] startDownloadingFileWithisSelectedValue:isSelected];
                
                actionType = 1;
                
            }
        
            
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }*/
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=698154775";
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            if ([self storeKitFrameworkAvailable])
            {
                //  SKStoreProductViewController
                SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
                
                // Configure View Controller
                [storeProductViewController setDelegate:self];
                storeProductViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                storeProductViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"698154775"} completionBlock:^(BOOL result, NSError *error) {
                    if (error) {
                        NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                        
                    } else {
                        // Present Store Product View Controller
                        [self presentViewController:storeProductViewController animated:YES completion:nil];
                    }
                }];
                
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=698154775"]];
            }
        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iOSAppStoreURLFormat]];
        }

        
    }
    
        else if(indexPath.section == 0)
    {
        
        ExerciseViewer *exerciseTable = [[ExerciseViewer alloc] initWithCategory:[self.categoryArray objectAtIndex:indexPath.row] andVideoURL:[[self.categoryArray objectAtIndex:indexPath.row] lastPathComponent]];
        exerciseTable.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exerciseTable animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [exerciseTable release];
        [[VideoDownloader instance] setDelegate:nil];
        [[UnZipper instance]setDelegate:nil];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) storeKitFrameworkAvailable
{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] >= 7) return NO;
    Class skClass=NSClassFromString(@"SKStoreProductViewController");
	return skClass!=nil;
}

-(void) report_memory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}
#pragma mark - #---Relese Methods---#

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (void)dealloc {
    [selectedIndexes release];
	selectedIndexes = nil;
    [tableViews setDelegate:nil];
    [tableViews setDataSource:nil];
    [tableViews release];
    [super dealloc];
}
- (void)viewDidUnload {
    tableViews = nil;
    [super viewDidUnload];
}
@end
