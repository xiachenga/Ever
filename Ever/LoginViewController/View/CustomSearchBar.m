//
//  CustomSearchBar.m
//  自定义SearchBar
//
//  Created by Mac on 15-3-26.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomSearchBar.h"

@interface CustomSearchBar ()

@property (nonatomic,weak)UIImageView *leftImage;

@end

@implementation CustomSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        //设置背景
        UIImage *image=[UIImage imageNamed:@"tanlun_wenbenkuang"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        self.background=image;
        
        
        //设置内容--垂直居中
        self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        
        //设置左边显示一个放大镜
        UIImageView *leftImage=[[UIImageView alloc]init];
        
        leftImage.frame=CGRectMake(0, 0, leftImage.image.size.width+40, leftImage.image.size.height);
        self.leftImage=leftImage;
        
        leftImage.contentMode=UIViewContentModeCenter;
        self.leftView=leftImage;
        
        //设置左边的view永远显示
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    return self;
        
}


-(void)setLeftImageName:(NSString *)leftImageName
{
    self.leftImage.image=[UIImage imageNamed:leftImageName];
    
}


+(instancetype)searchBar
{
    
    return [[self alloc]init];
    
    
}


@end
