//
//  CustomReleaseView.m
//  Ever
//
//  Created by Mac on 15-3-19.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomReleaseView.h"


@interface CustomReleaseView ()

@property(weak,nonatomic)UIView *releaseView;

@end

@implementation CustomReleaseView



- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor=[UIColor grayColor];
        self.alpha=0.5;
       
    
        
        //发表格调按钮
        UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [releaseButton setFrame:CGRectMake(80, kScreen_Height-200, 30, 30)];
        [releaseButton setImage:[UIImage imageNamed:@"zhedie_fabu_gediao"] forState:UIControlStateNormal];
        [releaseButton setImage:[UIImage imageNamed:@"zhedie_fabu_gediao_selected"] forState:UIControlStateHighlighted];
        releaseButton.adjustsImageWhenDisabled=NO;
        [releaseButton addTarget:self action:@selector(releaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:releaseButton];
        UILabel *releaseLabel=[[UILabel alloc]init];
        releaseLabel.frame=CGRectMake(68, CGRectGetMaxY(releaseButton.frame), 100, 25);
        releaseLabel.font=[UIFont boldSystemFontOfSize:14];
        releaseLabel.text=@"发表格调";
        releaseLabel.textColor=[UIColor whiteColor];
        [self addSubview:releaseLabel];
        
        
        UIButton *TalkButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [TalkButton setFrame:CGRectMake(kScreen_Width-80-30, kScreen_Height-200, 30, 30)];
        TalkButton.adjustsImageWhenDisabled=NO;
        [TalkButton setImage:[UIImage imageNamed:@"zhedie_fabu_tanlun"] forState:UIControlStateNormal];
        [TalkButton setImage:[UIImage imageNamed:@"zhedie_fabu_tanlun_selected"] forState:UIControlStateHighlighted];
        [TalkButton addTarget:self action:@selector(talkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:TalkButton];
        
        UILabel *talkLabel=[[UILabel alloc]init];
        talkLabel.frame=CGRectMake(CGRectGetMinX(TalkButton.frame)-14 , CGRectGetMaxY(releaseButton.frame), 100, 25);
        talkLabel.font=[UIFont boldSystemFontOfSize:14];
        talkLabel.text=@"发表谈论";
        talkLabel.textColor=[UIColor whiteColor];
        [self addSubview:talkLabel];
        
       
        
    }
    
    return self;
    
}

- (void)dismiss
{
    [self removeFromSuperview];
    
}

- (void)show
{
    
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    self.frame=window.bounds;
    [window addSubview:self];
}



- (void)releaseButtonClicked
{

    if ([self.delegate respondsToSelector:@selector(selectReleaseStyle)]) {
        [self.delegate selectReleaseStyle];
    }
    
    [self dismiss];
}




- (void)talkButtonClicked
{
    
    if ([self.delegate respondsToSelector:@selector(selectReleaseTalk)]) {
        [self.delegate selectReleaseTalk];
        
    }
    [self dismiss];
}
 

@end
