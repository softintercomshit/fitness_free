//
//  ThirdGuideMaster.m
//  iBodybuilding-Update
//
//  Created by Cibota Olga on 11/7/14.
//  Copyright (c) 2014 com.softintercom. All rights reserved.
//

#import "ThirdGuideMaster.h"
#import "CustomCell.h"
#import "DaysController.h"
#import "CustomProgramCreater.h"
#import "DaysTableViewController.h"
#import "EditViewController.h"
#import "WorkoutCell.h"

@interface ThirdGuideMaster ()
@property (nonatomic, retain)NSMutableArray *customProgramArray;
@end

@implementation ThirdGuideMaster
@synthesize selectedPhotoTracker = _selectedPhotoTracker;
@synthesize mutableIndexSet = _mutableIndexSet;


-(NSArray *)fetchPrograms {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSLog(@"paths: %@", paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"paths: %@", documentsDirectory);
    //    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBodyBuilding"];
    //    NSLog(@"paths: %@", path);
    NSArray * arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSMutableArray *pathsArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < arr.count; i++) {
        NSString *pathLink = [documentsDirectory stringByAppendingPathComponent:[arr objectAtIndex:i]];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:pathLink error:nil];
        if ([[dict objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
            if ([pathLink.lastPathComponent isEqualToString:@"Preferences"]) {
                
            }else if ([pathLink.lastPathComponent isEqualToString:@"Caches"])
            {
                
            }
            else if ([pathLink.lastPathComponent isEqualToString:@"Cookies"])
            {
            }
            
            else if ([pathLink.lastPathComponent isEqualToString:@"__MACOSX"])
            {
                
            }
            else{
                NSLog(@"%@", pathLink.lastPathComponent);
                [pathsArray addObject:pathLink];}
        }
        
    }
    if ([pathsArray count]!=0) {
        self.customExerciseFolder = [pathsArray objectAtIndex:0];
    }
    
    //    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch| NSNumericSearch|NSWidthInsensitiveSearch |NSForcedOrderingSearch;
    //
    //    NSLocale *currentLocale = [NSLocale currentLocale];
    //
    //    NSComparator finderSortBlock = ^(id string1, id string2){
    //
    //        NSRange string1Range = NSMakeRange(0, [string1 length]);
    //
    //        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    //    };
    //
    //    NSArray *finderSortArray = [pathsArray sortedArrayUsingComparator:finderSortBlock];
    
    return pathsArray;
}

-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    
    return fileList;
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
    
    return [self.customProgramArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    WorkoutCell *cell = (WorkoutCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"WorkoutCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"WorkoutCell" owner:self options:nil];
        }
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[WorkoutCell class]]) {
                cell = (WorkoutCell *)oneObject;
                
            }
        if (editButtonChecker == 1)
        {
            [[cell editButton] setHidden:NO];
            [[cell titleLabel]setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, 114, cell.titleLabel.frame.size.height)];
            [[cell editButton]addTarget:self action:@selector(openEditController:event:) forControlEvents:UIControlEventTouchUpInside];
            [[cell editButton]setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        }
        else
            if (editButtonChecker == 0)
            {
                [[cell editButton] setHidden:YES];
                [[cell titleLabel]setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.titleLabel.frame.size.width+70, cell.titleLabel.frame.size.height)];
            }
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [[cell titleLabel]setText:[[self.customProgramArray objectAtIndex:indexPath.row]lastPathComponent]];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *fLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [fLbl setTextAlignment:NSTextAlignmentCenter];
    [fLbl setTextColor:[UIColor lightGrayColor]];
    [fLbl setBackgroundColor:[UIColor clearColor]];
    [fLbl setText: NSLocalizedString(@"To create new workout press +", nil)];
    [fLbl setNumberOfLines:2];
    return fLbl;
    
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) // Don't move the first row
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *stringToMove = [[self.customProgramArray objectAtIndex:sourceIndexPath.row] retain];
    [self.customProgramArray removeObjectAtIndex:sourceIndexPath.row];
    [self.customProgramArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
    [stringToMove release];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSMutableArray *contentArray  = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[[self getDaysFolderList:[self.customProgramArray objectAtIndex:indexPath.row]] count]; i++) {
        
        NSString *folderPath = [self.customProgramArray objectAtIndex:indexPath.row];
        NSString *contentPath = [folderPath stringByAppendingPathComponent:[[self getDaysFolderList:folderPath] objectAtIndex:i]];
        
        [contentArray addObject:contentPath];
        
        
    }
    
    //        DaysTableViewController *daysController = [[DaysTableViewController alloc]initWithNibName:nil bundle:nil withDataArray:contentArray name:[[self.customProgramArray objectAtIndex:indexPath.row] lastPathComponent]];
    //        daysController.hidesBottomBarWhenPushed = YES;
    //        daysController.isPreview = 1;
    //        daysController.isEditing = 0;
    //        [self.navigationController pushViewController:daysController animated:YES];
    //        [daysController release];
    //        [contentArray release];
    
    DaysController *dayControll = [[DaysController alloc]initWithDataArray:contentArray andMane:[[self.customProgramArray objectAtIndex:indexPath.row] lastPathComponent]];
    dayControll.hidesBottomBarWhenPushed = YES;
    dayControll.isEditing = 0;
    
    [self.navigationController pushViewController:dayControll animated:YES];
    [dayControll release];
    [contentArray release];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[self.customProgramArray objectAtIndex:indexPath.row] error:&error];
        [self.customProgramArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if ([self.customProgramArray count]==0) {
            if (self.customExerciseFolder != nil) {
                NSMutableArray *arrayius = [[NSMutableArray alloc] initWithArray:[self getPhotosFolder:self.customExerciseFolder]];
                
                for (int i = 0; i<[arrayius count]; i++) {
                    [[NSFileManager defaultManager] removeItemAtPath:[arrayius objectAtIndex:i] error:&error];
                }
                [arrayius release];
            }
            
            [self.tableView setEditing:NO animated:YES];
            [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
            [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
            [self.navigationItem.leftBarButtonItem setEnabled:NO];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }else{
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
        }
        
    }
}


-(IBAction)openProgramCreator:(id)sender{
    
    CustomProgramCreater *programCreator = [[CustomProgramCreater alloc]init];
    programCreator.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:programCreator animated:YES];
    [programCreator release];
    
}


