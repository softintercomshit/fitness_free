//
//  BBCustomExercise.m
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/11/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "BBCustomExercise.h"

#import "UIImage+FX.h"
@interface BBCustomExercise ()

@end

@implementation BBCustomExercise
@synthesize exerciseDescription,exerciseTitle,folderPath,plistString,photoArray,exerciseRepetitions;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        photoArray = [[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
}



#pragma mark - Cancel Function

-(void)getBackonRootViewController {
    
    if (self.isEditing == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([photoArray count]!=0)
        {
            NSError *error;
            for (int i = 0; i<[photoArray count]; i++)
            {
                
                [[NSFileManager defaultManager] removeItemAtPath:[photoArray objectAtIndex:i] error:&error];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Saving Function

-(void)saveExercise {
    if ([[contentDict objectForKey:@"title"] length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please fill up the exercise name field!", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        
    }else{
        
        
        if ([photoArray count]==0)
        {
            [self addExerciseToProgramWithPhotos:[NSMutableArray array] title:[contentDict objectForKey:@"title"] andDescription:[contentDict objectForKey:@"description"] andReps:exerciseRepetitions];
        }else
        {
            [self addExerciseToProgramWithPhotos:photoArray title:[contentDict objectForKey:@"title"] andDescription:[contentDict objectForKey:@"description"] andReps:exerciseRepetitions];
        }
    }
    
}

-(void)addExerciseToProgramWithPhotos:(NSArray *)array title:(NSString *)title andDescription:(NSString *)descript andReps:(NSString *)repetitions{
    
    
    NSMutableArray *checkArray = [[NSMutableArray alloc]initWithContentsOfFile:plistString];
    NSMutableDictionary *dataDict =[[NSMutableDictionary alloc] init];
    if (checkArray != nil) {
        
        [dataDict setObject:array forKey:@"images"];
        [dataDict setObject:title forKey:@"title"];
        if (descript == nil) {
            [dataDict setObject:@"" forKey:@"description"];
        }else{
            [dataDict setObject:descript forKey:@"description"];
        }
        if (repetitions == nil)
        {
            [dataDict setObject:@"" forKey:@"reps"];
        }else
        {
            [dataDict setObject:repetitions forKey:@"reps"];
        }
        [dataDict setObject:[NSNumber numberWithInt:1] forKey:@"customized"];
        
        if (self.isEditing == 1) {
            
            [checkArray removeObjectAtIndex:self.getObjectIndex];
            [checkArray addObject:dataDict];
            [checkArray writeToFile:plistString atomically:YES];
            
        }else{
            
            [checkArray addObject:dataDict];
            [checkArray writeToFile:plistString atomically:YES];
            
        }
        
        self.isEditing = 0;
        
    }else{
        
        [dataDict setObject:array forKey:@"images"];
        [dataDict setObject:title forKey:@"title"];
        if (descript == nil) {
            [dataDict setObject:@"" forKey:@"description"];
        }else{
            [dataDict setObject:descript forKey:@"description"];
        }
        if (repetitions == nil)
        {
            [dataDict setObject:@"" forKey:@"reps"];
        }else
        {
            [dataDict setObject:repetitions forKey:@"reps"];
        }
        [dataDict setObject:[NSNumber numberWithInt:1] forKey:@"customized"];
        
        [[NSMutableArray arrayWithObject:dataDict] writeToFile:plistString atomically:YES];
    }
    
    [checkArray release];
    [dataDict release];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - DataInput Delegate


-(void)getDescriptionString:(NSString *)exDescription{
    
    
    if ([exDescription length]!=0 || ![exDescription isEqualToString:@" "]) {
        [contentDict setObject:exDescription forKey:@"description"];
        exerciseDescription = [exDescription copy];
        [_contentTableView reloadData];
    }
    
    
}

-(void)getTextFieldData:(NSString *)data withTextFieldType:(BOOL)textFieldType{
    
    
    
    if ([data length]!=0 || ![data isEqualToString:@" "])
    {
        exerciseTitle = [data copy];
        [contentDict setObject:data forKey:@"title"];
        [_contentTableView reloadData];
        
    }
    else
    {
        
        
    }
    
    
}
-(void)getTextFieldData:(NSString *)data isRepetition:(BOOL)isRepetition{
    
    if (isRepetition == 1) {
        if ([data length]!=0 || ![data isEqualToString:@" "]) {
            exerciseRepetitions = [data copy];
            [contentDict setObject:data forKey:@"reps"];
            [_contentTableView reloadData];
        }
    }
}


#pragma mark - TableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int cellHeight = 0;
    
    switch (indexPath.section) {
        case 0:
        {
            cellHeight = 150;
            break;
        }
        case 1:
        {
            cellHeight = 50;
            break;
        }
            
        default:
            break;
    }
    
    return cellHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionTitle = nil;
    
    switch (section) {
        case 0:
        {
            sectionTitle = NSLocalizedString(@"Exercise's Photos", nil);
            
            break;
        }
        case 1:
        {
            sectionTitle = NSLocalizedString(@"Name, Description, Repetitions", nil);
            
            break;
        }
            
        default:
            break;
    }
    
    return sectionTitle;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    
    switch (section) {
        case 0:
        {
            numberOfRows = 1;
            break;
        }
        case 1:
        {
            numberOfRows = 3;
            break;
        }
            
        default:
            break;
    }
    return numberOfRows;
}

-(IBAction)removeobjectFromArrayAndScrollView:(id)sender{
    
    
    
    //
    //    if ([photoArray count]==0) {
    //
    //        for(UIView *subview in [imageScrollView subviews]) {
    //            [subview removeFromSuperview];
    //        }
    //    }
}

-(void)addScrollViewContent:(NSMutableArray *)contentArray withScrollView:(UIScrollView *)scrollView{
    NSLog(@"*** FOR ***");
    NSLog(@"Countion subviews of scrollview: %d", [[scrollView subviews] count]);
    NSArray *viewsToRemove = [scrollView subviews];
    for (UIView *v in viewsToRemove) {
        NSLog(@"Imagscrollview subview: %@", v.description);
        if ([v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }else if ([v isKindOfClass:[UIButton class]])
        {
            [v removeFromSuperview];
        }else{
        }
        //        [[scrollView.subviews objectAtIndex:i] release];
    }
    
    for (int i = 0; i<[contentArray count]; i++) {
        
        CGRect superframe;
        UIImage *imgs = [UIImage imageWithContentsOfFile:[contentArray objectAtIndex:i]];
        
        imgs = [self imageByScalingAndCroppingForSize:CGSizeMake(100, 144) withSourceImage:imgs];
        
        UIImageView *contentImageView = [[UIImageView alloc]initWithImage:imgs];
        
        
        superframe.origin.x = (contentImageView.frame.size.width+10) * i;
        superframe.origin.y = 3;
        
        superframe.size = CGSizeMake(contentImageView.image.size.width, contentImageView.image.size.height);
        [contentImageView setFrame:superframe];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"deleteButton.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self
                      action:@selector(deleteImage:)
            forControlEvents:UIControlEventTouchDown];
        deleteBtn.tag = i;
        [deleteBtn setFrame:CGRectMake(-10, -10, 15, 15)];
        [deleteBtn setFrame:CGRectMake(superframe.origin.x, superframe.origin.y, deleteBtn.frame.size.width, deleteBtn.frame.size.height)];
        [scrollView addSubview:contentImageView];
        [scrollView addSubview:deleteBtn];
        
        //            UIButton *huila = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 20, 20)];
        //            [huila setTitle:@"x" forState:UIControlStateNormal];
        //            [huila setBackgroundColor:[UIColor purpleColor]];
        //            huila.tag = i;
        //            [huila addTarget:self action:@selector(removeobjectFromArrayAndScrollView:) forControlEvents:UIControlEventTouchUpInside];
        //
        //            [contentImageView addSubview:huila];
        
        
        scrollView.contentSize = CGSizeMake((superframe.size.width +10) *[contentArray count], contentImageView.frame.size.height);
        [contentImageView release];
        
        
    }
    
    
}

-(void)deleteImage:(UIButton*)sender
{
    
    NSLog(@"Delete image %d", sender.tag);
    //    [photoArray removeObjectAtIndex:sender.tag];
    
    if ([photoArray count]!=0) {
        
        imageScrollView.contentSize = CGSizeMake(0, 0);
        NSMutableArray *arr = [NSMutableArray array];
        for (int i =0; i<[photoArray count]; i++) {
            if ((UIImage*)[UIImage imageWithContentsOfFile:[photoArray objectAtIndex:i]]!=nil) {
                [arr addObject:[photoArray objectAtIndex:i]];
            }
        }
        NSLog(@"Photo array: %@", photoArray);
        NSLog(@"Image arr: %d", sender.tag);
        if([photoArray count] > sender.tag)
            [photoArray removeObjectAtIndex:sender.tag];
        [arr removeObjectAtIndex:sender.tag];
        NSLog(@"Photo array: %@", photoArray);
        NSLog(@"Image arr: %@", arr);
        //        [imageScrollView release];
        //        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 47.0, 300, 150.0)];
        
        if ([photoArray count]!=0) {
            NSMutableArray *arr = [NSMutableArray array];
            for (int i =0; i<[photoArray count]; i++) {
                NSString *path;
                NSArray *comps = [[photoArray objectAtIndex:i] pathComponents];
                if ([comps containsObject:@"Library"]) {
                    NSLog(@"1 - %@", [comps objectAtIndex:5]);
                    path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    //                path = [path stringByDeletingLastPathComponent];
                    //                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
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
                NSLog(@"path %@", path);
                
                if ((UIImage*)[UIImage imageWithContentsOfFile:path]!=nil) {
                    [arr addObject:path];
                }
                
            }
            
            [self addScrollViewContent:arr withScrollView:imageScrollView];
            
        }
        NSLog(@"sender tag %d", sender.tag);
        [sender removeFromSuperview];
    }
    NSLog(@"Imagscrollview subviews: %@", imageScrollView.subviews);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ImageOnRightCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        
        if (indexPath.section == 0) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            
        }else{
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                [[cell detailTextLabel] setAdjustsFontSizeToFitWidth:YES];
            }else{
                [[cell detailTextLabel] setAdjustsFontSizeToFitWidth:NO];
            }
        }
    } else {
        
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [[cell textLabel] setText:NSLocalizedString(@"Exercise Name:", nil)];
            if (exerciseTitle != nil) {
                
                [[cell detailTextLabel] setText:exerciseTitle];
                
            }else{
                
                
            }
            
        }else if(indexPath.row == 1)
        {
            
            [[cell textLabel] setText:NSLocalizedString(@"Description:", nil)];
            if (exerciseDescription != nil)
            {
                
                [[cell detailTextLabel] setText:exerciseDescription];
                
            }else{
                
                
            }
            
        }else if(indexPath.row == 2)
        {
            [[cell textLabel] setText:NSLocalizedString(@"Repetitions:", nil)];
            
            if (exerciseRepetitions !=nil)
            {
                [[cell detailTextLabel] setText:exerciseRepetitions];
            }else
            {
                [[cell detailTextLabel] setText:nil];
            }
            
        }
        
    }
    return cell;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissModalViewControllerAnimated:YES];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 50 ,320,50)];
    
}




- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImages
{
    UIImage *sourceImage = sourceImages;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    return newImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    pickedImage = [self imageByScalingAndCroppingForSize:CGSizeMake(200, 300) withSourceImage:pickedImage];
    
    
    NSData *imageData = UIImagePNGRepresentation(pickedImage);
    NSString *path;
    
    if (exerciseTitle != nil) {
        path = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"myimage%@.png",pickedImage]];
    }else{
        path = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"myPick%@.png",pickedImage]];
    }
    
    NSError * error = nil;
    
    if (folderPath != nil) {
        
        [photoArray addObject:path];
        [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
        
    }else{
        
        
    }
    
    if (error != nil) {
        
        return;
    }
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [picker dismissModalViewControllerAnimated:YES];
    }
    
    [imagePicker dismissModalViewControllerAnimated:YES];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height - 50 ,320,50)];
    
}

-(NSArray*)getDaysFolderList:(NSString *)type{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:type error:nil];
    
    return fileList;
}

-(IBAction)openImagePickerController:(id)sender{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setShowsCameraControls:YES];
        [self presentModalViewController:imagePicker animated:YES];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Camera Support!", nil) message:NSLocalizedString(@"Camera feature is not supported by your device !", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height + 100 ,320,50)];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
            {
                
                
                DataInputCller *titleController = [[[DataInputCller alloc] initWithNibName:@"DataInputCller" bundle:nil andInputType:NO] autorelease];
                titleController.delegate = self;
                titleController.isOtherType = 1;
                titleController.isTitle = 1;
                titleController.stringText = exerciseTitle;
                // titleController.sessionTextField.text = exerciseTitle;
                [self.navigationController pushViewController:titleController animated:YES];
                
                break;
            }
            case 1:
            {
                
                DescriptionViewController *descriptions = [[[DescriptionViewController alloc]initWithNibName:@"DescriptionViewController" bundle:nil] autorelease];
                descriptions.delegate = self;
                descriptions.descriptionString = exerciseDescription;
                [self.navigationController pushViewController:descriptions animated:YES];
                
                break;
            }
            case 2:
            {
                
                DataInputCller *titleController = [[[DataInputCller alloc] initWithNibName:@"DataInputCller" bundle:nil andInputType:NO] autorelease];
                titleController.delegate = self;
                titleController.isOtherType = 1;
                titleController.isRepetition = 1;
                titleController.stringText = exerciseRepetitions;
                //titleController.sessionTextField.text = exerciseRepetitions;
                
                [self.navigationController pushViewController:titleController animated:YES];
                
                break;
            }
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveExercise)];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(openImagePickerController:)];
    UIBarButtonItem *libraryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(LibraryPicture)];
    
    
    UIBarButtonItem  *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(getBackonRootViewController)];
    
    self.navigationItem.rightBarButtonItems = @[saveButton,cameraButton,libraryButton];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [saveButton release];
    [cancelButton release];
    [cameraButton release];
    
    //    if (IS_HEIGHT_GTE_568) {
    //        [self.contentTableView setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
    //    }
    
    contentDict = [[NSMutableDictionary alloc]init];
    imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker setDelegate:self];
    [_contentTableView setScrollEnabled:NO];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (IS_HEIGHT_GTE_568) {
            imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 47.0, 300, 150.0)];
        }else{
            imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 47.0, 300, 150.0)];
        }
        
    }else{
        if (IS_HEIGHT_GTE_568) {
            imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 120.0, 300, 150.0)];
        }else{
            imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 120.0, 300, 150.0)];
        }
    }
    imageScrollView.tag = 11;
    
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    //imageScrollView.pagingEnabled = YES;
    imageScrollView.delaysContentTouches = NO;
    imageScrollView.canCancelContentTouches = NO;
    imageScrollView.userInteractionEnabled =  YES;
    imageScrollView.delegate = self;
    [self.view addSubview:imageScrollView];
    [folderPath retain];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)LibraryPicture
{
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
        [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,[[UIScreen mainScreen]bounds].size.height +100 ,320,50)];
    
}






