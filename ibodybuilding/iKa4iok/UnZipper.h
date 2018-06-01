//
//  UnZipper.h
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 6/7/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

@protocol UnZipperDelegate <NSObject>

-(void)setUnZipProgressInPercents:(int)zipPercents andNumOfFiles:(int)numberOfFiles andFilePath:(NSString *)filePath;
-(void)didFinishedUnZipingFileWithValue:(BOOL)isUnZiped;

@end


@interface UnZipper : NSObject


@property(nonatomic, assign)id <UnZipperDelegate>delegate;
+(UnZipper*) instance;
-(void)startUnZipingWithFilePath:(NSString *)zipFilePath;

@end
