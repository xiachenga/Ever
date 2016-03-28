//
//  DianzanDynamicCell.m
//  Ever
//
//  Created by Mac on 15-5-25.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "DianzanDynamicCell.h"
#import "DianzanDynamicResult.h"
#import "GuanzhuResult.h"
@interface DianzanDynamicCell ()
@property (nonatomic,weak)UIImageView *avatarView;
@property (nonatomic , weak) UITapImageView *jiahaoView;
@property (nonatomic , weak) UILabel *nameLabel,*descLabel,*timeLabel;

@end


@implementation DianzanDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //头像
        UIImageView *avatarView=[[UIImageView alloc]init];
        self.avatarView=avatarView;
        [self.contentView addSubview:avatarView];
        
        //昵称
        UILabel *nameLabel=[[UILabel alloc]init];
        self.nameLabel=nameLabel;
        [self.contentView addSubview:nameLabel];
        
        //时间
        UILabel *timeLabel=[[UILabel alloc]init];
        self.timeLabel=timeLabel;
        [self.contentView addSubview:timeLabel];
        
        //描述
        UILabel *descLabel=[[UILabel alloc]init];
        self.descLabel=descLabel;
        [self.contentView addSubview:descLabel];
        
        UITapImageView *jiahaoView=[[UITapImageView alloc]init];
        self.jiahaoView=jiahaoView;
        [self.contentView addSubview:jiahaoView];
        
    }
    
    return self;
}

-(void)setDynamicResult:(DianzanDynamicResult *)dynamicResult
{
    
    _dynamicResult=dynamicResult;
    
    //头像
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:dynamicResult.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
    self.avatarView.frame=CGRectMake(5, 10, 40, 40);
    [self.avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:20];
    
    //昵称
    self.nameLabel.text=dynamicResult.user_nickname;
    self.nameLabel.font=[UIFont systemFontOfSize:15];
    CGSize nameLabelSize=[self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.nameLabel.frame=(CGRect){{CGRectGetMaxX(self.avatarView.frame)+5, CGRectGetMinY(self.avatarView.frame)},nameLabelSize};
    
    
    
    //时间
    
    self.timeLabel.text=dynamicResult.create_time;
    self.timeLabel.font=[UIFont systemFontOfSize:12];
    self.timeLabel.frame=CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+10, CGRectGetMinY(self.nameLabel.frame)+5, kScreen_Width-5-10-5-40-nameLabelSize.width, 12);
    
    
    //赞的内容
    self.descLabel.text=[NSString stringWithFormat:@"赞了你的%@",dynamicResult.type_name];
    self.descLabel.font=[UIFont systemFontOfSize:15];
    self.descLabel.textColor=[UIColor grayColor];
    self.descLabel.frame=CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame)+10, kScreen_Width-5-5-40, 15);
    
    //加号图片
    if (!dynamicResult.if_friend) {
        
      
        self.jiahaoView.image=[UIImage imageNamed:@"tongxunlu_tianjia"];
    
        
    }else
    {
         self.jiahaoView.image=[UIImage imageNamed:@"tongxunlu_yitianjia"];
         self.jiahaoView.userInteractionEnabled=NO;
    }
    
//    [self.jiahaoView addTapBlock:^(id obj) {
//        
//        [self gotoFriends:(long)dynamicResult.user_id withImageView:(UIImageView *)self.jiahaoView];
//        
//    }];

    
    self.jiahaoView.frame=CGRectMake(kScreen_Width-40, 12, 36, 36);

   

}

- (void)gotoFriends:(long)userid withImageView:(UIImageView *)imageView
{
     NSString *string=[NSString stringWithFormat:@"user/guanzhu/%ld",userid];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        
        if (responseobj!=nil) {
            
            GuanzhuResult *result=[GuanzhuResult objectWithKeyValues:responseobj];
            [MBProgressHUD showError:result.prompt];
            
            if (result.if_success) {
                
                if (result.guanzhu_status==-1) {
                    imageView.image=[UIImage imageNamed:@"tongxunlu_tianjia"];
                
                }else{
                    imageView.image=[UIImage imageNamed:@"tongxunlu_yitianjia"];
                    
                }
            }
            
        }
        
        
         
        
    } failure:^(NSError *erronr) {
        
    }];
    
    
}
@end
