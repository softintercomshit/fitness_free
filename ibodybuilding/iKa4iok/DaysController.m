//
//  DaysController.m
//  iBodybuilding-Update
//
//  Created by Cibota Olga on 11/7/14.
//  Copyright (c) 2014 com.softintercom. All rights reserved.
//

#import "DaysController.h"
#import "CategoryClass.h"
#import "NewExercisePreviewer.h"
#import "BBCustomExercise.h"
#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>
@interface DaysController ()

@end

@implementation DaysController

-(id)initWithDataArray:(NSArray *)dataArray andMane:(NSString *)eTitle{
    
    
    self = [super init];
    if (self) {
        self.title = [NSString stringWithString:eTitle];
        NSArray *sortedArray = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([[obj1 substringFromIndex:[obj1 length]-2] integerValue] > [[obj2 substringFromIndex:[obj1 length]-2] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[obj1 substringFromIndex:[obj1 length]-2] integerValue] < [[obj2 substringFromIndex:[obj1 length]-2] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        workArray = [[NSMutableArray alloc]initWithArray:sortedArray];
        
        self.contentDictionary = [[NSMutableDictionary alloc]init];
        
        
        
    }
    return self;
}



-(void)extractContentForTableViewFromArray:(NSMutableArray *)contentArray{
    
    
    for (int i =0; i<[contentArray count]; i++) {
        
        if ([[self getDaysFolderList:[contentArray objectAtIndex:i]] count]!=0)
        {
            NSString *plistPathString = [[contentArray objectAtIndex:i] stringByAppendingPathComponent:[[self getDaysFolderList:[contentArray objectAtIndex:i]] objectAtIndex:0]];
            
            NSMutableArray *arraywithfuckingShit = [[NSMutableArray alloc]initWithContentsOfFile:plistPathString];
            
            [self.contentDictionary setObject:arraywithfuckingShit forKey:[NSString stringWithFormat:@"%d",i]];
            [arraywithfuckingShit release];
            
        }else{
            
            
        }
    }
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO animated:NO];
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Did appear");
    [super viewDidAppear:animated];
    
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height - 50;
    [self.tableView setFrame:frame];
    [self.tableView setNeedsDisplayInRect:frame];
    NSLog(@"Frame: %@\n\n", NSStringFromCGSize(self.tableView.frame.size));
}
- (void)viewDidLayoutSubviews
{
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (int i =0; i<[workArray count]; i++) {
        
        
    }
    [self extractContentForTableViewFromArray:workArray];
    [self.tableView setEditing:NO animated:NO];
    
    checkEditStatus = 0;
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}


-(void)getBackToRootViewController {
    if (self.isCustom == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height - 50;
    [self.tableView setFrame:frame];
    [self.tableView setNeedsDisplay];
    if (self.isEditing != 1) {
        
        
    }else{
        
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
        self.navigationItem.rightBarButtonItem = editButton;
        [editButton release];
    }
    
    UIBarButtonItem *backToRoot = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(getBackToRootViewController)];
    self.navigationItem.leftBarButtonItem = backToRoot;
    [backToRoot release];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)reloadDataInTableView{
    
    [self.tableView reloadData];
    
}

-(void)editButtonPressed{
    
    if (checkEditStatus==0)
    {
        
        
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Done", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.2];
        checkEditStatus = 1;
        
    }else{
        
        
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
        [self performSelector:@selector(reloadDataInTableView) withObject:nil afterDelay:0.2];
        checkEditStatus = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [workArray count];
}

-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    
    return fileList;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 44;
    }else{
        return 44;
    }
    return 20;
}



-(void)creatCustomExerciseWithTag:(int)tagus{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    //     NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBodyBuilding"];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Camera Feature"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }else{
        
        
    }
    
    NSString *checkString = [[workArray objectAtIndex:tagus] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[workArray objectAtIndex:tagus] lastPathComponent]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:checkString]){
        
        NSString *plistPathString = [[workArray objectAtIndex:tagus] stringByAppendingPathComponent:[[self getDaysFolderList:[workArray objectAtIndex:tagus]] objectAtIndex:0]];
        BBCustomExercise *controllerCamera = [[BBCustomExercise alloc]init];
        controllerCamera.folderPath = dataPath;
        controllerCamera.plistString = plistPathString;
        [self.navigationController pushViewController:controllerCamera animated:YES];
        [controllerCamera release];
        
    }else{
        
        NSString * plistPath = [[workArray objectAtIndex:tagus] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[workArray objectAtIndex:tagus] lastPathComponent]]];
        BBCustomExercise *controllerCamera = [[BBCustomExercise alloc]init];
        controllerCamera.folderPath = dataPath;
        controllerCamera.plistString = plistPath;
        [self.navigationController pushViewController:controllerCamera animated:YES];
        [controllerCamera release];
    }
    
}


