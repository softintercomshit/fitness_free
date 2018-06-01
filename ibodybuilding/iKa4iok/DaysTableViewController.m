//
//  DaysTableViewController.m
//  iKa4iok
//
//  Created by Johnny Bravo on 12/4/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "DaysTableViewController.h"
#import "ExercisePicker.h"
@interface DaysTableViewController ()
@property(nonatomic, retain)NSMutableArray *daysArray;
@end

@implementation DaysTableViewController
@synthesize isPreview,isEditing;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDataArray:(NSArray *)dataArray name:(NSString *)name{
    
    self = [super init];
    if (self) {
        
        
        NSMutableArray *contentArray = [[NSMutableArray alloc] initWithArray:dataArray copyItems:YES];
        contentDictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i<[contentArray count]; i++) {
            
            NSMutableArray *sendArray = [[NSMutableArray alloc] init];
            
            [sendArray addObject:[contentArray objectAtIndex:i]];
            [contentDictionary setObject:sendArray forKey:[NSString stringWithFormat:@"%d",i]];
            [sendArray release];
            
        }
        

        [contentArray release];
        self.title = [NSString stringWithString:name];
    }
    return self;
}

-(void)dealloc{
    
    [contentDictionary release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IS_HEIGHT_GTE_568) {
        daysTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 510) style:UITableViewStylePlain];
    }else{
        
        daysTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    }
    
    if (isEditing == 0) {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(getBackToRootViewController)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        [backButton release];
    }else{
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(getBackWithOneController)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        [backButton release];
    }

    [self.view addSubview:daysTableView];
    [daysTableView setDelegate:self];
    [daysTableView setDataSource:self];
    [daysTableView setShowsVerticalScrollIndicator:NO];
}



-(void)getBackWithOneController {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)getBackToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getFolderObjectsCount];
    
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}

-(void)getFolderObjectsCount{
    
    for (int i = 0; i<[contentDictionary count]; i++) {
        
        NSString *pathString = [[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] objectAtIndex:0];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *fileList = [manager contentsOfDirectoryAtPath:pathString error:nil];
        
        for (int j=0; j<[fileList count]; j++) {
            
            NSString *fullPath = [pathString stringByAppendingPathComponent:[fileList objectAtIndex:j]];
            
            if ([[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] count]>1) {
                  [[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",i]]removeLastObject];
                 [[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] addObject:[NSNumber numberWithInt:[[NSMutableArray arrayWithContentsOfFile:fullPath] count]]];
            }else{
              
                [[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] addObject:[NSNumber numberWithInt:[[NSMutableArray arrayWithContentsOfFile:fullPath] count]]];
            }
        }
    }
    [daysTableView reloadData];
}

-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    
    return fileList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contentDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageOnRightCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    [[cell textLabel] setText:[[[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] objectAtIndex:0] lastPathComponent]];
     if ([[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] count]>1) {
          [[cell detailTextLabel] setText:[@"Exercises:" stringByAppendingFormat:@"%@",[[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] objectAtIndex:1]]];
     }else{
         [[cell detailTextLabel]setText:@"Exercises:0"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    ExercisePicker *detailViewController;
    
    if (IS_HEIGHT_GTE_568) {
        detailViewController = [[ExercisePicker alloc] initWithNibName:@"ExercisePickerip5" bundle:nil andPathLink:[[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] objectAtIndex:0]];
    }else{
        
        
        detailViewController = [[ExercisePicker alloc] initWithNibName:@"ExercisePicker" bundle:nil andPathLink:[[contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] objectAtIndex:0]];
    }
    
    
    
    detailViewController.isPreviewing = isPreview;
    detailViewController.isEditing = isEditing;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    [backButton release];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
