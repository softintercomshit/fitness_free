//
//  DownloadCell.h
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 6/6/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *headerLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (retain, nonatomic) IBOutlet UILabel *progressTitleLabel;
@end
