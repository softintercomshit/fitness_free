//
//  ScrollPreviewController.m
//  iKa4iok
//
//  Created by Alexandr Dzerjitchii on 12/10/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "ScrollPreviewController.h"

@interface ScrollPreviewController ()
@property(nonatomic,retain)NSMutableArray *arrayWithKeys;
@property (nonatomic, retain)NSString *descriptionData;
@end

@implementation ScrollPreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil andRequiredData:(NSMutableArray *)dataArray andDescription:(NSString *)exDescription {
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.arrayWithKeys = [NSMutableArray arrayWithArray:dataArray];
        self.descriptionData = [NSString stringWithString:exDescription];
    }
    return self;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentTextView.text = self.descriptionData;
    [self addScrollViewContent:self.arrayWithKeys withScrollView:self.contentScroll];
    self.pageControler.numberOfPages = [self.arrayWithKeys count];
    // Do any additional setup after loading the view from its nib.
}


-(void)addScrollViewContent:(NSMutableArray *)contentArray withScrollView:(UIScrollView *)scrollView{
    
    for (int i = 0; i<[contentArray count]; i++) {
        
        CGRect frame;
        UIImageView *contentImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[contentArray objectAtIndex:i]]];
        
        if (contentImageView.image.size.width==320) {
            frame.origin.x = scrollView.frame.size.width * i;
            frame.origin.y = 50;
        }else if(contentImageView.image.size.width==200){
            frame.origin.x = scrollView.frame.size.width * i+60;
            frame.origin.y = 20;
        }
        
		frame.size = CGSizeMake(contentImageView.image.size.width, contentImageView.image.size.height);
        [contentImageView setFrame:frame];
        
		[scrollView addSubview:contentImageView];
        [contentImageView release];
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width *[contentArray count], scrollView.frame.size.height);
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeginUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.contentScroll.frame.size.width;
		int page = floor((self.contentScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControler.currentPage = page;
        
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
    
    
    
	frame.origin.x = self.contentScroll.frame.size.width * self.pageControler.currentPage;
	frame.origin.y = 0;
	frame.size = self.contentScroll.frame.size;
	[self.contentScroll scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeginUsed = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contentScroll release];
    [_contentTextView release];
    [_pageLabel release];
    [_pageControler release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setContentScroll:nil];
    [self setContentTextView:nil];
    [self setPageLabel:nil];
    [self setPageControler:nil];
    [super viewDidUnload];
}
@end
