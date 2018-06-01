//
//  CusomScrollViewCell.m
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 10/15/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "CusomScrollViewCell.h"

@implementation CusomScrollViewCell

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
    [_scrollView release];
    [_dateLabel release];
    [super dealloc];
}
@end
