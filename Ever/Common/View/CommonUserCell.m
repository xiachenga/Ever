//
//  CommonUserCell.m
//  Ever
//
//  Created by Mac on 15-5-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CommonUserCell.h"
#import "RankResult.h"

@interface CommonUserCell ()
@property (nonatomic,weak)UILabel *frontNum;
@property (nonatomic , weak) UILabel *behindNum;
@property (nonatomic , weak) UIImageView *avatarView;
@property (nonatomic , weak) UILabel *nickNameLabel;

@end
@implementation CommonUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //前面的ranking
        UILabel *frontNum=[[UILabel alloc]init];
        frontNum.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:frontNum];
        self.frontNum=frontNum;
        
        //头像
        UIImageView *avatarView=[[UIImageView alloc]init];
        [self.contentView addSubview:avatarView];
        self.avatarView=avatarView;
        
        UILabel *nickNameLabel=[[UILabel alloc]init];
        [self.contentView addSubview:nickNameLabel];
        self.nickNameLabel.font=[UIFont systemFontOfSize:18];
        self.nickNameLabel=nickNameLabel;
        
        
        //后面的ranking
        UILabel *behindNum=[[UILabel alloc]init];
        behindNum.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:behindNum];
        self.behindNum=behindNum;
    }
    return self;
}


-(void)setRankResult:(RankResult *)rankResult
{
    _rankResult=rankResult;
    
    self.frontNum.text=[NSString stringWithFormat:@"%d",rankResult.rank_num];
    CGFloat leftPadding=10;
    CGFloat topPadding=20;
    self.frontNum.frame=CGRectMake(leftPadding, topPadding, 30, 15);
    
    NSURL *url=[NSURL URLWithString:rankResult.user_head_image_url];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    self.avatarView.frame=CGRectMake(CGRectGetMaxX(self.frontNum.frame), 5, 40, 40);
    [self.avatarView doCircleFrame];
    
    self.nickNameLabel.text=rankResult.user_nickname;
    CGSize nickNameLabelSize=[self.nickNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    self.nickNameLabel.frame=(CGRect){{CGRectGetMaxX(self.avatarView.frame)+5,15},nickNameLabelSize};
    
    self.behindNum.text=[NSString stringWithFormat:@"%d",rankResult.score];
    self.behindNum.frame=CGRectMake(kScreen_Width-leftPadding-40, topPadding, 40, 18);
    
}

@end
