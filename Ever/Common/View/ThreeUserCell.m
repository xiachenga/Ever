//
//  ThreeUserCell.m
//  Ever
//
//  Created by Mac on 15-5-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ThreeUserCell.h"
#import "RankResult.h"
#import "PersonhomeViewController.h"
@interface ThreeUserCell ()

@property (nonatomic,weak)UITapImageView *avatarView;
@property (nonatomic , weak) UILabel *nickNameLbel;

@end
@implementation ThreeUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景
        UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
        bgView.userInteractionEnabled=YES;
        bgView.image=[UIImage imageNamed:@"paihangdaren_bg"];
        [self.contentView addSubview:bgView];
        
        
        //头像
        
        UITapImageView *avatarView=[[UITapImageView alloc]initWithFrame:CGRectMake((kScreen_Width-60)*0.5, 45, 60, 60)];
        [self.contentView addSubview:avatarView];
        self.avatarView=avatarView;
        
        [avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:30];
        
        UILabel *labelOne=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-25, CGRectGetMaxY(avatarView.frame)+5, 50, 18)];
        labelOne.text=@"NO.1";
        labelOne.textAlignment=NSTextAlignmentCenter;
        labelOne.font=[UIFont systemFontOfSize:18];
        labelOne.textColor=[UIColor whiteColor];
        [self.contentView addSubview:labelOne];
        
        UILabel *nickNameLabel=[[UILabel alloc]init];
        self.nickNameLbel=nickNameLabel;
        nickNameLabel.textColor=[UIColor whiteColor];
        [self.contentView addSubview:nickNameLabel];
        
    }
    return self;
}


- (void)setThreeUserArray:(NSArray *)threeUserArray
{
    _threeUserArray=threeUserArray;
    
    RankResult *rankOne=threeUserArray[0];
    
    NSURL *url=[NSURL URLWithString:rankOne.user_head_image_url ];
    [self.avatarView addTapBlock:^(id obj) {
        if ([self.delegate respondsToSelector:@selector(gotoPersonhomeWithUserid:)]) {
             [self.delegate gotoPersonhomeWithUserid:rankOne.user_id];
            
        }
       
    }];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
    self.nickNameLbel.text=[NSString stringWithFormat:@"%@ %d",rankOne.user_nickname,rankOne.score];
    CGSize nickNameSize=[self.nickNameLbel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    self.nickNameLbel.frame=(CGRect){{10,10},nickNameSize};
    
    for (int i=1; i<3; i++) {
        
        RankResult *rankResult=threeUserArray[i];
        [self addChildViewWith:rankResult frame:CGRectMake((i-1)*kScreen_Width*0.5, 150, kScreen_Width*0.5, 150) index:i];
    }
    
}

- (void)addChildViewWith:(RankResult *)rankResult frame:(CGRect)frame index:(int)index
{
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.userInteractionEnabled=YES;
    
    imageView.frame=frame;
    imageView.image=[UIImage resizedImageWithName:@"paihangbang_beijing"];
    [self.contentView addSubview:imageView];
    
    UILabel *nickName=[[UILabel alloc]init];
    nickName.text=[NSString stringWithFormat:@"%@ %d",rankResult.user_nickname,rankResult.score];
    nickName.textAlignment=NSTextAlignmentCenter;
    nickName.font=[UIFont systemFontOfSize:15];
    [imageView addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.top.mas_equalTo(imageView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width*0.5, 20));
        
    }];
    
    
    UITapImageView *avatarView=[[UITapImageView alloc]init];
    NSURL *url=[NSURL URLWithString:rankResult.user_head_image_url];
    [avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    [avatarView addTapBlock:^(id obj) {
        
        if ([self.delegate respondsToSelector:@selector(gotoPersonhomeWithUserid:)]) {
            [self.delegate gotoPersonhomeWithUserid:rankResult.user_id];
            
        }
        
    }];
    

    avatarView.frame=CGRectMake((kScreen_Width*0.5-60)*0.5, 45, 60, 60);
    [avatarView doCircleFrame];
    [imageView addSubview:avatarView];
    
    
    UILabel *label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:18];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=[NSString stringWithFormat:@"NO.%d",rankResult.rank_num];
    [imageView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width*0.5, 20));
        
    }];
    
    
    
    if (index==2) {
        
        UIImageView *lineView=[[UIImageView alloc]init];
        lineView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        lineView.frame=CGRectMake(kScreen_Width*0.5, 155, 0.5, 140);
        [self.contentView addSubview:lineView];
    }
    
}


@end
