//
//  FeedbackViewController.m
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 9/9/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "FeedbackViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

#define APP_ID 698154775

@interface FeedbackViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation FeedbackViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"More", nil);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}
-(void)viewWillAppear:(BOOL)animated
{
//     [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 100 ,320,50)];
    if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
        [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 100,320,50)];
        
        NSLog(@"Internet connection established");
    }else{
        NSLog(@"No Internet connection established");
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 140,0,0)];
        
        [self.tableView setFrame:self.view.frame];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height - 50;
    [self.tableView setFrame:frame];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedString(@"Send Feedback", nil) ;
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
            cell.imageView.image = [UIImage imageNamed:@"send_feedback@2x.png"];
            cell.backgroundColor = [UIColor whiteColor];
            }else{
                
                cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send_feedback.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                [cell.contentView addSubview:img];
                [img release];
                cell.backgroundColor = [UIColor whiteColor];
            }
            break;
        }
        case 1:
        {
            cell.textLabel.text =NSLocalizedString(@"Report a Bug", nil) ;
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
            cell.imageView.image = [UIImage imageNamed:@"report_bug@2x.png"];
                cell.backgroundColor = [UIColor whiteColor];
            }else{
                
                cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"report_bug.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                [cell.contentView addSubview:img];
                [img release];
                cell.backgroundColor = [UIColor whiteColor];
                cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
            }
            break;
        }
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"Tell a Friend", nil);

            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                      cell.imageView.image = [UIImage imageNamed:@"tell_friend@2x.png"];
            cell.backgroundColor = [UIColor whiteColor];
            }else{
                
                cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tell_friend.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                [cell.contentView addSubview:img];
                [img release];
                cell.backgroundColor = [UIColor whiteColor];

            }
            
            break;
        }

        
        case 3:
        {
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            cell.textLabel.text = NSLocalizedString(@"Rate us", nil);
            cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rate_review.png"]];
            [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
            [cell.contentView addSubview:img];
            [img release];
                cell.backgroundColor = [UIColor whiteColor];}
            else{
                cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
                cell.textLabel.text = NSLocalizedString(@"Rate us", nil);
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rate_review.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                [cell.contentView addSubview:img];

            }
            break;
        }
        case 4:
        {
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                cell.textLabel.text = NSLocalizedString(@"Share on Facebook", nil);
                cell.imageView.image = [UIImage imageNamed:@"facebook_icon.png"];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_icon.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                [cell.contentView addSubview:img];
                [img release];
                cell.backgroundColor = [UIColor whiteColor];}
            else{
                cell.imageView.image = [UIImage imageNamed:@"send_feedback.png"];
                cell.textLabel.text = NSLocalizedString(@"Share on Facebook", nil);
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_icon.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                [cell.contentView addSubview:img];

            }
            break;
        }
        case 5:
        {
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                cell.textLabel.text = NSLocalizedString(@"Max Fitness - Pro Version", nil);
                cell.imageView.image = [UIImage imageNamed:@"Pro-V@2x.png"];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pro-V@2x.png"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
                //                [cell.contentView addSubview:img];
                
                [img release];
                cell.backgroundColor = [UIColor whiteColor];}
            else{
                cell.imageView.image = [UIImage imageNamed:@"Pro-V"];
                cell.textLabel.text = NSLocalizedString(@"Max Fitness - Pro Version", nil);
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pro-V"]];
                [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
//                [cell.contentView addSubview:img];
                
            }

                        break;
        }
        case 6:
        {
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            cell.textLabel.text = NSLocalizedString(@"6 Pack Abs from Valerio Gucci", nil);
            cell.imageView.image = [UIImage imageNamed:@"ABSIconBW144@2x.png"];
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ABSIconBW144@2x.png"]];
            [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
            //                [cell.contentView addSubview:img];
            
            [img release];
            cell.backgroundColor = [UIColor whiteColor];}
            else{
            cell.imageView.image = [UIImage imageNamed:@"ABSIconBW144"];
            cell.textLabel.text = NSLocalizedString(@"6 Pack Abs", nil);
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ABSIconBW144"]];
            [img setFrame:CGRectMake(8, 3, img.frame.size.width, img.frame.size.height)];
//            [cell.contentView addSubview:img];
            
            }
            break;
        }


            
        default:
            break;
    }
