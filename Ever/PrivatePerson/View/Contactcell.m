//
//  Contactcell.m
//  Ever
//
//  Created by Mac on 15-4-23.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "Contactcell.h"
#import "UserRelationResult.h"
@interface Contactcell ()

@property (nonatomic,weak)UILabel *nickName;

@end

@implementation Contactcell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        //添加子控件
        UITapImageView *avatarView=[[UITapImageView alloc]init];
       
        [self.contentView addSubview:avatarView];
        self.avatarView=avatarView;
        
        //昵称
        UILabel *nickName=[[UILabel alloc]init];
        self.nickName=nickName;
        [self.contentView addSubview:nickName];
        
        //通知的红点
        UIImageView *redDotView=[[UIImageView alloc]initWithFrame:CGRectMake(55,0,8,8)];
        [redDotView doCircleFrame];
        self.redDotView=redDotView;
        redDotView.hidden=YES;
        redDotView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:redDotView];
        
    }
    return self;
}


-(void)setGuanzhu:(UserRelationResult *)guanzhu{
    
    _guanzhu=guanzhu;
    
    NSURL *url=[NSURL URLWithString:guanzhu.user_head_image_url];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    self.avatarView.frame=CGRectMake(self.width*0.5-25, 0, 50, 50);
    [self.avatarView doCircleFrame];
    
    self.nickName.text=guanzhu.user_nickname;
    self.nickName.numberOfLines=0;
    self.nickName.font=[UIFont systemFontOfSize:15];
    CGSize nickNameSize=[self.nickName.text boundingRectWithSize:CGSizeMake(kScreen_Width*0.25-8, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.nickName.frame=CGRectMake(3,CGRectGetMaxY(self.avatarView.frame)+5, kScreen_Width*0.25-14,nickNameSize.height);
     self.nickName.textAlignment=NSTextAlignmentCenter;
    
   
}

- (void)setShowRedDotView:(BOOL)showRedDotView {
    
    _showRedDotView=showRedDotView;
    
    self.redDotView.hidden=!showRedDotView;
    
    
}


@end