-(void)openEditController:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    red = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (red != nil)
    {
        rocket = red.row;
        EditViewController *editController = [[EditViewController alloc] initWithWorkoutTitle:[[self.customProgramArray objectAtIndex:rocket] lastPathComponent] andWorkoutPath:[self.customProgramArray objectAtIndex:rocket]];
        editController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editController animated:YES];
        [editController release];
    }
}

-(void)reloadDataInTableView{
    
    [self.tableView reloadData];
    
}

-(IBAction)editCustomPrograms:(id)sender{
    
    if (editButtonChecker == 0) {
        
        editButtonChecker = 1;
        
        
        //[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Done", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.3];
        
        
    }else{
        
        editButtonChecker = 0;
        
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.3];
    }
}


-(void)removeOneItemFromTableView:(NSUInteger)index{
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self.customProgramArray objectAtIndex:index] error:&error];
    [self.customProgramArray removeObjectAtIndex:index];
    
    if ([self.customProgramArray count]==0) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    
}



-(NSArray*)getPhotosFolder:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i =0; i<[fileList count]; i++) {
        NSString *photoPaths = [type stringByAppendingPathComponent:[fileList objectAtIndex:i]];
        [array addObject:photoPaths];
        
    }
    
    return array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editButtonChecker = 0;
    self.selectedPhotoTracker = [[[NSMutableArray alloc]init] autorelease];
    self.customProgramArray = [[[NSMutableArray alloc]init] autorelease];
    self.mutableIndexSet = [[[NSMutableIndexSet alloc]init] autorelease];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openProgramCreator:)];
    [self.navigationItem setRightBarButtonItem:addButton animated:YES];
    [addButton release];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editCustomPrograms:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    [editButton release];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height - 150;
    [self.tableView setFrame:frame];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.customProgramArray removeAllObjects];
    [self.customProgramArray addObjectsFromArray:[self fetchPrograms]];
    for (int i = 0; i<[self.customProgramArray count]; i++) {
        if ([[[self.customProgramArray objectAtIndex:i] lastPathComponent] isEqualToString:@"Camera Feature"]) {
            [self.customProgramArray removeObjectAtIndex:i];
            [self.tableView reloadData];
        }
    }
    
    if ([self.customProgramArray count]==0)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else
    {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    [self.customProgramArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *name1=obj1;
        NSString *name2=obj2;
        NSArray *components1=name1.pathComponents;
        NSArray *components2=name2.pathComponents;
        if (components1.count==components2.count)
        {
            for (NSUInteger i=0; i<components1.count; i++)
            {
                NSString *component1=components1[i];
                NSString *component2=components2[i];
                NSComparisonResult res=NSOrderedSame;
                if (component1.length>component2.length)
                    res=NSOrderedDescending;
                else if (component1.length<component2.length)
                    res=NSOrderedAscending;
                else
                    res=[component1 compare:component2 options:NSCaseInsensitiveSearch];
                if (res!=NSOrderedSame) return res;
            }
        }
        return components1.count>components2.count?NSOrderedDescending:components1.count>components2.count?NSOrderedAscending:NSOrderedSame;
    }];
    
    [self.tableView reloadData];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 100 ,320,50)];
//    CGRect frame = self.tableView.frame;
//    frame.size.height = self.view.frame.size.height - 100;
//    [self.tableView setFrame:frame];
    if ([[AdMobViewController sharedAdMob] connectedToInternet]) {
        [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 100,320,50)];
        
        NSLog(@"Internet connection established");
    }else{
        NSLog(@"No Internet connection established");
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 140,0,0)];
        
        [self.tableView setFrame:self.view.frame];
    }
}

-(void)viewDidLayoutSubviews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [_customProgramArray removeAllObjects];
    [_customProgramArray release];
    [super dealloc];
}

@end
