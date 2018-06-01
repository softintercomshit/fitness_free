//
//  DescriptionViewController.m
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/18/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController
@synthesize delegate,descriptionString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Description", nil);
    }
    return self;
}


-(void)saveDescription{
    
    [self.descriptionTextView resignFirstResponder];
    
    if ([self.descriptionTextView.text length]!=0) {
        
        [delegate getDescriptionString:self.descriptionTextView.text];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No description" message:@"Please insert you exercise description in text field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
       // [alert show];
       // [alert release];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.descriptionTextView.layer.borderWidth = 3.0f;
    self.descriptionTextView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    self.descriptionTextView.layer.cornerRadius = 7.0;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (IS_HEIGHT_GTE_568) {
            [self.descriptionTextView setFrame:CGRectMake(self.descriptionTextView.frame.origin.x, 70, self.descriptionTextView.frame.size.width, 170)];
        }

    }else{
    if (IS_HEIGHT_GTE_568) {
        [self.descriptionTextView setFrame:CGRectMake(self.descriptionTextView.frame.origin.x, 70, self.descriptionTextView.frame.size.width, 170)];
    }else{
        [self.descriptionTextView setFrame:CGRectMake(self.descriptionTextView.frame.origin.x, 70, self.descriptionTextView.frame.size.width, 170)];
    }
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveDescription)];
    self.navigationItem.leftBarButtonItem = doneButton;
    [doneButton release];
    
    [self.descriptionTextView setText:descriptionString];
   // view.layer.borderWidth = 5.0f;
    //view.layer.borderColor = [[UIColor grayColor] CGColor];
    // Do any additional setup after loading the view from its nib.
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

- (void)dealloc {
    [_descriptionTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDescriptionTextView:nil];
    [super viewDidUnload];
}
@end
