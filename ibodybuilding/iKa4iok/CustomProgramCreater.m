//
//  CustomProgramCreater.m
//  iKa4iok
//
//  Created by Johnny Bravo on 12/4/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "CustomProgramCreater.h"
#import "DaysTableViewController.h"
#import "DaysController.h"

@interface CustomProgramCreater ()

@end

@implementation CustomProgramCreater
@synthesize isEditing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
 
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
    if (nameString == nil || daysString == nil) {
        nameString = NSLocalizedString(@"My Workout", nil);
        daysString = @"3";
        //[self.navigationItem.rightBarButtonItem setEnabled:NO];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checkTextField = 0;
    [_doneButton setHidden:YES];
    
    if (isEditing == 0) {
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonisTouched:)];
        [self.navigationItem setRightBarButtonItem:addButton animated:YES];
        [addButton release];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCustomProgramCreation:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
        [cancelButton release];
        
        
    }else{
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonisTouched:)];
        
        [self.navigationItem setRightBarButtonItem:addButton animated:YES];
        [addButton release];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCustomProgramCreation:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
        [cancelButton release];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
     [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 50 ,320,50)];
}

-(IBAction)cancelCustomProgramCreation:(id)sender{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction)doneButtonisTouched:(id)sender{
    
    [self creatProgramByName:nameString andDays:daysString];
    
}


-(void)creatProgramByName:(NSString*)name andDays:(NSString*)days{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//     NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBodyBuilding"];
//    NSLog(@"path Work %@",path);
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSString *finalForDays;
    NSMutableArray  *daysPaths = [[NSMutableArray alloc]init];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        finalForDays = [dataPath copy];
     
    }else{
        NSArray * folderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
        NSString *textFieldName = name;
        bool found = 0;
        NSString *stringToFind = textFieldName;
        
        do{
            found = 0;
            for (int i =0; i<[folderArray count]; i++) {
                NSString * folderName = [folderArray objectAtIndex:i];
   

                if ([[folderName precomposedStringWithCanonicalMapping] isEqualToString:[stringToFind precomposedStringWithCanonicalMapping]])
                {
                    NSString *folderIndexString = [folderName stringByReplacingOccurrencesOfString:name withString:@""];
                    int folderIndex = [folderIndexString intValue];
                    folderIndex++;
                    folderIndexString = [NSString stringWithFormat:@"%i", folderIndex];
                    NSString *finalPath =[dataPath stringByAppendingString:folderIndexString];
                    finalForDays = finalPath;
                    [[NSFileManager defaultManager] createDirectoryAtPath:finalPath withIntermediateDirectories:NO attributes:nil error:nil];
                    stringToFind = [textFieldName stringByAppendingString:folderIndexString];
                    
                    found = 1;
                }
            }
        }while(found != 0);
        
    }
    for (int  i = 1; i<[days intValue]+1; i++) {
        
          NSString *  daysPathFolder = [finalForDays stringByAppendingPathComponent:[NSString stringWithFormat:@"Day %i",i]];
        [daysPaths addObject:daysPathFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:daysPathFolder])
            [[NSFileManager defaultManager] createDirectoryAtPath:daysPathFolder withIntermediateDirectories:NO attributes:nil error:nil];
        

    }
    
    
    DaysController *contollerDays = [[DaysController alloc]initWithDataArray:daysPaths andMane:nameString];
    contollerDays.isEditing = 1;
    contollerDays.isCustom = 1;
    
//    DaysTableViewController *daysController = [[DaysTableViewController alloc]initWithNibName:nil bundle:nil withDataArray:daysPaths name:nameString];
//    daysController.isPreview = 0;
//    daysController.isEditing = 0;
    
    [self.navigationController pushViewController:contollerDays animated:YES];
    [contollerDays release];
    [daysPaths release];
    
}




-(void)cancelNumberPad{
    
    if (checkTextField == 1) {
        [_programName resignFirstResponder];
        _programName.text = @"";
    }else if(checkTextField == 2){
        [_programDays resignFirstResponder];
        _programDays.text = @"";
        
    }
}