-(void)getButtonTag:(int)tags
{
    
    
    
    NSString *checkString = [[workArray objectAtIndex:tags] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[workArray objectAtIndex:tags] lastPathComponent]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:checkString]){
        
        NSString *plistPathString = [[workArray objectAtIndex:tags] stringByAppendingPathComponent:[[self getDaysFolderList:[workArray objectAtIndex:tags]] objectAtIndex:0]];
        CategoryClass *catClass = [[CategoryClass alloc]initWithNibName:nil bundle:nil];
        catClass.plistPath = plistPathString;
        [self.navigationController pushViewController:catClass animated:YES];
        //        [plistPathString release];
        [catClass release];
        
    }else{
        
        NSString * plistPath = [[workArray objectAtIndex:tags] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[workArray objectAtIndex:tags] lastPathComponent]]];
        CategoryClass *catClass = [[CategoryClass alloc]initWithNibName:nil bundle:nil];
        catClass.plistPath = plistPath;
        
        [self.navigationController pushViewController:catClass animated:YES];
        //        [plistPath release];
        [catClass release];
    }
    
}


-(IBAction)addNewExerciseButton:(id)sender{
    
    ButtonSenderTag = ((UIButton*)sender).tag;
    
    UIActionSheet *actionSh = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Options:", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Exercises", nil),NSLocalizedString(@"Camera/Gallery", nil), nil];
    actionSh.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSh showInView:self.view];
    [actionSh release];
    
    
    //
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            [self getButtonTag:ButtonSenderTag];
            break;
        }
        case 1:
        {
            
            [self creatCustomExerciseWithTag:ButtonSenderTag];
            break;
        }
            
        default:
            break;
    }
    
}



