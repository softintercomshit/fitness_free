//
//  DeleteHistoryController.m
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 9/10/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "DeleteHistoryController.h"
#import "Exercise.h"
#import "Detail.h"
#import "GuideAppDelegate.h"
#import "GraphViewController.h"

@interface DeleteHistoryController ()

@end

@implementation DeleteHistoryController

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

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView setEditing:NO animated:NO];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Indetnt");
    return NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    GuideAppDelegate* appDelegate = (GuideAppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchArray = [appDelegate getAllexercises];
    [self fetchExercises];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    if ([self.fetchArray count] ==0) {
        [editButton setEnabled:NO];
    }
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    checkeditStatus = 0;
    [self.tableView reloadData];
    CGRect frame = self.tableView.frame;
    frame.size.height -= 50;
    [self.tableView setFrame:frame];
}
-(void)editButtonPressed{
    
    if (checkeditStatus==0)
    {
        
        [self.tableView setEditing:NO animated:NO];
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Done", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.2];
        checkeditStatus = 1;
        
    }else{
        
        
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.2];
        checkeditStatus = 0;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataInTableView
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(void) fetchExercises
{
    exercisesArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *product in self.fetchArray) {
        Exercise *exercise = (Exercise*)product;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSString *exercDate = [format stringFromDate:exercise.date];
        [format release];
//        NSLog(@"1)date of exercise: %@", self.dateOfExerc);
//        NSLog(@"2)date of exercise: %@", exercDate);
        
        if ((exercDate!=nil) && ([exercDate isEqualToString:self.dateOfExerc])) {
            [exercisesArray addObject:exercise];
        }
    }

    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

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
    [self fetchExercises];
//    NSLog(@"Exercise array: %@", exercisesArray);
    return [exercisesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }else{
        cell = nil;
//        [cell release];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell...
    
        Exercise *exercise = (Exercise*)[exercisesArray objectAtIndex:indexPath.row];
    NSString *path;
    NSArray *comps = [exercise.link pathComponents];
    if ([[comps objectAtIndex:5] isEqualToString:@"Library"]) {
        NSLog(@"1 - %@", [comps objectAtIndex:5]);
        path = [[NSBundle mainBundle] resourcePath];
        path = [path stringByDeletingLastPathComponent];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-2]];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-1]];
    }else{
        NSLog(@"2 - %@", [comps objectAtIndex:5]);
        path = [[NSBundle mainBundle] resourcePath];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-4]];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-2]];
        path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-1]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    UIImage* myImage = [[UIImage alloc] initWithContentsOfFile:path];
    CGSize mySize = [myImage size];
    CGFloat imageWidth = mySize.width;
    CGFloat imageHeight = mySize.height;
    if (imageHeight<imageWidth){
    [imageView setFrame:CGRectMake(5, 10, imageWidth/4-2, imageHeight/4-2)];
    }else{
    [imageView setFrame:CGRectMake(20, 0.5, imageWidth/4-2, imageHeight/4-2)];
    }
    
    [cell.contentView insertSubview:imageView aboveSubview:cell.textLabel];
    [imageView release];
    [myImage release];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 205, 15)];
    [titleLabel setText:[self getLocalizedStringFromString:exercise.name]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cell.contentView insertSubview:titleLabel aboveSubview:cell.textLabel];
    [titleLabel release];
    cell.textLabel.text =exercise.name;
    [cell.textLabel setTextColor:[UIColor clearColor]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:0.1];
    [cell.textLabel setFrame:CGRectMake(0, 0, 0, 0)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)getLocalizedStringFromString:(NSString *)string
{
    NSString *localizedString = nil;
//    
//    NSString *numberString;
//    
//    NSScanner *scanner = [NSScanner scannerWithString:string];
//    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    
//    // Throw away characters before the first number.
//    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
//    
//    // Collect numbers.
//    BOOL a =[scanner scanCharactersFromSet:numbers intoString:&numberString];
//    if (a) {
//         // Result.
//    int number = [numberString integerValue];
//    
    localizedString = NSLocalizedStringFromTable(string, @"content", nil);
    
    // Intermediate
    
//    
//    localizedString = [[NSString stringWithFormat:@"%i ",number] stringByAppendingString:localizedString];
    
    return localizedString;
//
//    }else
//        
//    {
//        return string;
//    }
   }


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        checkeditStatus = 0 ;
        // Delete the row from the data source
        [self.tableView setContentOffset:CGPointMake(20, 0) animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
//            NSLog(@"1) %@", exercDate);
//            NSLog(@"2) %@", self.dateOfExerc);
//            NSLog(@"name1 %@", exercise.name);
//            NSLog(@"name2 %@", cell.textLabel.text);
            if (([exercise.name isEqualToString:cell.textLabel.text])&& ([exercDate isEqualToString:self.dateOfExerc])) {
            
//                NSLog(@"3) %@", exercDate);
//                NSLog(@"4) %@", self.dateOfExerc);
                
                [context deleteObject:product];
                
//                NSLog(@"******** %@", _fetchArray);
                
                
                
            }
            [format release];
            
        }
        NSError *error;
        [context save:&error];
        [self fetchExercises];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
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
    GraphViewController *controll = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
    [controll setHidesBottomBarWhenPushed:YES];
    controll.nameOfexercise = cell.textLabel.text;
    controll.title =[self getLocalizedStringFromString:cell.textLabel.text];
    controll.referencialDate = self.dateOfExerc;
    [self.navigationController pushViewController:controll animated:YES];
    [controll release];
}

-(void)dealloc
{
    [exercisesArray release];
    [super dealloc];
}

@end
