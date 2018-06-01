//
//  DaysControllerViewController.m
//  iKa4iok
//
//  Created by Johnny Bravo on 11/30/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "PickDays.h"


@interface PickDays ()
@property (nonatomic, strong)NSMutableArray *days;
@property (nonatomic, strong)NSString *selectedType;
@end

@implementation PickDays
@synthesize days;

-(id)initWithType:(NSString *)type {
    
    self = [super init];
    if (self) {
        self.selectedType = type;
        self.title = NSLocalizedString([self.selectedType lastPathComponent], nil);
    }
    return self;
}

-(void)fetchDays{
    days =[[NSMutableArray alloc] initWithArray:[self getDaysFolderList:self.selectedType]];
}


-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    NSMutableArray * contentArray = [NSMutableArray array];
    
    for (int i =0 ; i<[fileList count]; i++)
    {
        [contentArray addObject:[type stringByAppendingPathComponent:[fileList objectAtIndex:i]]];
        
    }
    
    return contentArray;
}




-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        if (IS_HEIGHT_GTE_568) {
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
        }else{
            
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 440) style:UITableViewStyleGrouped];
        }
    }else
    {

        if (IS_HEIGHT_GTE_568) {
            tableViews = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        }else{
        
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
        }
    }
    
    [self.view addSubview:tableViews];
    [tableViews setDelegate:self];
    [tableViews setDataSource:self];
    [tableViews setShowsVerticalScrollIndicator:NO];
    
    [self fetchDays];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}
-(void)viewDidLayoutSubviews
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
    CGRect frame = tableViews.frame;
    frame.size.height = self.view.frame.size.height - 50;
    [tableViews setFrame:frame];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageOnRightCell";
    

    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];

        
        
    }
    [[cell textLabel] setText:NSLocalizedString([[[self.days objectAtIndex:indexPath.row] lastPathComponent] stringByAppendingString:@" per week"], nil)];
    
    switch (indexPath.row) {
        case 0:
        {
            [[cell imageView] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"reminder_2@2x" ofType:@"png"]]];
             break;
        }
        case 1:
        {
            [[cell imageView] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"reminder_3@2x" ofType:@"png"]]];
            break;
        }
        case 2:
        {
            [[cell imageView] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"reminder_4@2x" ofType:@"png"]]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    
    Days *detailViewController = [[Days alloc] initWithDay:[self.days objectAtIndex:indexPath.row]];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)dealloc{
    
    NSLog(@"Deallocating");
    [tableViews setDataSource:nil];
    [tableViews setDelegate:nil];
    [tableViews release];
    [days removeAllObjects];
    [days release];
    
    [super dealloc];
}

@end
