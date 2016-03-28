//
//  CustomPopbottomView.m
//  Ever
//
//  Created by Mac on 15-4-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomPopbottomView.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"

@implementation CustomPopbottomView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor blackColor];
        
        [self addChildView];
        
    }
    return self;
    
}

- (void)addChildView
{
    //
    UIButton *phoneBtn=[self buttonWithTitle:@"手机登录" image:@"login_phone"];
    phoneBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
//    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 5);
    phoneBtn.tag=1;
    phoneBtn.frame=CGRectMake(0, 0, kScreen_Width, 40);
    [phoneBtn addLineUp:NO andDown:YES];
    
    
    //qq
    UIButton *qqBtn=[self buttonWithTitle:@"QQ登录" image:@"login_QQ"];
    qqBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 15);
    qqBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 5);
    qqBtn.tag=2;
    qqBtn.frame=CGRectMake(0, CGRectGetMaxY(phoneBtn.frame)+5, kScreen_Width, 40);
    
    [qqBtn addLineUp:NO andDown:YES];

   //微信
    UIButton *weixinBtn=[self buttonWithTitle:@"微信登录" image:@"login_weixin"];
    weixinBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    weixinBtn.frame=CGRectMake(0, CGRectGetMaxY(qqBtn.frame)+5, kScreen_Width, 40);
    weixinBtn.tag=3;
    [weixinBtn addLineUp:NO andDown:YES];
    
    //微博
    UIButton *weiboBtn=[self buttonWithTitle:@"微博登录" image:@"login_weibo"];
    weiboBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    weiboBtn.frame=CGRectMake(0, CGRectGetMaxY(weixinBtn.frame)+5, kScreen_Width, 40);
    weiboBtn.tag=4;
    [weiboBtn addLineUp:NO andDown:YES];

    
    UIButton *cancelBtn=[self buttonWithTitle:@"取消" image:nil];
    cancelBtn.frame=CGRectMake(0, CGRectGetMaxY(weiboBtn.frame)+5,kScreen_Width, 40);
    cancelBtn.tag=5;
    
}


-(void)showPopView
{
    //添加菜单整体到窗口身上
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    self.width=kScreen_Width;
    self.height=215;
    self.x=0;
    self.y=kScreen_Height;
    [window addSubview:self];
    
    
    CGFloat duration=0.5;
     [UIView animateWithDuration:duration animations:^{
         
         self.transform=CGAffineTransformMakeTranslation(0, -self.height);
         
     }];
    
}


- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform=CGAffineTransformIdentity;
        
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)image
{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)buttonClicked:(UIButton *)button
{
    [self dismiss];
    
    if ([self.deletate respondsToSelector:@selector(didSelected:)]) {
        [self.deletate didSelected:button];
        
    }
}







    
    
    
    
    



@end
