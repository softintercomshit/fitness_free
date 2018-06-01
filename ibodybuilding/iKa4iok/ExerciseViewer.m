//
//  ExerciseViewer.m
//  iKa4iok
//
//  Created by Johnny Bravo on 11/13/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "ExerciseViewer.h"

#import "NewExercisePreviewer.h"
#import "ExercisePreview.h"

#define kExerciseName  @"exName"
#define kExerciseThumb  @"exThumb"
#define kContent @"exContent"

@interface ExerciseViewer ()

@property (nonatomic, retain) NSMutableArray *exercisesArray;
@property (nonatomic, retain) NSString *categoryString;
@property (nonatomic, retain) NSString *videoStreamURL;
@end

@implementation ExerciseViewer
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

-(BOOL)shouldAutorotate
{
    
    return NO;
}

-(NSMutableArray *)getExerciseInfoFromPath:(NSString *)path
{
    
    NSMutableArray *infoArray = [NSMutableArray array];
    NSArray *contentArray;
    NSString *photoString = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList =[fileManager contentsOfDirectoryAtPath:path error:nil] ;
    
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

//    fileList = nil;
   
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
//            NSRange range = [[pathComponent stringByAppendingPathComponent:[fileList objectAtIndex:i]] rangeOfString:@"@2x.png" options:NSCaseInsensitiveSearch];
//            
//            if ( range.location != NSNotFound &&
//                range.location + range.length == [[pathComponent stringByAppendingPathComponent:[fileList objectAtIndex:i]] length] )
//            {
//            }
//            else
//            {
                [arrus addObject:[pathComponent stringByAppendingPathComponent:[fileList objectAtIndex:i]]];
//            }
            
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


- (void) sortArray:(NSMutableArray*)array comparitionKeyIfDictionary:(NSString*)comparitionKey
{
	if (comparitionKey)
	{
		if ([[comparitionKey class] isSubclassOfClass:[NSString class]]==NO) comparitionKey=nil;
	}
	if (array)
	{
		[array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			NSString *name1=obj1;
			NSString *name2=obj2;
			if ([[name1 class] isSubclassOfClass:[NSDictionary class]] &&
				[[name2 class] isSubclassOfClass:[NSDictionary class]] &&
				comparitionKey)
			{
				name1=obj1[comparitionKey];
				name2=obj2[comparitionKey];
			}
			if ([[name1 class] isSubclassOfClass:[NSString class]]==NO) return NSOrderedSame;
			if ([[name2 class] isSubclassOfClass:[NSString class]]==NO) return NSOrderedSame;
			
			return [name2 compare:name1];
	
		}];
	}
}

-(void)fetchExercises{
    
    exerciseContentArray = [[NSMutableArray arrayWithArray:[self getExerciseInfoFromPath:self.categoryString]] retain];
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
    [tableViews reloadData];
    

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self uploadData:[self.categorys.exercises count]];
   
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            if (IS_HEIGHT_GTE_568) {
                
                tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0
                                                                          , 320, 480) style:UITableViewStyleGrouped];
            }else{
            tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0
                                                                      , 320, 440) style:UITableViewStyleGrouped];
            }
        }else{
            if (IS_HEIGHT_GTE_568) {
                
//                tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0
//                                                                          , 320, 570) style:UITableViewStyleGrouped];
                tableViews = [[UITableView alloc]initWithFrame:self.view.frame];
            }else{
//        tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, 0
//                                                                  , 320, 480) style:UITableViewStyleGrouped];
                 tableViews = [[UITableView alloc]initWithFrame:self.view.frame];
            }
        }
    
   
    [self.view addSubview:tableViews];
    [tableViews setDelegate:self];
    [tableViews setDataSource:self];
    [tableViews setShowsVerticalScrollIndicator:NO];

   [self fetchExercises];
    
}


-(void)viewDidAppear:(BOOL)animated
{
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
    [[cell fxImageView]setImageWithContentsOfFile:[self exerciseImageAtIndex:indexPath.row]];
    
    [[cell titleLabel] setText:[self getLocalizedStringFromString:[self exerciseFolderNameAtIndex:indexPath.row]]];
    
    
//    [photo setImage:image];

    
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
    NSString *pathStr = [self.videoStreamURL stringByAppendingPathComponent:[self exerciseFolderNameAtIndex:indexPath.row]];
    newexPreview.videoURL = pathStr;
//    [pathStr release];
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:newexPreview animated:YES];
    [newexPreview release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}



- (void) viewWillDisappear:(BOOL)animated {
    

}

-(void)viewDidUnload{
    tableViews = nil;
    
    [super viewDidUnload];
}


-(void)dealloc{
    [tableViews setDelegate:nil];
    [tableViews setDataSource:nil];
    [tableViews release];
    [exerciseContentArray removeAllObjects];
    [exerciseContentArray release];
    [exercisesArray removeAllObjects];
    [photoArray removeAllObjects];
    [photoArray release];
    [_categoryString release];
    [_videoStreamURL release];
    [exercisesArray release];
    [super dealloc];
}
@end
