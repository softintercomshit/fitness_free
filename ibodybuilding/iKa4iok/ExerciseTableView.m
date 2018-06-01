//
//  ExerciseTableView.m
//  iKa4iok
//
//  Created by Alexandr Dzerjitchii on 12/10/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "ExerciseTableView.h"
#import "CustomCell.h"
#import "ExercisePreview.h"
#import "NewExercisePreviewer.h"
#define kExerciseName  @"exName"
#define kExerciseThumb  @"exThumb"
#define kContent @"exContent"
@interface ExerciseTableView ()

@property (nonatomic, retain) NSMutableArray *exercisesArray;
@property (nonatomic, retain) NSString *categoryString;
@property (nonatomic, retain) NSString *videoStreamURL;

@end

@implementation ExerciseTableView
@synthesize exercisesArray;

-(id)initWithCategory:(NSString *)category andVideoURL:(NSString *)videoURL{
    
    self = [self init];
    if (self) {
        // Set Note
        self.categoryString = category;
        self.title = NSLocalizedStringFromTable([self.categoryString lastPathComponent], @"content", nil);
        self.videoStreamURL = videoURL;
    }
    return self;
}

-(NSMutableArray *)getExerciseInfoFromPath:(NSString *)path
{
    NSMutableArray *infoArray = [NSMutableArray new];
    NSArray *contentArray = nil;
    NSString *photoString = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for (int i = 0 ; i<fileList.count; i++)
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[fileList objectAtIndex:i] forKey:kExerciseName];
        contentArray = [fileManager contentsOfDirectoryAtPath:[path stringByAppendingPathComponent:[fileList objectAtIndex:i]] error:nil];
        photoString = [path stringByAppendingPathComponent:[fileList objectAtIndex:i]];
        [dict setObject:[photoString stringByAppendingPathComponent:[contentArray objectAtIndex:0]] forKey:kExerciseThumb];
        [infoArray addObject:dict];
        [dict release];
    }
    
    return infoArray;
}

-(NSMutableDictionary *)fetchExerciseContent:(NSString *)pathComponent
{
    
    NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionary];
    
    NSString *descriptString = nil;
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathComponent error:nil];
    NSMutableArray *arrus = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i<fileList.count; i++)
    {
        
        if ([[[fileList objectAtIndex:i] pathExtension] isEqualToString:@"png"])
        {
            
                [arrus addObject:[pathComponent stringByAppendingPathComponent:[fileList objectAtIndex:i]]];
            
        }
        
        if ([[[fileList objectAtIndex:i] pathExtension] isEqualToString:@"txt"])
        {
            descriptString = [NSString stringWithContentsOfFile:[pathComponent stringByAppendingPathComponent:[fileList objectAtIndex:i]] encoding:NSUTF8StringEncoding error:nil];
            
        }
    }
    if ([descriptString length]==0)
    {
        descriptString = @" ";
    }
    [infoDictionary setObject:arrus forKey:@"images"];
    [arrus release];
    [infoDictionary setObject:descriptString forKey:@"description"];
//    [descriptString release];
    
    return infoDictionary;
}

-(void)fetchExercises{
    
    exerciseContentArray = [[NSMutableArray alloc] init];
    exerciseContentArray =[self getExerciseInfoFromPath:self.categoryString];
    [exerciseContentArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *name1=obj1[kExerciseName];
        NSString *name2=obj2[kExerciseName];
        NSString *idx1=nil;
        NSString *idx2=nil;
        @try {
            idx1=[name1 componentsSeparatedByString:@" "][0];
        }@catch (NSException *exception) {}@finally {}
        @try {
            idx2=[name2 componentsSeparatedByString:@" "][0];
        }@catch (NSException *exception) {}@finally {}
        return idx1.intValue>idx2.intValue?NSOrderedDescending:idx1.intValue>idx2.intValue?NSOrderedAscending:NSOrderedSame;
    }];
    [exerciseTable reloadData];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self uploadData:[self.categorys.exercises count]];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (IS_HEIGHT_GTE_568) {
            exerciseTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 500) style:UITableViewStyleGrouped];
        }else{
        
            exerciseTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 410) style:UITableViewStyleGrouped];
        }
    }else {
        exerciseTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        CGRect frame = exerciseTable.frame;
        frame.size.height = self.view.frame.size.height - 50;
        [exerciseTable setFrame:frame];
    }
    
    [self.view addSubview:exerciseTable];
    [exerciseTable setDelegate:self];
    [exerciseTable setDataSource:self];
    [exerciseTable setShowsVerticalScrollIndicator:NO];
    [self fetchExercises];
    
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
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [exerciseContentArray count];
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
    NSString *path;
    NSArray *comps = [[self exerciseImageAtIndex:indexPath.row]pathComponents];
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

    [[cell fxImageView]setImageWithContentsOfFile:path];
    
    [[cell titleLabel] setText:[self getLocalizedStringFromString:[self exerciseFolderNameAtIndex:indexPath.row]]];
    
    
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

- (NSString*) exerciseImageAtIndex:(NSUInteger)index
{
    NSMutableDictionary *exerciseContentDict=nil;
    @try {
        exerciseContentDict=exerciseContentArray[index];
    }@catch (NSException *exception) {}@finally {}
    return exerciseContentDict==nil?nil:exerciseContentDict[kExerciseThumb];
}

- (NSString*) exerciseFolderNameAtIndex:(NSUInteger)index
{
    NSMutableDictionary *exerciseContentDict=nil;
    @try {
        exerciseContentDict=exerciseContentArray[index];
  
    }@catch (NSException *exception) {}@finally {}
    return exerciseContentDict==nil?nil:exerciseContentDict[kExerciseName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NewExercisePreviewer *newexPreview;
    newexPreview = [[NewExercisePreviewer alloc]initWithNibName:@"NewExercisePreviewer"
                                                           image:[self fetchExerciseContent:[self.categoryString stringByAppendingPathComponent:[self exerciseFolderNameAtIndex:indexPath.row]]]
                                                           title:[self exerciseFolderNameAtIndex:indexPath.row]
                                                     isPickingEx:NO];
    

    newexPreview.videoURL = [self.videoStreamURL stringByAppendingPathComponent:[self exerciseFolderNameAtIndex:indexPath.row]];
    // Pass the selected object to the new view controller.
    newexPreview.plistStringPath = self.plistPath;
    newexPreview.isCustom = 1;
    newexPreview.isWithVideo = 1;    [self.navigationController pushViewController:newexPreview animated:YES];
    [newexPreview release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];}
-(void)viewDidUnload{
    [super viewDidUnload];
}


-(void)dealloc{
    NSLog(@"Dealloacting ExerciseTableView");
    [_plistPath  release];
    [_categoryString release];
    [_videoStreamURL release];
    [exerciseContentArray removeAllObjects];
    [exerciseContentArray release];
    [photoArray removeAllObjects];
    [photoArray release];
    [exercisesArray removeAllObjects];
    [exerciseTable release];
    [photoArray removeAllObjects];
    [photoArray release];
    [exercisesArray release];
    [super dealloc];
}

@end
