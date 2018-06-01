//
//  UnZipper.m
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 6/7/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "UnZipper.h"

@implementation UnZipper
@synthesize delegate;

static UnZipper *instance_;

static void singleton_remover() {
    
    [instance_ release];
}

+ (UnZipper*)instance {
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

-(void)startUnZipingWithFilePath:(NSString *)zipFilePath
{
    if ([NSThread currentThread].isMainThread)
    {
        [self performSelectorInBackground:@selector(startUnZipingWithFilePath:) withObject:zipFilePath];
        return;
    }
    ZipArchive *zip = [[ZipArchive alloc] init];
    
    ZipArchiveProgressUpdateBlock progressBlock = ^ (int percentage, int filesProcessed, int numFiles) {
       
        [delegate setUnZipProgressInPercents:percentage andNumOfFiles:filesProcessed andFilePath:zipFilePath];

    };
    
    zip.progressBlock = progressBlock;

    //open file
    [zip UnzipOpenFile:zipFilePath];
    
    //unzip file to
    [zip UnzipFileTo:[zipFilePath stringByDeletingLastPathComponent] overWrite:YES];

}

@end
