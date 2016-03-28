//
//  ReplayDynamicCell.m
//  Ever
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ReplayDynamicCell.h"
#import "ReplayDynamicResult.h"
@interface ReplayDynamicCell ()

@property (nonatomic,weak)UIImageView *avatarView;

@property (nonatomic , weak) UILabel *nickName,*time,*comment;

@end

@implementation ReplayDynamicCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView *avatarView=[[UIImageView alloc]init];
        [self.contentView addSubview:avatarView];
        self.avatarView=avatarView;
        
        //昵称
        UILabel *nickName=[[UILabel alloc]init];
        [self.contentView addSubview:nickName];
        self.nickName=nickName;
        
        //时间
        UILabel *time=[[UILabel alloc]init];
        [self.contentView addSubview:time];
        self.time=time;
        
    
        //评论
        UILabel *comment=[[UILabel alloc]init];
        [self.contentView addSubview:comment];
        self.comment=comment;
        

    }
    return self;
}

-(void)setReplayResult:(ReplayDynamicResult *)replayResult
{
    CGFloat leftPadding=10;
    CGFloat topPadding=10;
    _replayResult=replayResult;
    
    NSURL *url=[NSURL URLWithString:replayResult.his_head_image_url];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    [self.avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:25];
    self.avatarView.frame=CGRectMake(leftPadding,leftPadding/2, 50, 50);
  //  [self.avatarView doCircleFrame];
    
    //昵称
    self.nickName.text=replayResult.his_nickname;
    self.nickName.font=[UIFont systemFontOfSize:18];
    self.nickName.frame=CGRectMake(CGRectGetMaxX(self.avatarView.frame)+10, CGRectGetMinY(self.avatarView.frame)+5, kScreen_Width-10-CGRectGetMaxX(self.avatarView.frame), 18);
    //评论的时间
    self.time.text=replayResult.create_time;
    self.time.font=[UIFont systemFontOfSize:15];
    self.time.textColor=[UIColor grayColor];
    self.time.frame=CGRectMake(CGRectGetMinX(self.nickName.frame), CGRectGetMaxY(self.nickName.frame)+10, kScreen_Width-10-CGRectGetMaxX(self.avatarView.frame), 15);
    
    
    //评论的内容
    self.comment.text=replayResult.replay_content;
    self.comment.font=[UIFont systemFontOfSize:15];
    
    self.comment.frame=CGRectMake(CGRectGetMinX(self.avatarView.frame), CGRectGetMaxY(self.avatarView.frame)+10, kScreen_Width-leftPadding, 18);
    
    //背景图
    UIImageView *bgimageView=[[UIImageView alloc]initWithFrame:CGRectMake(leftPadding/2, CGRectGetMaxY(self.comment.frame)+10, kScreen_Width-leftPadding, 115)];
    bgimageView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:bgimageView];
    
    ////图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(leftPadding/2, leftPadding/2, 100, 100)];
    NSURL *imageUrl=[NSURL URLWithString:replayResult.image_url] ;
    [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"pictureholder"]];
    [bgimageView addSubview:imageView];
    
    UILabel *title;
    if (replayResult.type==5) {
        title=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, topPadding, 100, 20)];
        title.text=@"我的照片";
        title.font=[UIFont systemFontOfSize:15];
        [bgimageView addSubview:title];
    }else if (replayResult.type==3){
        
        title=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, topPadding, 100, 20)];
        title.text= replayResult.title;
        [bgimageView addSubview:title];
    }
    //标题

    //内容
    UILabel *originalText=[[UILabel alloc]init];
    originalText.font=[UIFont systemFontOfSize:15];
    originalText.numberOfLines=0;
    originalText.textColor=[UIColor grayColor];
 
    originalText.text=replayResult.summary;
    
    CGSize originalTextSize=[replayResult.summary boundingRectWithSize:CGSizeMake(kScreen_Width-CGRectGetMaxX(imageView.frame)-leftPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    originalText.frame=(CGRect){{CGRectGetMaxX(imageView.frame)+5,CGRectGetMaxY(title.frame)+5},originalTextSize};
   
    [bgimageView addSubview:originalText];
    
}

@end
