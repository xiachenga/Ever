//
//  DatePickerView.m
//  Ever
//
//  Created by Mac on 15/7/10.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()

@property(nonatomic,weak) UIControl *control;
@end

@implementation DatePickerView


-(instancetype)initDateViewWithFrame:(CGRect)Frame WithDateType:(UIDatePickerMode)dateType{
    self=[super initWithFrame:Frame];
    if (self) {
        
        UIControl *control=[[UIControl alloc]initWithFrame:Frame];
        control.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
        [self addSubview:control];
        self.control=control;
        [control addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreen_Height-250, kScreen_Width, 50)];
        toolbar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        UIBarButtonItem *itemCancelDone=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(actionConfirm:)];
        
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolbar setItems:[NSArray arrayWithObjects:itemCancel,space,itemCancelDone, nil]];
        [control addSubview:toolbar];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.date = [NSDate date];
        datePicker.datePickerMode=dateType;
        datePicker.frame = CGRectMake(0, kScreen_Height - 200, kScreen_Width, 220);
        self.datePicker=datePicker;
        
        [control addSubview:datePicker];
        
    }
    
   
    
    return self;
    
    
}



-(void)actionCancel:(id)sender
{
    [self removeFromSuperview];
    
}


- (void)actionConfirm:(id)sender
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置日期的时间格式
    
    if (self.datePicker.datePickerMode==UIDatePickerModeTime) {
        dateFormatter.dateFormat=@"HH:mm";
    }else{
        dateFormatter.dateFormat=@"yyyy-MM-dd";
        
    }
    
   
    NSString *dateTime=[dateFormatter stringFromDate:self.datePicker.date];
    
    if ([self.delegate respondsToSelector: @selector(datePickerView:didSelectTime:)]) {
        
        [self.delegate datePickerView:self didSelectTime:dateTime];
    }
    
    [self removeFromSuperview];
}





@end
