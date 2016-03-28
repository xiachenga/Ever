//
//  TalkTableViewCell.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "TalkTableViewCell.h"
#import "JournalIndexResult.h"
#import "UIImage+MJ.h"
#import "TalkTableViewFrame.h"


@interface TalkTableViewCell ()

@property (nonatomic,weak)UIImageView *avatarView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *timeLabel;
@property (nonatomic , weak) UILabel *contentLabel;
@property (nonatomic , weak) UIImageView *summaryImage;
@property (nonatomic , weak) UIImageView *cellbgView;

@end
@implementation TalkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.backgroundColor=[UIColor clearColor];
        
        //每条cell的背景颜色
        
        UIImage *image=[UIImage resizedImageWithName: @"dashehui_anniu_bai"];
        UIImageView *cellbgView=[[UIImageView alloc]init];
        cellbgView.layer.cornerRadius=5;
        cellbgView.layer.masksToBounds=YES;
        self.cellbgView=cellbgView;
        cellbgView.image=image;
        [self.contentView addSubview:cellbgView];
        
        
         //头像
        UIImageView *avatarView=[[UIImageView alloc]init];
        avatarView.layer.masksToBounds=YES;
        avatarView.layer.cornerRadius=20;
        self.avatarView=avatarView;
        [cellbgView addSubview:avatarView];
        
        //标题
        UILabel *titleLabel=[[UILabel alloc]init];
        self.titleLabel=titleLabel;
        titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
        titleLabel.numberOfLines=0;
        [cellbgView addSubview:titleLabel];
        
        //时间
        
        UILabel *timeLabel=[[UILabel alloc]init];
        self.timeLabel=timeLabel;
        timeLabel.font=[UIFont systemFontOfSize:14];
        timeLabel.textColor=[UIColor grayColor];
        [cellbgView addSubview:timeLabel];
        
        //摘要文字
        
        UILabel *contentLabel=[[UILabel alloc]init];
        self.contentLabel=contentLabel;
        contentLabel.numberOfLines=0;
        [cellbgView addSubview:contentLabel];
        
        //
        UIImageView *summaryImage=[[UIImageView alloc]init];
        self.summaryImage=summaryImage;
        [cellbgView addSubview:summaryImage];
        
        
        }
    return self;
    
    
}


-(void)setTalkFrame:(TalkTableViewFrame *)talkFrame
{
    _talkFrame=talkFrame;
    
    self.cellbgView.frame=talkFrame.backgroundViewF;
    
    //头像
    self.avatarView.frame=talkFrame.iconF;
    NSURL *imageUrl=[NSURL URLWithString:talkFrame.journalIndex.user_head_image_url];
    [self.avatarView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    
    //题目
    self.titleLabel.text=talkFrame.journalIndex.title_text_content;
    self.titleLabel.font=[UIFont systemFontOfSize:20];
    self.titleLabel.frame=talkFrame.titleF;
    
    //时间
    
    self.timeLabel.text=talkFrame.journalIndex.create_time;
    self.timeLabel.frame=talkFrame.timeF;
    
    
    //内容
    self.contentLabel.text=talkFrame.journalIndex.summary_content;
    self.contentLabel.font=[UIFont systemFontOfSize:15];
    self.contentLabel.frame=talkFrame.summaryF;
    
    
    
    if (talkFrame.journalIndex.summary_image_url !=nil && ![talkFrame.journalIndex.summary_image_url isEqualToString:@""] ) {
        
        self.summaryImage.hidden=NO;
    NSURL *imageUrl=[NSURL URLWithString:talkFrame.journalIndex.summary_image_url];
        [self.summaryImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"pictureholder"]];
        self.summaryImage.frame=talkFrame.imageF;
        
        
    }else
    {
        self.summaryImage.hidden=YES;
    }
    
}

@end
