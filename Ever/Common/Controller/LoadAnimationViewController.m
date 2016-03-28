//
//  LoadAnimationViewController.m
//  Ever
//
//  Created by Mac on 15-5-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "LoadAnimationViewController.h"

@interface LoadAnimationViewController ()

@property(nonatomic,weak)UIImageView *imageView;

@end

@implementation LoadAnimationViewController



//开始加载
- (void)beignLoad{
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width-150)*0.5, (kScreen_Height-110)*0.5, 150, 110)];
    self.imageView=imageView;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    [window addSubview:imageView];
    
    UIImage *logo1=[UIImage imageNamed:@"qita_jiazai_1"];
    UIImage *logo2=[UIImage imageNamed:@"qita_jiazai_2"];
    UIImage *logo3=[UIImage imageNamed:@"qita_jiazai_3"];
    UIImage *logo4=[UIImage imageNamed:@"qita_jiazai_4"];
    UIImage *logo5=[UIImage imageNamed:@"qita_jiazai_5"];
    
    imageView.animationImages=[NSArray arrayWithObjects:logo1,logo2,logo3,logo4,logo5, nil];
    
    imageView.animationDuration=0.5;
    [imageView startAnimating];
}

//加载结束
- (void)loadFinish
{
 
    [self.imageView removeFromSuperview];
    
}


@end
