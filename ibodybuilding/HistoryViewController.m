//
//  HistoryViewController.m
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/16/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "HistoryViewController.h"
#import "GuideAppDelegate.h"
#import "Exercise.h"
#import "Detail.h"
#import "GraphViewController.h"
#import "CusomScrollViewCell.h"

@interface HistoryViewController ()
{
    BOOL checkEditStatus;
}

@end

@implementation HistoryViewController

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
    self.title = NSLocalizedString(@"History", nil);
    checkEditStatus = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    


}

-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"Will appear");
    [self fetchDates];
//    if (checkEditStatus == 0) {
//        [self.tableView setEditing:NO animated:YES];
//        checkEditStatus = 0;
//    }else if (checkEditStatus == 1){
//        [self.tableView setEditing:YES animated:YES];
//        checkEditStatus = 0;
//    }
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView setEditing:NO animated:YES];
    GuideAppDelegate* appDelegate = (GuideAppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchArray = [appDelegate getAllexercises];
    NSLog(@"Fetch Array: %@", self.fetchArray);
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
        self.navigationItem.leftBarButtonItem = editButton;
    if ([self.fetchArray count] ==0) {
        [editButton setEnabled:NO];
    }
    else{
        if (checkEditStatus==1)
        {
            
            
            [self.tableView setEditing:YES animated:YES];
            [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
            [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Done", nil)];
            checkEditStatus = 1;
            
        }else{
            
            
            [self.tableView setEditing:NO animated:YES];
            [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
            [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
            checkEditStatus = 0;
        }
    }

    [editButton release];
    [self fetchDates];
    [self.tableView reloadData];
    CGRect frame = self.tableView.frame;
    frame.size.height -= 50;
    [self.tableView setFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Fetch data From DB

-(void) fetchDates
{
    datesArray = [[NSMutableArray alloc] init];
    NSMutableArray *auxDatesArr = [NSMutableArray array];
    for (NSManagedObject *product in self.fetchArray) {
        Exercise *exercise = (Exercise*)product;
        NSLog(@"Fetch Array: %@", exercise);
NSLog(@"%@",exercise.date);
        if (exercise.date !=nil) 
            [auxDatesArr addObject:exercise.date];
    }
    
    NSSet *datesSet2 = [[NSSet alloc] initWithArray:auxDatesArr];
    auxDatesArr = [[NSMutableArray alloc] initWithArray:[datesSet2 allObjects]];
//    [auxDatesArr sortedArrayUsingSelector:@selector(compare:)];
    [auxDatesArr sortUsingComparator:^NSComparisonResult(NSDate* obj1, NSDate* obj2){
        return [obj2 compare:obj1];
    }];
    NSLog(@"Aux dates Arry: %@", auxDatesArr);
    [datesArray release];
    uniqueDatesArray = [[[NSMutableArray alloc] init] retain];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [format setTimeZone:[NSTimeZone systemTimeZone]];
    [format setLocale:locale];

    for (int k = 0; k< [auxDatesArr count]; k++) {
        NSString *exercDate = [format stringFromDate:[auxDatesArr objectAtIndex:k] ];
        [uniqueDatesArray addObject:exercDate];
//        [exercDate release];
    }
    [auxDatesArr release];
    [datesSet2 release];
    
//    uniqueDatesArray = [[NSMutableArray alloc] initWithArray:[datesSet allObjects]];
//    NSArray *sortedArray1 = [uniqueDatesArray sortedArrayUsingComparator: ^(id obj1, id obj2)
//                             {
//
//                                 
//                                 
//                                 if ([obj1 compare:obj2] == 1)
//                                 {
//                                     return (NSComparisonResult)NSOrderedDescending;
//                                 }
//                                 
//                                 if ([obj1 compare:obj2] == -1)
//                                 {
//                                     return (NSComparisonResult)NSOrderedAscending;
//                                 }
//                                 return (NSComparisonResult)NSOrderedSame;
//                             }];
//    uniqueDatesArray = [sortedArray1 copy];
//    [datesSet release];

}

-(void)openEditExercise:(UIButton*)sender withEvent:(id)event
{
    GraphViewController *controll = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
    [controll setHidesBottomBarWhenPushed:YES];
    controll.nameOfexercise = sender.titleLabel.text;
    controll.title =[self getLocalizedStringFromString:sender.titleLabel.text];
    controll.referencialDate = [[sender.subviews objectAtIndex:1] text];
    [self.navigationController pushViewController:controll animated:YES];
    [controll release];
}
- (NSString *)getLocalizedStringFromString:(NSString *)string
{
    NSString *localizedString = nil;
    
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    
    
   BOOL a =  [scanner scanCharactersFromSet:numbers intoString:&numberString];
//    NSLog(@"Scanning: %d", (int)a);
    if (a) {
    // Result.
    int number;
    number = [numberString integerValue];
 
    
    localizedString = NSLocalizedStringFromTable([string substringFromIndex:[numberString length]+1], @"content", nil);
    
    // Intermediate
    
    
    localizedString = [[NSString stringWithFormat:@"%i ",number] stringByAppendingString:localizedString];
    
        return localizedString;}else{
            return  string;
        }
}


#pragma mark - Table view data source

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//     NSLog(@"Number of rows in section");
    // Return the number of rows in the section.
    [self fetchDates];
//    NSLog(@"Number of rows in section %d", [uniqueDatesArray count]);
    if ([uniqueDatesArray count] == 0) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }else
    {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    return [uniqueDatesArray count];
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([uniqueDatesArray count] ==0)
    {
        UILabel *fLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [fLbl setTextColor:[UIColor lightGrayColor]];
        [fLbl setBackgroundColor:[UIColor clearColor]];
        [fLbl setTextAlignment:NSTextAlignmentCenter];
        [fLbl setText: NSLocalizedString(@"No exercises have been done yet", nil)];
        return fLbl;
    }
    
    return nil;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int imageSpace = 0;
    int i = 0;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
        else
    {
        

    }

    [cell setBackgroundColor:[UIColor whiteColor]];
   
    [[cell textLabel] setText:[uniqueDatesArray objectAtIndex:indexPath.row]];
    
//    for (NSManagedObject *product in self.fetchArray) {
//        Exercise *exercise = (Exercise*)product;
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        [format setDateStyle:NSDateFormatterShortStyle];
//        NSLocale *locale = [NSLocale currentLocale];
//        [format setTimeZone:[NSTimeZone systemTimeZone]];
//        [format setLocale:locale];
//        NSString *exercDate = [format stringFromDate:exercise.date];
//        [format release];
//        if ([cell.dateLabel.text isEqualToString:exercDate])
//        {
////            UIImage *myImage;
////            myImage = [[UIImage alloc] initWithContentsOfFile:exercise.link];
////            CGSize mySize = [myImage size];
//            CGFloat imageWidth = 200;
//            CGFloat imageHeight = 200;
//            UIButton *button;
//            
//            if (imageWidth>imageHeight)
//            {
//                
//                
//                
//                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                [button addTarget:self
//                           action:@selector(openEditExercise:withEvent:)
//                 forControlEvents:UIControlEventTouchDown ];
//                button.frame = CGRectMake(0+imageSpace, 10, imageWidth/4-10, imageHeight/4-10);
//                button.tag = i;
//                button.highlighted = [UIColor blueColor];
//                imageSpace = imageSpace + imageWidth/4;
////                UIGraphicsBeginImageContext(CGSizeMake(160.0f, 100.0f));
////                [myImage drawInRect:CGRectMake(0,0,160,100)];
////                UIImage* small = UIGraphicsGetImageFromCurrentImageContext();
////                UIGraphicsEndImageContext();
////                [myImage release];
////                [button setImage:small forState:UIControlStateNormal];
////                [small release];
//                [cell.scrollView addSubview:button];
//                
//                
//                
//                
//            }else{
//                
//                
//                
//                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                [button addTarget:self
//                           action:@selector(openEditExercise:withEvent:)
//                 forControlEvents:UIControlEventTouchDown];
//                button.frame = CGRectMake(0+imageSpace, 0, imageWidth/4-10, imageHeight/4-10);
//                button.tag = i;
//                i++;
//                imageSpace = imageSpace + imageWidth/4;
////                UIGraphicsBeginImageContext(CGSizeMake(100.0f, 160.0f));
////                [myImage drawInRect:CGRectMake(0,0,100,160)];
////                UIImage* small = UIGraphicsGetImageFromCurrentImageContext();
////                UIGraphicsEndImageContext();
////                [myImage release];
////                [button setImage:small forState:UIControlStateNormal];
////                [small release];
//                [cell.scrollView addSubview:button];
//                
//            }
//            [button setTitle:exercise.name forState:UIControlStateNormal];
//            UILabel *dateLbl = [[UILabel alloc] init];
//            dateLbl.text = cell.dateLabel.text;
//            [dateLbl setAlpha:0];
//            [button addSubview:dateLbl];
//            [dateLbl release];
////            [myImage release];
//            cell.scrollView.contentSize = CGSizeMake(imageSpace, 80);
//            
//        }
//       
//    }
//    if (cell.scrollView.contentSize.width > 195) {
//        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow@2x.png"]];
//        [arrowImage setFrame:CGRectMake(270, 0, 30, 78)];
//        [cell.contentView addSubview:arrowImage];
//        [arrowImage release];
//    }
//}else
//    if (checkEditStatus == 1)
//    {
////        [cellScroll removeFromSuperview];
//        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 23, 60, 33)];
//        [editButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
//        [editButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_cell_passive" ofType:@"png"]] forState:UIControlStateNormal];
//        [editButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_cell_active" ofType:@"png"]] forState:UIControlStateHighlighted];
//        [editButton addTarget:self action:@selector(openEditController:event:) forControlEvents:UIControlEventTouchUpInside];
//        editButton.tag = indexPath.row;
//        UILabel *dateLbl = [[UILabel alloc] init];
//        [dateLbl setText:[uniqueDatesArray objectAtIndex:indexPath.row]];
//        [dateLbl setTextColor:[UIColor clearColor]];
//        [dateLbl setTag:1234];
//        [editButton addSubview:dateLbl];
//        [dateLbl release];
//        [editButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
//        [cell.contentView addSubview:editButton];
//        [editButton release];
//        
//        
//    }else{
//        
//        
//        
//    }
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



-(void)openEditController:(UIButton*)sender event:(id)event
{
    DeleteHistoryController *coltoller = [[DeleteHistoryController alloc] initWithNibName:@"DeleteHistoryController" bundle:nil];
    for (UILabel* lbl in [sender subviews]) {
        if (lbl.tag == 1234) {
//            NSLog(@"lbl text: %@", lbl.text);
    coltoller.dateOfExerc = lbl.text;
        }
    }
     coltoller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coltoller animated:YES];
    [coltoller release];
}


-(void)reloadDataInTableView{
    
    [self.tableView reloadData];
    
}
-(void)editButtonPressed{
    
    if (checkEditStatus==0)
    {
        
        [self.tableView setEditing:NO animated:NO];
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Done", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.2];
        checkEditStatus = 1;
        
    }else{
        
        
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.2];
        checkEditStatus = 0;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        checkEditStatus = 0;
        // Delete the row from the data source
        CusomScrollViewCell *cell = (CusomScrollViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        GuideAppDelegate *appDelegate = (GuideAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        for (NSManagedObject *product in self.fetchArray) {
            Exercise *exercise = (Exercise*)product;
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateStyle:NSDateFormatterShortStyle];
            NSLocale *locale = [NSLocale currentLocale];
            [format setTimeZone:[NSTimeZone systemTimeZone]];
            [format setLocale:locale];
            NSString *exercDate = [format stringFromDate:exercise.date];
            if ([exercDate isEqualToString:cell.textLabel.text]) {
                NSLog(@"deleting");
                [context deleteObject:product];
            }
            [format release];
            
        }
        NSError *error;
        [context save:&error];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self fetchDates];
//        [tableView reloadData];
        checkEditStatus = 0;
//        [tableView setEditing:NO animated:YES];
        [tableView reloadData];
//        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DeleteHistoryController *coltoller = [[DeleteHistoryController alloc] initWithNibName:@"DeleteHistoryController" bundle:nil];

            coltoller.dateOfExerc = cell.textLabel.text;
    coltoller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:coltoller animated:YES];
    [coltoller release];



}

- (void)dealloc {
    [self.tableView release];
    [self.fetchArray release];
    [uniqueDatesArray removeAllObjects];
    [uniqueDatesArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
