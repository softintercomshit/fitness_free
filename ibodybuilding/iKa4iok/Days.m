//
//  Days.m
//  iKa4iok
//
//  Created by Johnny Bravo on 12/3/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "Days.h"
#import "ExercisePreview.h"
#import "ShowExercises.h"
#import "CustomCell.h"
#import "NewExercisePreviewer.h"
@interface Days ()
@property (nonatomic, strong)NSMutableArray *days;
@property (nonatomic, strong)NSString *totalDaysCount;
@property (nonatomic, strong)NSString *folderType;
@property (nonatomic, retain)NSString *globalPath;
@end

@implementation Days
@synthesize days;


-(id)initWithDay:(NSString *)day{
    
    self = [super init];
    if (self)
    {
        
        self.folderType = day;

        
    }
    return self;
}

-(void)fetchDays{
    daysDictionaryContent = [[NSMutableDictionary alloc]initWithDictionary:[self extractDaysFoldersWithPath:self.folderType]];
}



-(NSMutableDictionary *)extractDaysFoldersWithPath:(NSString *)pathString
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:pathString error:nil];
    NSMutableDictionary *contentDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i<[fileList count]; i++)
    {
        
        [contentDictionary setObject:[self dayContentInfoWithPath:[pathString stringByAppendingPathComponent:[fileList objectAtIndex:i]]] forKey:[NSString stringWithFormat:@"Day %i",i+1]];
        
    }
    

    
    return contentDictionary;
}


-(NSMutableArray *)dayContentInfoWithPath:(NSString *)pathToFolder
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *folderList = [manager contentsOfDirectoryAtPath:pathToFolder error:nil];
    NSArray *fileList = [NSArray array];
    NSArray *plistFileContent = [NSArray array];
    
    NSMutableArray *contentArray = [NSMutableArray array];
    
    for (int i = 0; i<folderList.count; i++)
    {
        fileList = [manager contentsOfDirectoryAtPath:[pathToFolder stringByAppendingPathComponent:[folderList objectAtIndex:i]] error:nil];
        
        for (int j = 0; j<[fileList count]; j++)
        {
            
            NSMutableDictionary *contentDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[pathToFolder stringByAppendingPathComponent:[folderList objectAtIndex:i]] stringByAppendingPathComponent:[fileList objectAtIndex:j]]];
            
            plistFileContent = [manager contentsOfDirectoryAtPath:[bundlePath stringByAppendingPathComponent:[contentDict objectForKey:@"infopath"]] error:nil];
            
            for (int k = 0; k<[plistFileContent count]; k++)
            {
                if (k == 0)
                {
                    NSMutableDictionary *contentDicts = [[NSMutableDictionary alloc] init];
                    
                    [contentDicts setObject:[[bundlePath stringByAppendingPathComponent:[contentDict objectForKey:@"infopath"]] stringByAppendingPathComponent:[plistFileContent objectAtIndex:k]] forKey:[folderList objectAtIndex:i]];
                    
                    [contentArray addObject:contentDicts];
                    [contentDicts release];
                    
                    break;
                }
            }
        }
    }
    
    [contentArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *name1=[obj1 allKeys][0];
        NSString *name2=[obj2 allKeys][0];
        if ([[name1 class] isSubclassOfClass:[NSString class]] &&
            [[name2 class] isSubclassOfClass:[NSString class]])
        {
            NSArray *components1 = [name1 componentsSeparatedByString:@" "];
            NSArray *components2 = [name2 componentsSeparatedByString:@" "];
            if (components1.count<1 || components2.count<1) return NSOrderedSame;
            NSString *component1=components1[0];
            NSString *component2=components2[0];
            NSInteger int1=component1.integerValue;
            NSInteger int2=component2.integerValue;
            
            return int1>int2?NSOrderedDescending:int1<int2?NSOrderedAscending:NSOrderedSame;
        }
        
        
        return NSOrderedSame;
        
    }];
    

    return contentArray;
}




-(NSMutableDictionary *)extractExerciseContentWithPath:(NSString *)exercisePath
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:exercisePath error:nil];
    NSMutableDictionary *contentDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *images = [NSMutableArray array];
    NSString *finalString = nil;
    
    for (int i = 0; i<[fileList count]; i++)
    {
        finalString = [exercisePath stringByAppendingPathComponent:[fileList objectAtIndex:i]];
        
        if ([[finalString pathExtension] isEqualToString:@"png"])
        {
//            NSRange range = [finalString rangeOfString:@"@2x.png" options:NSCaseInsensitiveSearch];
//            
//            if ( range.location != NSNotFound &&
//                range.location + range.length == [finalString length] )
//            {
//
//            }
//            else
//            {
                [images addObject:finalString];
                [contentDictionary setObject:images forKey:@"images"];
//            }
            
            
        }
        else if([[finalString pathExtension]isEqualToString:@"txt"])
        {
            
            [contentDictionary setObject:[NSString stringWithContentsOfFile:finalString encoding:NSUTF8StringEncoding error:nil] forKey:@"description"];
            
        }
        [contentDictionary setObject:[exercisePath lastPathComponent] forKey:@"title"];
    }
    
    return contentDictionary;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (IS_HEIGHT_GTE_568) {
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
        }else{
        tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 410) style:UITableViewStylePlain];
        }
    }else{
        
        if (IS_HEIGHT_GTE_568) {
            tableViews = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        }else{
            
            tableViews = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain]; //CGRectMake(0, 0, 320, 480)
        }
    }
