//
//  CategoryClass.m
//  iKa4iok
//
//  Created by Johnny Bravo on 12/7/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "CategoryClass.h"

#import "ExerciseTableView.h"
#import "CustomCell.h"

@interface CategoryClass ()
@property(nonatomic ,retain)NSMutableArray *categoryArray;
@end

@implementation CategoryClass


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}

- (void)fetchCategorys {
    // Fetch Notes
    _categoryArray = [[NSMutableArray arrayWithArray:[self getCategoryFolderList]] retain];
    
}

-(NSArray*)getCategoryFolderList{
    
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [bundlePath stringByAppendingString:@"/Default"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i =0 ; i<fileList.count; i++)
    {
        [resultArray addObject:[path stringByAppendingPathComponent:[fileList objectAtIndex:i]]];
    }
    
    return resultArray;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    if (IS_HEIGHT_GTE_568) {
        categoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 500) style:UITableViewStyleGrouped];
    }else{
        
        categoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 410) style:UITableViewStyleGrouped];
    }
    }else        
    {
        categoryTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    
    [self.view addSubview:categoryTable];
    [categoryTable setDelegate:self];
    [categoryTable setDataSource:self];
    [categoryTable setShowsVerticalScrollIndicator:NO];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
    CGRect frame = categoryTable.frame;
    frame.size.height = self.view.frame.size.height - 50;
    [categoryTable setFrame:frame];
    
    [self fetchCategorys];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return [self.categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ExerciseTableView *exerciseTable = [[ExerciseTableView alloc] initWithCategory:[self.categoryArray objectAtIndex:indexPath.row] andVideoURL:[[self.categoryArray objectAtIndex:indexPath.row] lastPathComponent]];
    exerciseTable.plistPath = self.plistPath;
    [self.navigationController pushViewController:exerciseTable animated:YES];
    [exerciseTable release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)dealloc
{
    NSLog(@"deallocating catClass");
    [_categoryArray removeAllObjects];
    [_categoryArray release];
    [_plistPath release];
    [categoryTable release];
    [super dealloc];
}

@end
