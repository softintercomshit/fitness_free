//
//  VideoDownloader.h
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 6/3/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AGAlertViewWithProgressbar.h"

@protocol VideoDownloaderDelegate <NSObject>
@optional
-(void)videoDownloaderDidFinishDownloadingWithValue:(BOOL)downloadValue andPath:(NSString *)filePath;

-(void)videoDownloaderDidFinishDownloadingZipFileWithValue:(BOOL)downloadValue andPath:(NSString *)filePath;
-(void)setProgressViewValue:(float)progressValue;

@end


@interface VideoDownloader : NSObject<UIAlertViewDelegate>
{
    
    AFHTTPRequestOperation      *operations;
    AGAlertViewWithProgressbar  *alertProgressView;
}

+(VideoDownloader*) instance;
@property(nonatomic, assign)id <VideoDownloaderDelegate>delegate;
@property (nonatomic, retain)NSString *tempVideoPath;

-(void)applicationHasBeenBackgrounded;
-(void)applicationHasBeenForgrounded;
-(void)startDownloadingFileWithisSelectedValue:(BOOL)isSelected;
-(void)downloadVideoFromServerWithPath:(NSString *)videoPath andVideoName:(NSString *)videoName;
-(void)hideAlertView;
-(void)resumeDownload;
-(void)pauseDownload;
@end
