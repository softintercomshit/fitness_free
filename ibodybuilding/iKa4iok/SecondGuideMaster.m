//
//  SecondGuideMaster.m
//  iKa4iok
//
//  Created by Johnny Bravo on 11/12/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "SecondGuideMaster.h"
#import "CustomCell.h"
#import "PickDays.h"


@interface SecondGuideMaster ()
@property (nonatomic,strong)NSMutableArray *typeArray;

@end

@implementation SecondGuideMaster

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(SECOND_TITLE, nil);
    }
    return self;
}

-(NSArray*)getTypeFolderList
{
    
    
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [bundlePath stringByAppendingString:@"/GuidePrograms"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *finalList = [NSMutableArray array];
    
    for (int i = 0; i<fileList.count; i++)
    {
        [finalList addObject:[path stringByAppendingPathComponent:[fileList objectAtIndex:i]]];
        
    }
    
    
    return finalList;
}


-(void)fetchTypes{
    
    self.typeArray = [NSMutableArray arrayWithArray:[self getTypeFolderList]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (IS_HEIGHT_GTE_568)
        {
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
        }else{
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 370) style:UITableViewStyleGrouped];
        }
    }else{
        if (IS_HEIGHT_GTE_568)
        {
                     self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 468) style:UITableViewStyleGrouped];
//            self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        }else{
                    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 390) style:UITableViewStyleGrouped];
//            self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        }
    }



    [self fetchTypes];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
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
#pragma mark - #---TableView delegate---#

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.typeArray count];
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

    switch (indexPath.row) {
        case 0:
        {
            [[cell fxImageView]setAsynchronous:YES];
            [[cell fxImageView]setImageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bodybuilding" ofType:@"png"]];
           break; 
        }
        case 1:
        {
            [[cell fxImageView]setAsynchronous:YES];
            [[cell fxImageView]setImageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"fitness" ofType:@"png"]];
            break;
        }
        case 2:
        {
            [[cell fxImageView]setAsynchronous:YES];
            [[cell fxImageView]setImageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"powerlifting" ofType:@"png"]];
            break;
        }
            
        default:
            break;
    }
    
     [[cell titleLabel] setText:NSLocalizedString([[self.typeArray objectAtIndex:indexPath.row] lastPathComponent], nil)];
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PickDays *daysPicked = [[PickDays alloc]initWithType:[self.typeArray objectAtIndex:indexPath.row] ];
    daysPicked.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:daysPicked animated:YES];
    [daysPicked release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - #---Relese Methods---#

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}@end