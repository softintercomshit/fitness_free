//
//  ExercisePreview.m
//  iKa4iok
//
//  Created by Johnny Bravo on 11/13/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "ExercisePreview.h"


#import "GuideAppDelegate.h"

#import "Constant.h"

@interface ExercisePreview ()

@end

@implementation ExercisePreview
@synthesize scrollView,pageControl;



-(id)initWithNibName:(NSString *)nibNameOrNil image:(NSMutableDictionary*)data title:(NSString*)title isPickingEx:(BOOL)isPicking{
    
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {

        self.info = [data objectForKey:@"description"];
        isPickingExercise = isPicking;
        picArray = [[NSMutableArray alloc]initWithArray:[data objectForKey:@"images"]];
        self.titleString = title;
        
    }
    return self;
    
}

-(void)getPhotoFromArray:(NSMutableArray*)photoArray{
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:photoArray];
    
    for (int i = 0; i < array.count; i++) {
        CGRect frame;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[array objectAtIndex:i]]] ;
        imageView.tag = i;
        if (IS_HEIGHT_GTE_568)
        {
            if (imageView.image.size.width==320)
            {
                frame.origin.x = self.scrollView.frame.size.width * i;
                frame.origin.y = 50;
            }else if(imageView.image.size.width==200)
            {
                frame.origin.x = self.scrollView.frame.size.width * i+60;
                frame.origin.y = 20;
            }
        }else
        {
            if (imageView.image.size.width==320)
            {
                frame.origin.x = self.scrollView.frame.size.width * i;
                frame.origin.y = 70;
            }else if(imageView.image.size.width==200)
            {
                frame.origin.x = self.scrollView.frame.size.width * i+60;
                frame.origin.y = 40;
            }
        }
        
		frame.size = CGSizeMake(imageView.image.size.width, imageView.image.size.height);
        [imageView setFrame:frame];
		[self.scrollView addSubview:imageView];
        
        [imageView release];
	}
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * array.count, self.scrollView.frame.size.height);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = array.count;

    
}
 


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageControlBeginUsed = NO;
    self.titleLabel.text = self.titleString;
    
    if (isPickingExercise == 0) {
        UIBarButtonItem *actionSheet = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];
        self.navigationItem.rightBarButtonItem = actionSheet;
        [actionSheet release];
    }else if(isPickingExercise == 1){

        UIBarButtonItem *addNewExercise = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addExercise)];
        self.navigationItem.rightBarButtonItem = addNewExercise;
        [addNewExercise release];
    }

    
    [self.descriptionTextView setText:self.info];
    //[self.descriptionTextView setUserInteractionEnabled:NO];
    
    [self getPhotoFromArray:picArray];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeginUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;

	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeginUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeginUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
    
    
    
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeginUsed = YES;
}

-(void)addExercise{
    
    
    [self addExerciseToProgramWithPhotos:picArray title:self.titleString andDescription:self.info];
    
}


-(void)addExerciseToProgramWithPhotos:(NSArray *)array title:(NSString *)title andDescription:(NSString *)descript{
    
    
    NSMutableArray *checkArray = [[NSMutableArray alloc]initWithContentsOfFile:self.plistPath];
     NSMutableDictionary *dataDict =[[NSMutableDictionary alloc] init];
    if (checkArray != nil) {
        
        [dataDict setObject:array forKey:@"pics"];
        [dataDict setObject:title forKey:@"title"];
        if (descript == nil) {
            [dataDict setObject:@"" forKey:@"description"];
        }else{
            [dataDict setObject:descript forKey:@"description"];
        }

        [checkArray addObject:dataDict];
        [checkArray writeToFile:self.plistPath atomically:YES];
        
    }else{
        
        [dataDict setObject:array forKey:@"pics"];
        [dataDict setObject:title forKey:@"title"];
        if (descript == nil) {
            [dataDict setObject:@"" forKey:@"description"];
        }else{
            [dataDict setObject:descript forKey:@"description"];
        }

        
        [[NSMutableArray arrayWithObject:dataDict] writeToFile:self.plistPath atomically:YES];
        
    }
    [checkArray release];
    [dataDict release];
    
     UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4];
    [self.navigationController popToViewController:controller animated:YES];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [picArray release];
    [_descriptionTextView release];
    [_titleLabel release];
    [super dealloc];
}
- (void)viewDidUnload {

    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setTweetView:nil];
    [self setDescriptionTextView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}
@end
