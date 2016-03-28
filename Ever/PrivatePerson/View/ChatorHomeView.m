//
//  ChatorHomeView.m
//  Ever
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ChatorHomeView.h"
#import "UserRelationResult.h"
@interface ChatorHomeView ()
@property(nonatomic,weak) UIImageView *avatarView,*imageView;
@property (nonatomic , weak) UILabel *nameLabel,*everLabel,*meiliLabel;

@end

@implementation ChatorHomeView

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        
        UIView *bgView=[[UIView alloc]initWithFrame:self.bounds];
        bgView.backgroundColor=[UIColor blackColor];
        bgView.alpha=0.2;
        [self addSubview:bgView];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, -(kScreen_Width-40), kScreen_Width-40, kScreen_Width-40)];
        imageView.userInteractionEnabled=YES;
        self.imageView=imageView;
        imageView.image=[UIImage imageNamed:@"tongxunlu_tiaozhuanye"];
        
        [self addSubview:imageView];
        
        //头像
        UIImageView *avatarView=[[UIImageView alloc]init];
        self.avatarView=avatarView;
        [imageView addSubview:avatarView];
        
        //名字
        UILabel *nameLabel=[[UILabel alloc]init];
        self.nameLabel=nameLabel;
        [imageView addSubview:nameLabel];
        
        //EVer值
        UILabel *everLabel=[[UILabel alloc]init];
        self.everLabel=everLabel;
        [imageView addSubview:everLabel];
        
        //魅力值
        UILabel *meiliLabel=[[UILabel alloc]init];
        self.meiliLabel=meiliLabel;
        [imageView addSubview:meiliLabel];
        
        //关闭按钮
        UIButton *shutBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [shutBtn setImage:[UIImage imageNamed:@"guanbi_btn"] forState:UIControlStateNormal];
        [shutBtn setImage:[UIImage imageNamed:@"guanbi_btn_selected"] forState:UIControlStateHighlighted];
        shutBtn.frame=CGRectMake(kScreen_Width-40-30, 5, 25, 25);
        shutBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [shutBtn addTarget:self action:@selector(shutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:shutBtn];
        
        
        UIButton *chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chatBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        chatBtn.layer.cornerRadius=5;
        [chatBtn setTitle:LOCALIZATION(@"Chat") forState:UIControlStateNormal];
        [chatBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        chatBtn.tag=10;
        [self.imageView addSubview:chatBtn];
        [chatBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_centerX).with.offset(-10);
            make.bottom.mas_equalTo(self.imageView.mas_bottom).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 25));
            
        }];
    
        UIButton *homeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.frame=CGRectMake((kScreen_Width-40)*0.5+15, kScreen_Width-40-50, 30, 15);
        homeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        homeBtn.layer.cornerRadius=5;
        [homeBtn setTitle:LOCALIZATION(@"Home") forState:UIControlStateNormal];
        [homeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        homeBtn.tag=20;
        [homeBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self.imageView addSubview:homeBtn];
        
        [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX).with.offset(10);
            make.bottom.mas_equalTo(self.imageView.mas_bottom).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 25));
            
        }];
        
        
        
    }
    return self;
    
}

-(void)setUser:(UserRelationResult *)user
{
    
    _user=user;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:user.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_top).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        
    }];
   
    [self.avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:30];
    
    //昵称
    self.nameLabel.text=user.user_nickname;
    CGSize nameLabelSize=[self.nameLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-40, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.nameLabel.font=[UIFont systemFontOfSize:20];
    self.nameLabel.textColor=[UIColor whiteColor];
    

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.avatarView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(nameLabelSize);
        
    }];
    
    //Ever值
    
    self.everLabel.text=[NSString stringWithFormat:@"%ld",user.user_id];
    self.everLabel.font=[UIFont systemFontOfSize:18];
    CGSize everLabelSize=[self.everLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-40, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.everLabel.textColor=[UIColor whiteColor];

    [self.everLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
       
        make.size.mas_equalTo(CGSizeMake(everLabelSize.width, 20));
        
    }];
       //魅力值
    
    NSString *meiLiString=LOCALIZATION(@"Charm");
    self.meiliLabel.text=[NSString stringWithFormat:@"%@ %d",meiLiString,user.meilinum];
    self.meiliLabel.font=[UIFont systemFontOfSize:18];
    CGSize meiliLabelSize=[self.meiliLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-40, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.meiliLabel.textColor=[UIColor whiteColor];
    
    [self.meiliLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(meiliLabelSize);
        make.top.mas_equalTo(self.everLabel.mas_bottom);
        
    }];

    
}

-(void)show{
    
  [UIView animateWithDuration:0.5 animations:^{
      
      UIWindow *window=[UIApplication sharedApplication].keyWindow;
      self.frame=window.frame;
      [window addSubview:self];
    
      
       self.imageView.transform=CGAffineTransformMakeTranslation(0, kScreen_Width-40+(window.height-kScreen_Width+40)/2);
      
      
      
  } completion:^(BOOL finished) {
      
  }];
    
    
}


- (void)shutBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.imageView.transform=CGAffineTransformIdentity;
        
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (void)buttonClicked:(UIButton *)button
{
    [self shutBtnClicked];
    
    if ([self.delegate respondsToSelector:@selector(chatOrHomeBtnClicked:withUser:)]) {
        [self.delegate chatOrHomeBtnClicked:button withUser:self.user];
    }
    
    
    
}

@end
