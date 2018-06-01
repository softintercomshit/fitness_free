//
//  FirstGuideMaster.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/12/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDownloader.h"
#import "UnZipper.h"

@interface FirstGuideMaster : UIViewController<UITableViewDelegate,UITableViewDataSource,VideoDownloaderDelegate,UnZipperDelegate,UIAlertViewDelegate>
{
    
    UITableView * tableViews;
    NSMutableDictionary *selectedIndexes;
    BOOL isUnziping;
    BOOL isDownloading;
    int actionType;
}

@end
