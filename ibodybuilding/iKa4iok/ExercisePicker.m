//
//  ExercisePicker.m
//  iKa4iok
//
//  Created by Johnny Bravo on 12/5/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import "ExercisePicker.h"
#import "CategoryClass.h"
#import "ScrollPreviewController.h"
#import "BBCustomExercise.h"
@interface ExercisePicker ()
@property (nonatomic, retain)NSString *generalPath;
@property (nonatomic, retain)NSMutableArray *dataArray;
@end

@implementation ExercisePicker
@synthesize  isPreviewing,isEditing;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPathLink:(NSString *)path{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.generalPath = [NSString stringWithString:path];
        self.title = [NSString stringWithString:[path lastPathComponent]];

    }
    return self;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageNum = 0;
    if (isPreviewing == 0) {
        UIBarButtonItem *addExercise = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showActionSheet)];
        self.navigationItem.rightBarButtonItem = addExercise;
        [addExercise release];
    }else{
     
    }
    
}

-(void)getBack{
    
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1];
    
    [self.navigationController popToViewController:controller animated:YES];
    
}


-(void)showActionSheet {
    if (isEditing == 0) {
        
        
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Add exercises from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Exercises", @"Camera", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
        [popupQuery showInView:self.view];
        
        [popupQuery release];
        
        
    }else{
        
        if ([self.dataArray count]!=0) {
            UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Add exercises from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Exercise" otherButtonTitles:@"Exercises", @"Camera", nil];
            popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
            [popupQuery showInView:self.view];
            
            [popupQuery release];
        }else{
            
            
            UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Add exercises from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Exercises", @"Camera", nil];
            popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
            [popupQuery showInView:self.view];
            
            [popupQuery release];
        }


    }
}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (isEditing == 0) {
        if (buttonIndex == 0) {
            [self addExerciseToProgram:self.generalPath];
            
        } else if (buttonIndex == 1) {
            [self creatCustomExercise:self.generalPath];
            
        }
    }else{
        if ([self.dataArray count]!=0) {
            if (buttonIndex == 0) {
                [self removeContentAtIndex:pageNum];
                
            } else if (buttonIndex == 1) {
                [self addExerciseToProgram:self.generalPath];
                
            } else if (buttonIndex == 2) {
                [self creatCustomExercise:self.generalPath];
            }
        }else{
            
            if (buttonIndex == 0) {
                [self addExerciseToProgram:self.generalPath];
                
            } else if (buttonIndex == 1) {
                [self creatCustomExercise:self.generalPath];
                
            }
            
        }
        
    }
}


-(void)creatCustomExercise:(NSString *)pathLink{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
     NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBodyBuilding"];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Camera Feature"];


    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }else{
        
    
    }
    
    NSString *checkString = [pathLink stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[pathLink lastPathComponent]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:checkString]){
        
        NSString *plistPathString = [pathLink stringByAppendingPathComponent:[[self getDaysFolderList:pathLink] objectAtIndex:0]];
        BBCustomExercise *controllerCamera = [[BBCustomExercise alloc]init];
        controllerCamera.folderPath = dataPath;
        controllerCamera.plistString = plistPathString;
        [self.navigationController pushViewController:controllerCamera animated:YES];
        [controllerCamera release];
        
    }else{
        
        plistPath = [pathLink stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[pathLink lastPathComponent]]];
        BBCustomExercise *controllerCamera = [[BBCustomExercise alloc]init];
        controllerCamera.folderPath = dataPath;
        controllerCamera.plistString = plistPath;
        [self.navigationController pushViewController:controllerCamera animated:YES];
        [controllerCamera release];
    }
    
}


