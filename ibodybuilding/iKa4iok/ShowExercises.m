//
//  ShowExercises.m
//  iKa4iok
//
//  Created by Johnny Bravo on 12/7/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "ShowExercises.h"
#import "ScrollPreviewController.h"
@interface ShowExercises ()

@end

@implementation ShowExercises
@synthesize globalPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSArray*)getPickedDaysFolderList:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:path error:nil];
    
    return fileList;
}

-(NSDictionary*)getAllPhotos:(NSString*)pathComponent{
    
    NSString *setString = localString;
    NSString *path = [setString stringByAppendingString:[NSString stringWithFormat:@"/%@",pathComponent]];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSMutableArray *imagelist = [NSMutableArray array];
    NSMutableDictionary *exercisesData = [NSMutableDictionary dictionary];
    NSString* content;
    [exercisesData setObject:[path lastPathComponent] forKey:@"title"];
    
    for (int j =0; j<[manager contentsOfDirectoryAtPath:path error:nil].count ; j++) {
        
        NSString *longPath = [path stringByAppendingPathComponent:[[manager contentsOfDirectoryAtPath:path error:nil] objectAtIndex:j]];
        if ([[longPath pathExtension]isEqualToString:@"png"]) {
            [imagelist addObject:longPath];
        }else if([[longPath pathExtension]isEqualToString:@"txt"]){
            
            content = [NSString stringWithContentsOfFile:longPath
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
            
            [exercisesData setObject:content forKey:@"description"];

        }else{
            
            [exercisesData setObject:[NSString stringWithFormat:@"No description for current exercise!"] forKey:@"description"];
        }
    }
    
    [exercisesData setObject:imagelist forKey:@"images"];
    
    
    
    return exercisesData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    localString = [self.globalPath copy];
    dataArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i<[[self getPickedDaysFolderList:localString] count]; i++) {
        
        [dataArray addObject:[self getAllPhotos:[[self getPickedDaysFolderList:localString] objectAtIndex:i]]];
    }
    
    
    self.pageCount.text = [[dataArray objectAtIndex:0] objectForKey:@"title"];
    //[self creatScrollViewContent:dataArray];
    
    [self sendContenttoScroller:dataArray];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}
-(void)getPhotoFromArray:(NSMutableArray*)photoArray{
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:photoArray];
    
    for (int i = 0; i < array.count; i++) {
        CGRect frame;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[array objectAtIndex:i]]] ;
        imageView.tag = i;
        
        if (imageView.image.size.width==320) {
            frame.origin.x = self.contentScrollView.frame.size.width * i;
            frame.origin.y = 70;
        }else if(imageView.image.size.width==200){
            frame.origin.x = self.contentScrollView.frame.size.width * i+60;
            frame.origin.y = 40;
        }
        
		
		frame.size = CGSizeMake(imageView.image.size.width, imageView.image.size.height);
        [imageView setFrame:frame];
        
        
		[self.contentScrollView addSubview:imageView];
        
        [imageView release];
	}
	
	self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height * array.count);
}

-(void)sendContenttoScroller:(NSMutableArray *)array{
    
    for (int i = 0; i<[array count]; i++) {
        
        CGRect scrollsRect;
        ScrollPreviewController *controller = [[[ScrollPreviewController alloc]initWithNibName:@"ScrollPreviewController" andRequiredData:[[array objectAtIndex:i] objectForKey:@"images"] andDescription:[[array objectAtIndex:i]objectForKey:@"description"]] autorelease];
        
        scrollsRect.origin.x = 0;
        scrollsRect.origin.y = self.contentScrollView.frame.size.height * i;
        scrollsRect.size = CGSizeMake(320, 440);
        
        [controller.view setFrame:scrollsRect];
        [self.contentScrollView addSubview:controller.view];
    
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height * array.count);
}



-(void)creatScrollViewContent:(NSMutableArray*)array{

    for (int i = 0; i<[array count]; i++) {
        CGRect scrollFrame,textFrame;
        UIScrollView * scroll = [[UIScrollView alloc]init];
        [scroll setPagingEnabled:YES];
        [scroll setShowsHorizontalScrollIndicator:NO];
        [scroll setBounces:NO];
        
        UITextView * textView = [[UITextView alloc]init];
        [textView setText: [[array objectAtIndex:i] objectForKey:@"description"]];
        [textView setBackgroundColor:[UIColor darkGrayColor]];
        [textView setEditable:NO];   
        scrollFrame.origin.x = 0;
        scrollFrame.origin.y = self.contentScrollView.frame.size.height * i;
        scrollFrame.size = CGSizeMake(320, 340);

        [scroll setFrame:scrollFrame];
        
        NSMutableArray * photoArray = [NSMutableArray arrayWithArray:[[array objectAtIndex:i] objectForKey:@"images"]];

        for (int j =0; j<[photoArray count]; j++) {
            CGRect imageViewRect;
            UIImageView *images =[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[photoArray objectAtIndex:j]]];
            
            if (images.image.size.width==320) {
                imageViewRect.origin.x = scroll.frame.size.width * j;
                imageViewRect.origin.y = 70;
            }else if(images.image.size.width==200){
                imageViewRect.origin.x = scroll.frame.size.width * j+60;
                imageViewRect.origin.y = 20;
            }
            
            imageViewRect.size = CGSizeMake(images.image.size.width, images.image.size.height);
            [images setFrame:imageViewRect];
            
            [scroll addSubview:images];

            [images release];
        }
        scroll.contentSize = CGSizeMake(scroll.frame.size.width *[photoArray count], scroll.frame.size.height);

        textFrame.origin.x = 0;
        textFrame.origin.y = (self.contentScrollView.frame.size.height * i)+340;
        textFrame.size = CGSizeMake(320, 100);
        [textView setFrame:textFrame];

        
        [self.contentScrollView addSubview:scroll];
        [self.contentScrollView addSubview:textView];
        
                

        
        [textView release];
        [scroll release];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height * array.count);

}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageHeight = self.contentScrollView.frame.size.height;
		int page = floor((self.contentScrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    
    NSString *pageTitle = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:page] objectForKey:@"title"]];
    CGSize maximumSize = CGSizeMake(INT_MAX, 44); // CGSizeMake(width,height).
    CGSize expectedLabelSize = [pageTitle sizeWithFont:self.pageCount.font
                                     constrainedToSize:maximumSize
                                         lineBreakMode:self.pageCount.lineBreakMode];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        //adjust the label the the new height.
        CGRect newFrame = self.pageCount.frame;
        newFrame.size.width = expectedLabelSize.width;
        self.pageCount.frame = newFrame;
        self.pageCount.text = nil;
		self.pageCount.text = pageTitle;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contentScrollView release];
    [_pageCount release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setContentScrollView:nil];
    [self setPageCount:nil];
    [super viewDidUnload];
}
@end
