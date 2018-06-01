//
//  VideoDownloader.m
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 6/3/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "VideoDownloader.h"

@implementation VideoDownloader
@synthesize delegate;
@synthesize tempVideoPath;
static VideoDownloader *instance_;

static void singleton_remover() {

    [instance_ release];
}

+ (VideoDownloader*)instance {
    @synchronized(self) {
        if( instance_ == nil ) {
            [[self alloc] init];
        }
    }
    
    return instance_;
}

- (id)init {
    self = [super init];
    instance_ = self;
    
    atexit(singleton_remover);
    
    return self;
}

-(NSURLRequest *)getRequestFromURL:(NSString *)videoRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:videoRequest]];
    return request;
}

-(NSString *)getFileOutputStream
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ibody.zip"];
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return path;
}

-(NSString *)getFileOutputStreamWithFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return path;
}

-(void)openDownloadAlertView
{
    alertProgressView = [[[AGAlertViewWithProgressbar alloc] initWithTitle:NSLocalizedString(@"Downloading video", nil) message:NSLocalizedString(@"Please wait...", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil] retain];
    [alertProgressView show];
    
    
    [operations setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         float progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
         alertProgressView.progress = progress*100;
     }];
    
}

-(void)downloadVideoFromServerWithPath:(NSString *)videoPath andVideoName:(NSString *)videoName
{
    
    if ([operations isExecuting] == YES)
    {
        UIAlertView *warningAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Warning!", nil)
                                                              message:NSLocalizedString(@"Your video is downloading already! Wait until it's done!", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil, nil];
        [warningAlert show];
        [warningAlert release];
        return;
    }
    
    operations = [[AFHTTPRequestOperation alloc] initWithRequest:[self getRequestFromURL:videoPath]];
    operations.outputStream = [NSOutputStream outputStreamToFileAtPath:[self getFileOutputStreamWithFileName:videoName] append:NO];;
    
    [self openDownloadAlertView];
    tempVideoPath = [videoName retain];
    [operations setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Path:%@ ", [self getFileOutputStreamWithFileName:videoName]);
        
        [delegate videoDownloaderDidFinishDownloadingWithValue:YES andPath:[self getFileOutputStreamWithFileName:videoName]];
        [alertProgressView hide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (![operation isCancelled])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil)
                                                           message:[NSString stringWithFormat:@"%@ %@",[error localizedDescription],NSLocalizedString(@"Please check your wi-fi or cellular internet connection!", nil)]
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [alertProgressView hide];
            
        }
       // [delegate videoDownloaderDidFinishDownloadingWithValue:NO andPath:[self getFileOutputStreamWithFileName:videoName]];
        [alertProgressView hide];
    }];
    
    [operations start];
}



-(void)startDownloadingFileWithisSelectedValue:(BOOL)isSelected
{
    
    
    if (isSelected == YES)
    {
        
        operations = [[AFHTTPRequestOperation alloc] initWithRequest:[self getRequestFromURL:MAIN_LINK]];
        operations.outputStream = [NSOutputStream outputStreamToFileAtPath:[self getFileOutputStream] append:NO];;
        
        // [self openDownloadAlertView];
        tempVideoPath = [[self getFileOutputStream] retain];
        
        [operations setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
         {
             float progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
             [delegate setProgressViewValue:progress];
         }];
        
        [operations setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        
            [delegate videoDownloaderDidFinishDownloadingZipFileWithValue:YES andPath:tempVideoPath];
            //  [alertProgressView hide];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (![operation isCancelled])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil)
                                                               message:[NSString stringWithFormat:@"%@ %@",[error localizedDescription],NSLocalizedString(@"Please check your wi-fi or cellular internet connection!", nil)]
                                                              delegate:self
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                //   [alertProgressView hide];
                
            }
            [delegate videoDownloaderDidFinishDownloadingZipFileWithValue:NO andPath:tempVideoPath];
            // [alertProgressView hide];
        }];
        
        [operations start];
        
    }
    else
    {
        
                [operations cancel];
                [[NSFileManager defaultManager]removeItemAtPath:tempVideoPath error:nil];
    }
}


-(void)pauseDownload
{
    [operations pause];
    
}

-(void)resumeDownload
{
    [operations resume];
    
}


//-(void)hideAlertView
//{
//    [alertProgressView hide];
//    
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [operations cancel];
        [[NSFileManager defaultManager]removeItemAtPath:[self getFileOutputStreamWithFileName:tempVideoPath] error:nil];
    }
}


-(void)hideAlertView
{
    [alertProgressView hide];
    
}

-(void)applicationHasBeenBackgrounded
{

    [operations setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        //[alertProgressView hide];
        [operations cancel];
    }];

}


-(void)applicationHasBeenForgrounded
{

    //[alertProgressView hide];
    NSLog(@"App did enter in forground");
    
}

- (void)dealloc
{
    [operations release];
    [super dealloc];
}
@end