-(void)doneWithNumberPad{
    
    if (checkTextField == 1) {
        [_programName resignFirstResponder];
        nameString = _programName.text;
    }else if(checkTextField == 2){
        [_programDays resignFirstResponder];
        daysString = _programDays.text;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate Protocol Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*--
     * This method is called when the textField becomes active, or is the First Responder
     --*/
    [self animateTextField:textField up:YES];
    
    if (textField.tag == 20) {
        checkTextField = 1;
    }else if(textField.tag == 21){
        checkTextField = 2;
    }
    

    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    /*--
     * This method is called just before the textField is no longer active
     * Return YES to let the textField resign first responder status, otherwise return NO
     * Use this method to turn the background color back to white
     --*/
    

    
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*--
     * This method is called when the textField is no longer active
     --*/
    [self animateTextField:textField up:NO];
    if (textField.tag == 21) {

        if ([textField.text intValue]>7) {
            
            textField.text = @"7";
            
            
        }else{
            
            
        }
    }else if(textField.tag == 20){
        if ([textField.text length]==0) {
            textField.text = NSLocalizedString(@"My Workout", nil);
        }
    }
    if ([_programDays.text length]!=0 &&[_programName.text length]!=0) {
        
        [_doneButton setHidden:NO];
        
    }else{
        
        [_doneButton setHidden:YES];
    }
    
    

}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIResponder Override
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*--
     * Override UIResponder touchesBegan:withEvent: to resign any active textFields when the user taps the background
     * Use fast enumeration to go through the subview property of UIView
     * Any object that is the current first repsonder will resign that status
     * Make a call to super to take care of any unknown behavior that touchesBegan:withEvent: needs to do behind the scenes
     --*/
    

    
    for (UITextField *textField in self.view.subviews) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - #---TableView delegate---#

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageOnRightCell";
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    
    switch (indexPath.row) {
        case 0:
        {
            
            [[cell textLabel] setText:NSLocalizedString(@"Workout Name:", nil)];
            if (nameString == nil ) {
                [[cell detailTextLabel] setText:NSLocalizedString(@"My Workout", nil)];
            }else{
                [[cell detailTextLabel] setText:nameString];
            }
            
            
            break;
        }
         case 1:
        {
            [[cell textLabel] setText:NSLocalizedString(@"Days Number:", nil)];
            if (daysString == nil ) {
                [[cell detailTextLabel] setText:@"3"];
            }else{
                [[cell detailTextLabel] setText:daysString];
            }

            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

-(void)getTextFieldData:(NSString *)data withTextFieldType:(BOOL)textFieldType{
    

    if (textFieldType == NO) {
        if (data!=nil) {
            nameString = [data copy];
        }else{
            nameString = NSLocalizedString(@"My Workout", nil);
        }
        
    }else{
        if (data!=nil) {
            daysString = [data copy];
        }else{
            daysString = @"3";
        }
        
    }
    
    
    [self.settingTableView reloadData];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataInputCller *inputController = nil;
    switch (indexPath.row) {
        case 0:
        {
            inputController =[[[DataInputCller alloc]initWithNibName:@"DataInputCller" bundle:nil andInputType:NO] autorelease];
            if (nameString!=nil) {
                [inputController.sessionTextField setText:nameString];
                
            }else{
                [inputController.sessionTextField setText:NSLocalizedString(@"My Workout", nil)];
               
            }
           inputController.isTitle =  1;
             break;
        }
        case 1:
        {
            inputController =[[[DataInputCller alloc]initWithNibName:@"DataInputCller" bundle:nil andInputType:YES] autorelease];
            if (daysString!=nil) {
                [inputController.sessionTextField setText:daysString];
                [inputController setNumberStr:daysString];
            }else{
                [inputController.sessionTextField setText:@"3"];
            }
             inputController.isTitle = NO;
            break;
        }
            
        default:
            break;
    }
   
    [inputController setDelegate:self];
    [self.navigationController pushViewController:inputController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)dealloc {
    [_programName release];
    [_programDays release];
    [_doneButton release];
    [_settingTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProgramName:nil];
    [self setProgramDays:nil];
    [self setDoneButton:nil];
    [self setSettingTableView:nil];
    [super viewDidUnload];
}
@end