-(UIView*)setToolBarForSection:(NSInteger)sections andToolBarTitle:(NSString *)titleName{
    
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    NSString *newString = [[titleName componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"panou" ofType:@"png"]]]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.layer.shadowOpacity = 1.0;
        titleLabel.layer.shadowRadius = 0.0;
        titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        titleLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    else{
        [contentView setBackgroundColor:[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    //[titleLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    //[titleLabel.layer setShadowOffset:CGSizeMake(0, 3)];
    [titleLabel setText:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(newString, nil), sections+1]];
    [contentView addSubview:titleLabel];
    [titleLabel release];
    
    
    
    
    if (self.isEditing != 1)
    {
        
        
    }else
    {
        UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 8, 34, 30)];
        //        [actionButton setFrame:];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [actionButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add_inactive" ofType:@"png"]] forState:UIControlStateNormal];
            [actionButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add_active" ofType:@"png"]] forState:UIControlStateHighlighted];
        }else{
            [actionButton setTitle:@"+" forState:UIControlStateNormal];
            [actionButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
            [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        }
        
        [actionButton addTarget:self action:@selector(addNewExerciseButton:) forControlEvents:UIControlEventTouchUpInside];
        actionButton.tag = sections;
        [contentView addSubview:actionButton];
        if (checkEditStatus == 0)
        {
            [actionButton setEnabled:NO];
        }else
        {
            [actionButton setEnabled:YES];
        }
        
        
        [actionButton release];
        
    }
    
    
    return contentView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return  [[self setToolBarForSection:section andToolBarTitle:[[workArray objectAtIndex:section] lastPathComponent]] autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    
    return [[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",section]] count];
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
                
                repsLabel = [[[UILabel alloc]initWithFrame:CGRectMake(90, 50, 200, 30)] autorelease];
                [repsLabel setBackgroundColor:[UIColor clearColor]];
                [repsLabel setTextColor:[UIColor lightGrayColor]];
                [repsLabel setFont:[UIFont systemFontOfSize:13]];
                [repsLabel setTextAlignment:NSTextAlignmentLeft];
                
                [cell addSubview:repsLabel];
                
                if (checkEditStatus == 1) {
                    [repsLabel setFrame:CGRectMake(125, 50, 200, 30)];
                }
                
                
                if ([[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"customized"] isEqualToNumber:[NSNumber numberWithInt:1]])
                {
                    if (checkEditStatus == 1)
                    {
                        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(185, 23, 60, 33)];
                        [editButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_cell_passive@2x" ofType:@"png"]] forState:UIControlStateNormal];
                        [editButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
                        [editButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_cell_active@2x" ofType:@"png"]] forState:UIControlStateHighlighted];
                        [editButton addTarget:self action:@selector(openEditController:event:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:editButton];
                        [editButton release];
                        
                    }else{
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if ([[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"customized"]==nil)
    {
        [[cell titleLabel] setText:[self getLocalizedStringFromString:[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"title"]]];
    }else
    {
        [[cell titleLabel] setText:[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"title"]];
    }
    
    
    if ([[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"images"] count]!=0) {
        [[cell fxImageView] setAsynchronous:YES];
        
        NSString *path;
        NSArray *comps = [[[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"images"] objectAtIndex:0]pathComponents];
        if ([comps containsObject:@"Library"]) {
            path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //                path = [path stringByDeletingLastPathComponent];
            //                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
            path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-2]];
            path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-1]];
        }else{
            path = [[NSBundle mainBundle] resourcePath];
            path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-4]];
            path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
            path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-2]];
            path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-1]];
        }
        
        [[cell fxImageView] setImageWithContentsOfFile:path];
    }
    
    [repsLabel setText:[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"reps"]];
    NSLog(@"Frame : %@", NSStringFromCGSize(self.tableView.frame.size));
    return cell;
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
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    // Result.
    int number = [numberString integerValue];
    
    localizedString = NSLocalizedStringFromTable([string substringFromIndex:[numberString length]+1], @"content", nil);
    
    // Intermediate
    
    
    
    localizedString = [[NSString stringWithFormat:@"%i ",number] stringByAppendingString:localizedString];
    
    return localizedString;
}


