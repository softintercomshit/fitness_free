//
//  CustomCell.h
//  iKa4iok
//
//  Created by Johnny Bravo on 11/12/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXImageView.h"
@interface CustomCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet FXImageView *fxImageView;

@end
