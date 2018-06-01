//
//  DescriptionViewController.h
//  iBodybuilding
//
//  Created by Johnny Bravo on 1/18/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol descriptionProtocol <NSObject>

-(void)getDescriptionString:(NSString *)exDescription;

@end


@interface DescriptionViewController : UIViewController

@property (nonatomic,assign) id<descriptionProtocol>delegate;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) NSString *descriptionString;
@end
