//
//  WorkoutCell.m
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/16/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "WorkoutCell.h"

@implementation WorkoutCell

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

    [_editButton release];
    [_titleLabel release];
    [super dealloc];
}
@end
