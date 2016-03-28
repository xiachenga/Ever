//
//  CustomTuSDKPFEditTurnAndCutView.m
//  Ever
//
//  Created by Mac on 15/6/14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomTuSDKPFEditTurnAndCutView.h"
#import <TuSDK/TuSDK.h>
//#import "CustomTurnAndCutBottomView.h"

@implementation CustomTuSDKPFEditTurnAndCutView

-(void)initView
{
    
    [super initView];
    
    // 修改底部工具栏背景
    self.bottomBar.backgroundColor = RGB(255,123,44);
    // 改变底部镜像按钮为向右旋转按钮
    // 隐藏镜像按钮
    self.bottomBar.mirrorButton.hidden = YES;
    
    UIButton *trunRightButton=[UIButton buttonWithFrame:self.bottomBar.mirrorButton.frame
                                    imageLSQBundleNamed:@"style_default_edit_button_trun_right"];
    [trunRightButton addTouchUpInsideTarget:self action:@selector(onImageTurnRightAction)];
    // 添加到视图
    [self.bottomBar addSubview:trunRightButton];
    
    
    //完成按钮
    UIButton *completeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [completeBtn setTitle:LOCALIZATION(@"ImageClipSucceed") forState:UIControlStateNormal];
    [completeBtn setBackgroundColor:kThemeColor];
    
    [completeBtn addTarget:self action:@selector(ImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.frame=CGRectMake(0, 0,50, 30);
    
    completeBtn.frame=self.bottomBar.completeButton.frame;
    
    [self.bottomBar addSubview:completeBtn];
    
    
//添加一个模仿导航栏
    
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    navView.backgroundColor=kThemeColor;
    [self addSubview:navView];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:LOCALIZATION(@"ImageClipCancel") forState:UIControlStateNormal];
  
    cancelBtn.frame=CGRectMake(kScreen_Width-70, 30, 70, 30);
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked)    forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];

    self.backButton.hidden=YES;

}


- (void)onImageTurnRightAction;
{
    [self.editImageView changeImage:lsqImageChangeTurnRight];
}

- (void)ImageCompleteAtion
{
    
    TuSDKPFEditTurnAndCutViewController *controller=(TuSDKPFEditTurnAndCutViewController*)[self viewController];
    [controller onImageCompleteAtion];
    
}

- (void)cancelBtnClicked
{
     TuSDKPFEditTurnAndCutViewController *controller=(TuSDKPFEditTurnAndCutViewController*)[self viewController];
    
    [controller dismissModalViewControllerAnimated];
    
  //  [controller dismissViewControllerAnimated:NO completion:^{
        
   // }];
    
    
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                         class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
