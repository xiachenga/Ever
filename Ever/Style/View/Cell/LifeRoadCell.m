//
//  LifeRoadCell.m
//  Ever
//
//  Created by Mac on 15-4-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#define kPaddingleft 10

#import "LifeRoadCell.h"
#import "LifeResult.h"
#import "PersonhomeViewController.h"
@interface LifeRoadCell ()

@property (nonatomic,weak)UITapImageView *picture,*avatarView;

@property (nonatomic,weak)UILabel *timeLabel, *summary;

@property (nonatomic , weak) UIImageView *lineView,*bubbleView,*round;


@end
@implementation LifeRoadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        self.backgroundColor=[UIColor clearColor];
        
        UITapImageView *imageView=[[UITapImageView alloc]init];
        self.picture=imageView;
        [self.contentView addSubview:imageView];
        
        UITapImageView *avatarView=[[UITapImageView alloc]init];
        self.avatarView=avatarView;
        [self.contentView addSubview:avatarView];
        
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.font=[UIFont systemFontOfSize:12];
//        timeLabel.textColor=[UIColor grayColor];
        self.timeLabel=timeLabel;
        [self.contentView addSubview:timeLabel];
        
        //中间的线
        
        UIImageView *lineView=[[UIImageView alloc]init];
        lineView.backgroundColor=[UIColor colorWithHexString:@"e5e5dc"];
        [self.contentView addSubview:lineView];
        self.lineView=lineView;
        
        //线上的圆点
        UIImageView *round=[[UIImageView alloc]init];
        round.backgroundColor=[UIColor colorWithHexString:@"dcdcd2"];
        [self.contentView addSubview:round];
        self.round=round;
        
        
        UIImageView *bubbleView=[[UIImageView alloc]init];
        self.bubbleView=bubbleView;
        [self.contentView addSubview:bubbleView];
        
        
        UILabel *summary=[[UILabel alloc]init];
        self.summary=summary;
        [bubbleView addSubview:summary];
        
         
        }
    return self;
    
}


-(void)setLifeResult:(LifeResult *)lifeResult
{
    _lifeResult=lifeResult;
    NSString *string=lifeResult.image_url;
    NSURL *urlstring=[NSURL URLWithString:string];
    
    
    if (lifeResult.do_type==4||lifeResult.do_type==5) {
        
        self.picture.frame=CGRectMake(kScreen_Width*0.25-30, 20, 60, 60);
        [self.picture doCircleFrame];
        [self.picture sd_setImageWithURL:urlstring placeholderImage:[UIImage imageNamed:@"avatarholder"]];
        
        //时间
        
        self.timeLabel.text=self.lifeResult.create_time;
         CGSize timeLabelSize=[self.timeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 10)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        self.timeLabel.frame=CGRectMake(kScreen_Width*0.25-timeLabelSize.width*0.5, CGRectGetMaxY(self.picture.frame)+5,kScreen_Width*0.5-timeLabelSize.width, 10);
    
    }else
    {
        self.picture.frame=CGRectMake((kScreen_Width*0.5-100)*0.5, 10, 100, 100);
        [self.picture doCirclebead];
        [self.picture sd_setImageWithURL:urlstring placeholderImage:[UIImage imageNamed:@"pictureholder"]];
        
        
        self.timeLabel.text=self.lifeResult.create_time;
        
        CGSize timeLabelSize=[self.timeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 10)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        
        self.timeLabel.frame=CGRectMake(kScreen_Width*0.25-timeLabelSize.width*0.5, CGRectGetMaxY(self.picture.frame)+5,kScreen_Width*0.5-timeLabelSize.width, 10);
        
}
    
    self.lineView.frame=CGRectMake(kScreen_Width*0.5, 5,2,125);
    
    self.round.frame=CGRectMake(kScreen_Width*0.5-5, CGRectGetMaxY(self.lineView.frame)*0.5-5, 10, 10);
    [self.round doCircleFrame];
    
    
    
    self.summary.text=self.lifeResult.summary;
    self.summary.numberOfLines=0;
    self.summary.font=[UIFont systemFontOfSize:15];
    self.summary.textColor=[UIColor whiteColor];
    
    CGSize summarySize=[self.summary.text boundingRectWithSize:CGSizeMake(kScreen_Width*0.5-45, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;

    self.summary.frame=(CGRect){{20,20},summarySize};
    
    
    self.bubbleView.image=[UIImage resizedImageWithName:@"gerenguiji_duihuakuang"];
    self.bubbleView.frame=CGRectMake(kScreen_Width*0.5+10, 5+125*0.5-(summarySize.height+50)*0.5, summarySize.width+25, summarySize.height+50);
    
    
}




@end