-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[AdMobViewController sharedAdMob] bannerFrame:CGRectMake(0,self.view.frame.size.height - 50,320,50)];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (self.isEditing == 1) {
        [contentDict setObject:exerciseTitle forKey:@"title"];
        if (exerciseDescription == nil) {
            [contentDict setObject:@"" forKey:@"description"];
        }else{
            [contentDict setObject:exerciseDescription forKey:@"description"];
        }
        if (exerciseRepetitions == nil)
        {
            [contentDict setObject:@"" forKey:@"reps"];
        }else
        {
            [contentDict setObject:exerciseRepetitions forKey:@"reps"];
        }
        
    }
    
    if ([photoArray count]!=0) {
        
        imageScrollView.contentSize = CGSizeMake(0, 0);
        NSMutableArray *arr = [NSMutableArray array];
        for (int i =0; i<[photoArray count]; i++) {
            NSString *path;
            NSArray *comps = [[photoArray objectAtIndex:i] pathComponents];
            if ([comps containsObject:@"Library"]) {
                NSLog(@"1 - %@", [comps objectAtIndex:5]);
                path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                //                path = [path stringByDeletingLastPathComponent];
                //                path = [path stringByAppendingPathComponent:[comps objectAtIndex:[comps count]-3]];
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
            NSLog(@"path %@", path);
            
            if ((UIImage*)[UIImage imageWithContentsOfFile:path]!=nil) {
                [arr addObject:path];
            }
            
        }
        
        [self addScrollViewContent:arr withScrollView:imageScrollView];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [contentDict release];
    [photoArray removeAllObjects];
    [photoArray release];
    [plistString release];
    [imagePicker setDelegate:nil];
    [imagePicker release];
    [addButton release];
    [imageScrollView release];
    [_contentTableView release];
    [exerciseTitle release];
    [exerciseDescription release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    imagePicker = nil;
    exerciseDescription = nil;
    exerciseTitle = nil;
    addButton = nil;
    imageScrollView = nil;
    [self setContentTableView:nil];
    
    [super viewDidUnload];
    
}
@end
