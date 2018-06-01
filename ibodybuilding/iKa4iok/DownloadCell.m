//
//  DownloadCell.m
//  iBodybuilding-Update
//
//  Created by Johnny Bravo on 6/6/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_progressTitleLabel release];
    [_downloadProgressView release];
    [_headerLabel release];
    [super dealloc];
}
@end
