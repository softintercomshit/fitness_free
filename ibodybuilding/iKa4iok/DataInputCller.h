//
//  DataInputCller.h
//  iBodybuilding
//
//  Created by Johnny Bravo on 12/28/12.
//  Copyright (c) 2012 com.softintercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputDataProtocol <NSObject>

-(void)getTextFieldData:(NSString *)data withTextFieldType:(BOOL)textFieldType;
@optional
-(void)getTextFieldData:(NSString *)data isRepetition:(BOOL)isRepetition;

@end


@interface DataInputCller : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    BOOL isDays;

}

@property (nonatomic,assign) id<InputDataProtocol>delegate;

@property (retain, nonatomic) IBOutlet UITextField *sessionTextField;
@property (retain, nonatomic) IBOutlet UIPickerView *dayPicker;
@property (retain, nonatomic) NSString *stringText;
@property (retain, nonatomic) NSString *numberStr;

@property (nonatomic, readwrite) int isRepetition;
@property (nonatomic, readwrite) int isTitle;
@property (nonatomic, readwrite) int isOtherType;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andInputType:(BOOL)yesOrNo;
@end
