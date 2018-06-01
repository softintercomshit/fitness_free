//
//  EditViewController.m
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/16/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "EditViewController.h"
#import "DaysTableViewController.h"
#import "DaysController.h"
@interface EditViewController ()


@end

@implementation EditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithWorkoutTitle:(NSString *)title andWorkoutPath:(NSString *)folderPath{
    
    self = [super init];
    if (self) {
        
        self.title = [title copy];
        workoutPath = [folderPath copy];
        workoutTitle = [title copy];

    }
    return self;
}

#pragma mark - Folder Extractor

-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    
    return fileList;
}

#pragma mark - ViewController Life Cycle

-(void)dealloc{
    
    [workoutPath release];
    [workoutTitle release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonisPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonisPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 50 ,320,50)];
}
#pragma mark - BarButton Actions


-(void)saveButtonisPressed{
    
    
    if (workoutTitle != nil) {
        NSLog(@"Workout path: %@", workoutPath);
        if (![[workoutPath lastPathComponent] isEqualToString:workoutTitle]) {
            
            NSArray *tempArrayForContentsOfDirectory =[[NSFileManager defaultManager] contentsOfDirectoryAtPath:workoutPath error:nil];
            
            NSString *newDirectoryPath = [[workoutPath stringByDeletingLastPathComponent]stringByAppendingPathComponent:workoutTitle];
            
            //  [[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath attributes:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            for (int i = 0; i < [tempArrayForContentsOfDirectory count]; i++)
            {
                
                NSString *newFilePath = [newDirectoryPath stringByAppendingPathComponent:[tempArrayForContentsOfDirectory objectAtIndex:i]];
                
                NSString *oldFilePath = [workoutPath stringByAppendingPathComponent:[tempArrayForContentsOfDirectory objectAtIndex:i]];
                
                NSError *error = nil;
                [[NSFileManager defaultManager] moveItemAtPath:oldFilePath toPath:newFilePath error:&error];
                
                if (error) {
                    // handle error
                    
                }
                
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:workoutPath error:nil];
            
        }else{

        }
        
    }else{
        

    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)cancelButtonisPressed{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - Memory Management Delegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    switch (indexPath.row) {
            
        case 0:
        {
              
            [[cell textLabel]setText:NSLocalizedString(@"Workout Title:", nil)];
            [[cell detailTextLabel]setText:workoutTitle];
            
            break; 
        }
            
        case 1:
        {
            
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Exercises", nil)]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ %i %@",NSLocalizedString(@"For", nil),[[self getDaysFolderList:workoutPath] count],NSLocalizedString(@"Days", nil)]];
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
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

-(void)getTextFieldData:(NSString *)data withTextFieldType:(BOOL)textFieldType{
    
    workoutTitle = [data copy];
    [self.tableView reloadData];

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Index path row: %d", indexPath.row);
    // Navigation logic may go here. Create and push another view controller.
    switch (indexPath.row) {
        case 0:
        {
            
            DataInputCller *titleInput = [[DataInputCller alloc]initWithNibName:@"DataInputCller" bundle:nil andInputType:0];
            [titleInput setDelegate:self];
            titleInput.isTitle = 1;
            titleInput.stringText = workoutTitle;
            NSLog(@"workout Title: %@", workoutTitle);
            [self.navigationController pushViewController:titleInput animated:YES];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
          break;
        }
        case 1:
        {
            NSLog(@"EDIT DA");
            
            NSMutableArray *contentArray  = [[NSMutableArray alloc]init];
            
            for (int i=0; i<[[self getDaysFolderList:workoutPath] count]; i++) {
                
                NSString *contentPath = [workoutPath stringByAppendingPathComponent:[[self getDaysFolderList:workoutPath] objectAtIndex:i]];
               [contentArray addObject:contentPath];
                
            }
            
            DaysController *daysContr = [[DaysController alloc]initWithDataArray:contentArray andMane:[workoutPath lastPathComponent]];
            daysContr.isEditing = 1;
            [self.navigationController pushViewController:daysContr animated:YES];
            [daysContr release];
            [contentArray release];
            
            break;
        }
            
        default:
            break;
    }
}

@end