//    [cell setBackgroundColor:[UIColor blackColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *currDeiceVer = [[UIDevice currentDevice] platformString];
    switch (indexPath.row) {
        case 0:
        {
            if ([MFMailComposeViewController canSendMail]) {
                if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
                    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 50,320,50)];
                    
                    NSLog(@"Internet connection established");
                }else{
                    NSLog(@"No Internet connection established");
                    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 100,0,0)];
                    
                }
            
                MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                [composeViewController setMailComposeDelegate:self];
                [composeViewController setToRecipients:@[@"fitnessyourbody.com@gmail.com"]];
                [composeViewController setSubject:@"Max Fitness: Support"];
                [composeViewController setMessageBody:[NSString stringWithFormat:@"********************\nIOS Version: %@\nDevice: %@\nApplication Version: %@\n********************", currSysVer, currDeiceVer, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] isHTML:NO];
                                [self presentViewController:composeViewController animated:YES completion:nil];
            }else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Acoounts" message:@"Please set up a Mail account in order to send mail." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            break;
        }
        case 1:
        {
            if ([MFMailComposeViewController canSendMail]) {
                if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
                    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 50,320,50)];
                    
                    NSLog(@"Internet connection established");
                }else{
                    NSLog(@"No Internet connection established");
                    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 100,0,0)];
                }
            
                MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                [composeViewController setMailComposeDelegate:self];
                [composeViewController setToRecipients:@[@"fitnessyourbody.com@gmail.com"]];
                [composeViewController setSubject:@"Max Fitness: Bug Report"];
                [composeViewController setMessageBody:[NSString stringWithFormat:@"********************\nIOS Version: %@\nDevice: %@\nApplication Version: %@\n********************", currSysVer, currDeiceVer, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] isHTML:NO];
                [self presentViewController:composeViewController animated:YES completion:nil];
            }else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Acoounts" message:@"Please set up a Mail account in order to send mail." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            break;
        }
        case 2:
        {
            if ([[iTellAFriend sharedInstance] canTellAFriend]) {
                if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
                    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 50,320,50)];
                    
                    NSLog(@"Internet connection established");
                }else{
                    NSLog(@"No Internet connection established");
                    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 100,0,0)];
                    
                    [self.tableView setFrame:self.view.frame];
                }
            
                UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
                [self presentModalViewController:tellAFriendController animated:YES];
            }else
             {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Acoounts" message:@"Please set up a Mail account in order to send mail." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
            }


            break;
        }
        case 3:
        {
            
//            NSString *GiftAppURL = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=698154775&mt=8";
//
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GiftAppURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
////            [[iTellAFriend sharedInstance] rateThisApp];
//            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
            static NSString *const iOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/max-fitness-mr.-world-2014/id890472330?ls=1&mt=8";
//            int YOUR_APP_STORE_ID = ;
//
//            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]]; // Would contain the right link

            
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                if ([self storeKitFrameworkAvailable])
                {
                    //  SKStoreProductViewController
                    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
                    
                    // Configure View Controller
                    [storeProductViewController setDelegate:self];
                    storeProductViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                    storeProductViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"890472330"} completionBlock:^(BOOL result, NSError *error) {
                        if (error) {
                            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                            
                        } else {
                            // Present Store Product View Controller
                            [self presentViewController:storeProductViewController animated:YES completion:nil];
                        }
                    }];

                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/max-fitness-mr.-world-2014/id890472330?ls=1&mt=8"]];
                }
            }else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iOSAppStoreURLFormat]];
            }
            
            
           


            break;
        }case 4:
        {
            
            //
            //            NSString *GiftAppURL = [NSString stringWithFormat:@"itms-appss://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%d&productType=C&pricingParameter=STDQ&mt=8&ign-mscache=1",
            //                                    APP_ID];
            //
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GiftAppURL]];
            
            [self performSelector:@selector(shareLinkWithShareDialog:) withObject:Nil afterDelay:0.0];
            
            break;
        }
        case 5:
        {
            
            //
            //            NSString *GiftAppURL = [NSString stringWithFormat:@"itms-appss://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%d&productType=C&pricingParameter=STDQ&mt=8&ign-mscache=1",
            //                                    APP_ID];
            //
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GiftAppURL]];
            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=698154775";
            //            int YOUR_APP_STORE_ID = ;
            //
            //            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]]; // Would contain the right link
            
            
            
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
            
            break;
        }
        case 6:
        {
            

            
            //            NSString *GiftAppURL = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=698154775&mt=8";
            //
            ////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GiftAppURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            ////            [[iTellAFriend sharedInstance] rateThisApp];
            //            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id843233267";
            //            int YOUR_APP_STORE_ID = ;
            //
            //            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]]; // Would contain the right link
            
            
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                if ([self storeKitFrameworkAvailable])
                {
                    //  SKStoreProductViewController
                    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
                    
                    // Configure View Controller
                    [storeProductViewController setDelegate:self];
                    storeProductViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                    storeProductViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"843233267"} completionBlock:^(BOOL result, NSError *error) {
                        if (error) {
                            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                            
                        } else {
                            // Present Store Product View Controller
                            [self presentViewController:storeProductViewController animated:YES completion:nil];
                        }
                    }];
                    
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id843233267"]];
                }
            }else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iOSAppStoreURLFormat]];
            }
        }

            break;
        default:
            break;
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


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
        [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 100,320,50)];
        
        NSLog(@"Internet connection established");
    }else{
        NSLog(@"No Internet connection established");
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 140,0,0)];
        
        [self.tableView setFrame:self.view.frame];
    }
    
}
//Facebook share
#pragma mark - Facebook Sharing
- (IBAction)shareLinkWithShareDialog:(id)sender
{
    NSLog(@"facebook");
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSLog(@"facebook found");
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:@"Try this great app - Max Fitness!"];
        UIImage* image = [UIImage imageNamed:@"icon_120.png"];
        [mySLComposerSheet addImage:image];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/FitnessYourBody"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        
        //        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        //
        //             [controller dismissViewControllerAnimated:YES completion:Nil];
        //            };
        //        controller.completionHandler =myBlock;
        //        NSLog(@"facebook found %@", myBlock);
        //        UIImage *image = nil;
        //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //        NSData *imageData = [userDefaults objectForKey:@"cachedImageData"];
        //        if (imageData != nil){
        //             image = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
        //
        //             NSData *data = UIImageJPEGRepresentation(image, 1.0);
        //            [controller addImage:[UIImage imageWithData:data]];
        //            [controller setInitialText:[@"This is my latest image " stringByAppendingString:@"via https://www.facebook.com/Impressia"]];
        //            [self presentViewController:controller animated:YES completion:Nil];
        //            }
    }
    else{
        NSLog(@"Else");
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:NSLocalizedString(@"Notification", nil)];
        [alert setMessage:NSLocalizedString(@"Please log in to your facebook account from your device Settings", nil)];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
    }
    // Check if the Facebook app is installed and we can present the share dialog
    //    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    //    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    //    params.name = @"6  Pack Abs by Valerio Gucci";
    //    params.caption = @"Build great body with the instructor Valerio Gucci.";
    //    params.picture = [NSURL URLWithString:@"http://i.imgur.com/N4ckSbo.png?1"];
    //    params.description = @"Develop your body.";
    //
    //
    //    // If the Facebook app is installed and we can present the share dialog
    //    if ([FBDialogs canPresentShareDialogWithParams:params]) {
    //
    //        // Present share dialog
    //        [FBDialogs presentShareDialogWithLink:params.link
    //                                         name:params.name
    //                                      caption:params.caption
    //                                  description:params.description
    //                                      picture:params.picture
    //                                  clientState:nil
    //                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
    //                                          if(error) {
    //                                              // An error occurred, we need to handle the error
    //                                              // See: https://developers.facebook.com/docs/ios/errors
    //                                              NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
    //                                          } else {
    //                                              // Success
    //                                              NSLog(@"result %@", results);
    //                                          }
    //                                      }];
    //
    //        // If the Facebook app is NOT installed and we can't present the share dialog
    //    } else {
    //        // FALLBACK: publish just a link using the Feed dialog
    //
    //        // Put together the dialog parameters
    //        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                       @"Six Pack Abs by Valerio Gucci", @"name",
    //                                       @"Build great body with the instructor Valerio Gucci.", @"caption",
    //                                       @"Develop your body.", @"description",
    //                                       @"https://www.facebook.com/FitnessYourBody", @"link",
    //                                       @"http://i.imgur.com/N4ckSbo.png?1", @"picture",
    //                                       nil];
    //
    //        // Show the feed dialog
    //        [FBWebDialogs presentFeedDialogModallyWithSession:nil
    //                                               parameters:params
    //                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
    //                                                      if (error) {
    //                                                          // An error occurred, we need to handle the error
    //                                                          // See: https://developers.facebook.com/docs/ios/errors
    //                                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
    //                                                      } else {
    //                                                          if (result == FBWebDialogResultDialogNotCompleted) {
    //                                                              // User canceled.
    //                                                              NSLog(@"User cancelled.");
    //                                                          } else {
    //                                                              // Handle the publish feed callback
    //                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
    //
    //                                                              if (![urlParams valueForKey:@"post_id"]) {
    //                                                                  // User canceled.
    //                                                                  NSLog(@"User cancelled.");
    //
    //                                                              } else {
    //                                                                  // User clicked the Share button
    //                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
    //                                                                  NSLog(@"result %@", result);
    //                                                              }
    //                                                          }
    //                                                      }
    //                                                  }];
    //    }
}
-(void)viewWillDisappear:(BOOL)animated
{
//     [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 50 ,320,50)];
}
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


@end