-(void)addExerciseToProgram:(NSString*)pathLink{

    NSString *checkString = [pathLink stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[pathLink lastPathComponent]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:checkString]){
    
        NSString *plistPathString = [pathLink stringByAppendingPathComponent:[[self getDaysFolderList:pathLink] objectAtIndex:0]];
        CategoryClass *catClass = [[CategoryClass alloc]initWithNibName:nil bundle:nil];
        catClass.plistPath = plistPathString;
        [self.navigationController pushViewController:catClass animated:YES];
        [catClass release];
        
    }else{
        
        plistPath = [pathLink stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[pathLink lastPathComponent]]];
        CategoryClass *catClass = [[CategoryClass alloc]initWithNibName:nil bundle:nil];
        catClass.plistPath = plistPath;
        
        [self.navigationController pushViewController:catClass animated:YES];
        [catClass release];
    }
    
}

-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    NSMutableArray *checkArray = [NSMutableArray arrayWithArray:fileList];

    for (int i = 0; i<[checkArray count]; i++) {
        if ([[checkArray objectAtIndex:i] isEqualToString:@"Custom"]) {
            [checkArray removeObjectAtIndex:i];
        }
    }
    
    return checkArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
    [self upDateData];

}

-(void)sendContenttoScroller:(NSMutableArray *)array{
    
    if ([array count]!=0) {
        
        for (int i = 0; i<[array count]; i++) {
            
            CGRect scrollsRect;
            
            if (IS_HEIGHT_GTE_568) {
                
                
                
                ScrollPreviewController *  controller = [[ScrollPreviewController alloc]initWithNibName:@"ScrollPreviewControllerip5" andRequiredData:[[array objectAtIndex:i] objectForKey:@"pics"] andDescription:[[array objectAtIndex:i]objectForKey:@"description"]];
                
                scrollsRect.origin.x = 0;
                scrollsRect.origin.y = self.mainScrollView.frame.size.height * i;
                scrollsRect.size = CGSizeMake(320, 504);

                [controller.view setFrame:scrollsRect];
                [self.mainScrollView addSubview:controller.view];
                [controller release];
                self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height * array.count);
                
                
              
            }else{
                
                ScrollPreviewController *controller = [[ScrollPreviewController alloc]initWithNibName:@"ScrollPreviewController" andRequiredData:[[array objectAtIndex:i] objectForKey:@"pics"] andDescription:[[array objectAtIndex:i]objectForKey:@"description"]];
                
                scrollsRect.origin.x = 0;
                scrollsRect.origin.y = self.mainScrollView.frame.size.height * i;
                scrollsRect.size = CGSizeMake(320, 440);
                [controller.view setFrame:scrollsRect];
                [self.mainScrollView addSubview:controller.view];
                [controller release];
                self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height * array.count);
                
            }
        
        }
        
        
        
    }else{
        
        for(UIView *subview in [self.mainScrollView subviews]) {
            [subview removeFromSuperview];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([self.dataArray count]!=0) {
        if (scrollView == self.mainScrollView) {
            pageNum = (int)(self.mainScrollView.contentOffset.y / self.mainScrollView.frame.size.height);
            
        }
    }else{
        
    }
    
    
}

-(void)removeContentAtIndex:(NSUInteger)index{
    
    if ([self.dataArray count]!=0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Are you sure you want to delete selected exercise ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];

    }else{
        
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            
            break;
        }
        case 1:
        {
            [self.dataArray removeObjectAtIndex:pageNum];
            
            NSString *plistPathString = [self.generalPath stringByAppendingPathComponent:[[self getDaysFolderList:self.generalPath] objectAtIndex:0]];
            [self.dataArray writeToFile:plistPathString atomically:YES];
            [self sendContenttoScroller:self.dataArray];
            
            break;
        }
            
        default:
            break;
    }
}



-(void)upDateData{

    if ([[self getDaysFolderList:self.generalPath] count]!=0) {
        
        NSString *plistPathString = [self.generalPath stringByAppendingPathComponent:[[self getDaysFolderList:self.generalPath] objectAtIndex:0]];
        self.dataArray  = [[[NSMutableArray alloc]initWithContentsOfFile:plistPathString] autorelease];

        [self sendContenttoScroller:self.dataArray];
    }else{

        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScrollView:nil];
    [super viewDidUnload];
}
@end
