//
//  CustomTextView.m
//  Ever
//
//  Created by Mac on 15-3-13.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView ()
@property (nonatomic,weak)UILabel *placeholderLabel;

@end

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        //添加一个提醒文字的label(显示占位文字的label)
        UILabel *placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, kScreen_Width-20, 20)];
        placeholderLabel.numberOfLines=0;
        placeholderLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:placeholderLabel];
        self.placeholderLabel=placeholderLabel;
        
        //设置默认的占位文字颜色
        self.placeholderColor=[UIColor lightGrayColor];
        
        //设置默认的字体
        self.font=[UIFont systemFontOfSize:16];
        
        //监听内部文字的改变
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

//释放通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//监听文字改变
- (void)textDidChange
{
    self.placeholderLabel.hidden=(self.text.length!=0);
}



- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder=[placeholder copy];
    self.placeholderLabel.text=placeholder;
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor=placeholderColor;
    self.placeholderLabel.textColor=placeholderColor;
    
}


-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font=font;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.placeholderLabel.y = 5;
//    self.placeholderLabel.x = 5;
//    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
//    // 根据文字计算label的高度
//    CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
//    CGSize placehoderSize = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//    
//    self.placeholderLabel.height = placehoderSize.height;
}
@end
