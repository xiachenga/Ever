//
//  DatePickerView.h
//  Ever
//
//  Created by Mac on 15/7/10.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerView;
@protocol DatePickerViewDelegate <NSObject>

-(void)datePickerView:(DatePickerView *)datePickerView didSelectTime:(NSString *)time;

@end

@interface DatePickerView : UIView

@property (nonatomic , weak) id<DatePickerViewDelegate> delegate;

@property (nonatomic , weak)  UIDatePicker *datePicker;

-(instancetype)initDateViewWithFrame:(CGRect)Frame WithDateType:(UIDatePickerMode)dateType;

@end