//    if (IS_HEIGHT_GTE_568) {
//        tableViews = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
//    }else{
//        
//        tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415) style:UITableViewStylePlain];
//    }
    
    [self.view addSubview:tableViews];
    [tableViews setDelegate:self];
    [tableViews setDataSource:self];
    [tableViews setShowsVerticalScrollIndicator:NO];
    
    [self fetchDays];

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
    return [daysDictionaryContent count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSLog(@"*****Day*****");
    NSString *sectionName=[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"Day", nil) , section+1];
    return NSLocalizedString(sectionName, nil);

    return [[daysDictionaryContent allKeys] objectAtIndex:section];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
     NSString *sectionName=[NSString stringWithFormat:@"Day %d", section+1];

    return [[daysDictionaryContent objectForKey:sectionName] count];

    
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
                
                UILabel *detailedLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 30)];
                [detailedLabel setBackgroundColor:[UIColor clearColor]];
                [detailedLabel setTextColor:[UIColor lightGrayColor]];
                [detailedLabel setFont:[UIFont systemFontOfSize:13]];
                [detailedLabel setAdjustsFontSizeToFitWidth:YES];
                [detailedLabel setTextAlignment:NSTextAlignmentLeft];
                if ([[[self.folderType stringByDeletingLastPathComponent] lastPathComponent] isEqualToString:@"Fitness"]) {
                     [detailedLabel setText:NSLocalizedString(@"4 sets and 15 reps", nil)];
                }else if([[[self.folderType stringByDeletingLastPathComponent] lastPathComponent] isEqualToString:@"Bodybuilding"]){
                    
                    [detailedLabel setText:NSLocalizedString(@"4 sets and 12/10/8/6 reps", nil)];
                }else if ([[[self.folderType stringByDeletingLastPathComponent] lastPathComponent]isEqualToString:@"Powerlifting"]){
                    [detailedLabel setText:NSLocalizedString(@"5 sets and 3/3/3/2/1 reps", nil)];
                }
               
                [cell addSubview:detailedLabel];
                [detailedLabel release];
                
            }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }


    
    NSString *sectionName=[NSString stringWithFormat:@"Day %d", indexPath.section+1];
    [[cell fxImageView]setAsynchronous:YES];
    [[cell fxImageView] setImageWithContentsOfFile:[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] objectForKey:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]]];
    [[cell titleLabel] setText:[self getLocalizedStringFromString:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]]];
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
    
    NSString *sectionName=[NSString stringWithFormat:@"Day %d", indexPath.section+1];
    
  
  
    
    


    NewExercisePreviewer *newPreviewer = [[NewExercisePreviewer alloc]initWithNibName:@"NewExercisePreviewer"
                                                                                 image:[self extractExerciseContentWithPath:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] objectForKey:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]] stringByDeletingLastPathComponent]]
                                                                                 title:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]
                                                                           isPickingEx:NO];
    newPreviewer.isWorkout = YES;
     newPreviewer.videoURL = [self extractVideoStreamURLFromPath:[[[self extractExerciseContentWithPath:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] objectForKey:[[[[daysDictionaryContent objectForKey:sectionName] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]] stringByDeletingLastPathComponent]] objectForKey:@"images"] objectAtIndex:0]];
    newPreviewer.day = indexPath.section;
    [newPreviewer setContentDict:daysDictionaryContent];
    newPreviewer.folderPaf = self.folderType;
    [self.navigationController pushViewController:newPreviewer animated:YES];
    [newPreviewer release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dealloc{
    NSLog(@"deallocating...");
    
    [days removeAllObjects];
    [days release];
    
    [sectionData removeAllObjects];
    [sectionData release];
    
    [imageSectionData removeAllObjects];
    [imageSectionData release];
    
    [tableViews setDataSource:nil];
    [tableViews setDelegate:nil];
    [tableViews release];
    
    [daysDictionaryContent removeAllObjects];
    [daysDictionaryContent release];
    
    [_folderType release];
    [_globalPath release];
    [super dealloc];
}

@end