-(void)openEditController:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    red = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (red != nil)
    {
        rocket = red.row;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        //         NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBodyBuilding"];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Camera Feature"];
        
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
            
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
            
        }else{
            
            
        }
        
        NSString *checkString = [[workArray objectAtIndex:red.section] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[workArray objectAtIndex:red.section] lastPathComponent]]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:checkString]){
            
            
            BBCustomExercise *editController = [[BBCustomExercise alloc] initWithNibName:@"BBCustomExercise" bundle:nil];
            editController.exerciseDescription = [[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"description"];
            editController.exerciseRepetitions =[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"reps"];
            editController.exerciseTitle = [[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"title"];
            editController.photoArray = [NSMutableArray arrayWithArray:[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"images"]];
            editController.isEditing = 1;
            editController.getObjectIndex = red.row;
            
            NSString *plistPathString = [[workArray objectAtIndex:red.section] stringByAppendingPathComponent:[[self getDaysFolderList:[workArray objectAtIndex:red.section]] objectAtIndex:0]];
            editController.folderPath = dataPath;
            NSLog(@"Folderpath: %@", dataPath);
            editController.plistString = plistPathString;
            [self.navigationController pushViewController:editController animated:YES];
            [editController release];
            [dataPath release];
            
            
        }else{
            
            BBCustomExercise *editController = [[BBCustomExercise alloc] initWithNibName:@"BBCustomExercise" bundle:nil];
            editController.exerciseDescription = [[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"description"];
            editController.exerciseRepetitions =[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"reps"];
            editController.exerciseTitle = [[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"title"];
            editController.photoArray = [NSMutableArray arrayWithArray:[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",red.section]] objectAtIndex:red.row] objectForKey:@"images"]];
            editController.isEditing = 1;
            editController.getObjectIndex = red.row;
            
            NSString * plistPath = [[workArray objectAtIndex:red.section] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[workArray objectAtIndex:red.section] lastPathComponent]]];
            editController.folderPath = dataPath;
            editController.plistString = plistPath;
            [self.navigationController pushViewController:editController animated:YES];
            [editController release];
            [dataPath release];
        }
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == 0) // Don't move the first row
    //        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    
    NSString *plistPathString = [[workArray objectAtIndex:sourceIndexPath.section] stringByAppendingPathComponent:[[self getDaysFolderList:[workArray objectAtIndex:sourceIndexPath.section]] objectAtIndex:0]];
    NSString *plistPathString2;
    if ([[self getDaysFolderList:[workArray objectAtIndex:destinationIndexPath.section]] count] == 0) {
        plistPathString2 = [[workArray objectAtIndex:destinationIndexPath.section] stringByAppendingPathComponent:[NSString stringWithFormat:@"Day %d", destinationIndexPath.section]];
    }else{
        plistPathString2 = [[workArray objectAtIndex:destinationIndexPath.section] stringByAppendingPathComponent:[[self getDaysFolderList:[workArray objectAtIndex:destinationIndexPath.section]] objectAtIndex:0]];
    }
    
    NSMutableArray *stringToMovesuka = [[NSMutableArray alloc] initWithContentsOfFile:plistPathString] ;
    NSString *stringToMove = [[stringToMovesuka objectAtIndex:sourceIndexPath.row] retain];
    
    NSLog(@"Array: %@", [self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]]);
    [[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",sourceIndexPath.section]] removeObjectAtIndex:sourceIndexPath.row];
    if ([self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]] != nil) {
        [[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]] insertObject:stringToMove atIndex:destinationIndexPath.row];
    }else{
        NSLog(@"Nil array");
        [self.contentDictionary setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]];
        [[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]] addObject:stringToMove];
    }
    
    NSLog(@"***********\n %@", [self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]]);
    NSLog(@"Source: %d", sourceIndexPath.section);
    NSLog(@"Destination: %d", destinationIndexPath.section);
    [(NSMutableArray *)[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",sourceIndexPath.section]] writeToFile:plistPathString atomically:YES];
    [(NSMutableArray *)[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",destinationIndexPath.section]] writeToFile:plistPathString2 atomically:YES];
    
    [stringToMovesuka release];
    [stringToMove release];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *plistPathString = [[workArray objectAtIndex:indexPath.section] stringByAppendingPathComponent:[[self getDaysFolderList:[workArray objectAtIndex:indexPath.section]] objectAtIndex:0]];
        [[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [(NSMutableArray *)[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] writeToFile:plistPathString atomically:YES];
        
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


-(NSString *)extractVideoStreamURLFromPath:(NSString *)contentPath
{
    NSString *videoURLString = nil;
    NSString *tempString = nil;
    NSString *firstPart = nil;
    NSString *secondPart = nil;
    
    tempString = [contentPath stringByDeletingLastPathComponent];
    secondPart = [tempString lastPathComponent];
    tempString = [tempString stringByDeletingLastPathComponent];
    firstPart = [tempString lastPathComponent];
    
    videoURLString = [firstPart stringByAppendingPathComponent:secondPart];
    
    return videoURLString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"images: %@", [[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row]);
    
    NewExercisePreviewer *exPreview = [[NewExercisePreviewer alloc]initWithNibName:@"NewExercisePreviewer" image:[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] title:[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"title"] isPickingEx:self.isEditing];
    if ([[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"customized"]==nil)
    {
        exPreview.videoURL = [self extractVideoStreamURLFromPath:[[[[self.contentDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"images"] objectAtIndex:0]];
        exPreview.isCustom = 0;
        
    }
    else
    {
        exPreview.isCustom = 1;
    }
    exPreview.day = indexPath.section;
    exPreview.isWorkout = 1;
    [exPreview setContentDict:self.contentDictionary];
    
    [exPreview setWorkout:self.title];
    
    [self.navigationController pushViewController:exPreview animated:YES];
    [exPreview release];
    
    
    
}

-(void)dealloc{
    NSLog(@"deallocating daqys controller");
    [workArray removeAllObjects];
    [workArray release];
    [_contentDictionary removeAllObjects];
    [_contentDictionary release];
    [_tableView release];
    [super dealloc];
}

@end
