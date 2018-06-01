//
//  DataInputCller.m
//  iBodybuilding
//
//  Created by Johnny Bravo on 12/28/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "DataInputCller.h"

@interface DataInputCller ()

@end

@implementation DataInputCller
@synthesize delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andInputType:(BOOL)yesOrNo{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isDays = yesOrNo;
       
    }
    return self;
}

#pragma mark - PickerView Aparition Animation

-(void)animatePickerViewAnimationUp{

    [UIView animateWithDuration:0.5 animations:^{
        if (IS_HEIGHT_GTE_568) {
            self.dayPicker.frame = CGRectMake(self.dayPicker.frame.origin.x, self.dayPicker.frame.origin.y-255, self.dayPicker.frame.size.width, self.dayPicker.frame.size.height);
        }else{
            self.dayPicker.frame = CGRectMake(self.dayPicker.frame.origin.x, self.dayPicker.frame.origin.y-324, self.dayPicker.frame.size.width, self.dayPicker.frame.size.height);
        }
        
        
    } completion:^(BOOL finished) {

    }];
}

-(void)animatePickerViewAnimationDown{
    
    [UIView animateWithDuration:3 animations:^{
        if (IS_HEIGHT_GTE_568) {
            self.dayPicker.frame = CGRectMake(self.dayPicker.frame.origin.x, self.dayPicker.frame.origin.y+200, self.dayPicker.frame.size.width, self.dayPicker.frame.size.height);
        }else{
            self.dayPicker.frame = CGRectMake(self.dayPicker.frame.origin.x, self.dayPicker.frame.origin.y+150, self.dayPicker.frame.size.width, self.dayPicker.frame.size.height);
        }
        
    
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - ### Data Picker Delegate (Required) ###

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 31;
}

#pragma mark - ### Data Picker Delegate (Optional) ###
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *returnString;

    if (row == 0)
    {
        returnString = [[NSString stringWithFormat:@"%d  ",row+1] stringByAppendingFormat:NSLocalizedString(@"Day", nil)];
    }
    else
    {
        returnString = [[NSString stringWithFormat:@"%d ",row+1] stringByAppendingFormat:NSLocalizedString(@"Days", nil)];
    }
    
    
    return returnString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [self.sessionTextField setText:[NSString stringWithFormat:@"%d",row+1]];
}

-(void)sendToParentView{
    
    [self.sessionTextField resignFirstResponder];
    if ([self.sessionTextField.text isEqualToString:@" "] || [self.sessionTextField.text length]==0 )
    {
        NSLog(@"Is title empty");
        if (self.isTitle == 1) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please fill up the text field!", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
        }else{
            
            if (isDays == NO)
            {
                NSLog(@"Is not title");
                if (self.isRepetition == 0)
                {
                    [delegate getTextFieldData:self.sessionTextField.text withTextFieldType:isDays];
                }else
                {
                    [delegate getTextFieldData:self.sessionTextField.text isRepetition:YES];
                }
                
            }else
            {
                NSLog(@"Is title");
                [delegate getTextFieldData:self.sessionTextField.text withTextFieldType:isDays];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            
        
    }else{
        
        if (isDays == NO)
        {
            if (self.isRepetition == 0)
            {
                [delegate getTextFieldData:self.sessionTextField.text withTextFieldType:isDays];   
            }else
            {
                [delegate getTextFieldData:self.sessionTextField.text isRepetition:YES];
            }
          
        }else
        {
            [delegate getTextFieldData:self.sessionTextField.text withTextFieldType:isDays];
        }
           [self.navigationController popViewControllerAnimated:YES];
    }
 

//    if ([self.sessionTextField.text length]!=0) {
//        if (isDays == NO) {
//            [delegate getTextFieldData:self.sessionTextField.text withTextFieldType:isDays];
//        }else{
//            [delegate getTextFieldData:self.sessionTextField.text withTextFieldType:isDays];
//        }
//    }else{
//        if (isDays == NO) {
//            [delegate getTextFieldData:nil withTextFieldType:isDays];
//        }else{
//            [delegate getTextFieldData:nil withTextFieldType:isDays];
//        }
//        
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//
//    if ([self.sessionTextField.text length]!=0) {
//        
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No title" message:@"Please insert you exercise title in text field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//        [alert release];
//        
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isDays == NO) {
        
        self.dayPicker.frame = CGRectMake(self.dayPicker.frame.origin.x, self.dayPicker.frame.origin.y+300, self.dayPicker.frame.size.width, self.dayPicker.frame.size.height);
        [self.sessionTextField setUserInteractionEnabled:YES];
      //  [self.sessionTextField setPlaceholder:@"Set Title"];
        if ([self.sessionTextField.text length]!=0) {
            
        }else{
            if (self.isOtherType == 0) {
                 [self.sessionTextField setText:NSLocalizedString(@"My Workout", nil)];
            }else{
                 [self.sessionTextField setText:@" "];
            }
           
        }
        
    }else{
        
        [self animatePickerViewAnimationUp];
        //[self.sessionTextField removeFromSuperview];
        [self.dayPicker selectRow:2 inComponent:0 animated:YES];
    }
    [self.dayPicker selectRow:[self.numberStr intValue]-1 inComponent:0 animated:YES];
    [self.sessionTextField setText:self.numberStr];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Days string: %@", self.numberStr);
    [super viewWillAppear:animated];
    
    if (isDays == NO)
    {
        
    }else{
       [self.sessionTextField removeFromSuperview]; 
    }
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(sendToParentView)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    
    
    UITableView *tv ;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    if (IS_HEIGHT_GTE_568) {
        tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 580) style:UITableViewStyleGrouped];
    }else{
        
        tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    }}else{
        if (IS_HEIGHT_GTE_568) {
            tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 580) style:UITableViewStyleGrouped];
        }else{
            
            tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
        }
    }
    
    [self.view addSubview:tv];
    [self.view sendSubviewToBack:tv];
    
    self.dayPicker.frame = CGRectMake(self.dayPicker.frame.origin.x, self.dayPicker.frame.origin.y+300, self.dayPicker.frame.size.width, self.dayPicker.frame.size.height);
    
    [self.sessionTextField setText:self.stringText];
    
    [self.sessionTextField setFrame:CGRectMake(22, 122, 280, 40)];
    [self.sessionTextField setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_dayPicker release];
    [_sessionTextField release];
    [super dealloc];
}
- (void)viewDidUnload {

    [self setDayPicker:nil];
    [self setSessionTextField:nil];
    [super viewDidUnload];
}
@end
