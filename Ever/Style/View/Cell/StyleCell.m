//
//  StyleCell.m
//  Ever
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "StyleCell.h"
#import "WorldTagIndexResult.h"


@interface StyleCell ()


@property (nonatomic , weak) UILabel  *zanLabel,*commentLabel,*nicknameLabel;

@property (nonatomic , weak)  UIImageView *zanImage,*commentImage,*rightFooterView;


@property (nonatomic , weak) UIImageView *imageView, *bgbottomView,*bgAboveView;

@end

@implementation StyleCell

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
        
        if (self) {
            
    
            //格调图片
            UIImageView *imageView=[[UIImageView alloc]init];
            self.imageView=imageView;
            [self.contentView addSubview:imageView];
            
            UIImageView *bgAboveView=[[UIImageView alloc]init];
            UIImage *image1=[UIImage resizedImageWithName: @"paihangbang_beijing"];
            self.bgAboveView=bgAboveView;
            bgAboveView.image=image1;
            [self.contentView addSubview:bgAboveView];
            
            //小头像
            UIImageView *avatarImage=[[UIImageView alloc]init];
            self.avatarImage=avatarImage;
            [bgAboveView addSubview:avatarImage];
            
            
            //昵称
            UILabel *nicknameLabel=[[UILabel alloc]init];
            nicknameLabel.textColor=[UIColor blackColor];
            self.nicknameLabel=nicknameLabel;
            [bgAboveView addSubview:nicknameLabel];
            
            
            UIImageView *bgbottomView=[[UIImageView alloc]init];
            UIImage *image=[UIImage resizedImageWithName: @"paihangbang_beijing"];
            self.bgbottomView=bgbottomView;
            bgbottomView.image=image;
            [self.contentView addSubview:bgbottomView];
            
            
            //点赞的心形
            UIImageView *zanImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gediao_zan_xiao"]];
            self.zanImage=zanImage;
            [bgbottomView addSubview:zanImage];
            //评论的图标
            UIImageView *commentImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gediao_pinglun_xiao"]];
            self.commentImage=commentImage;
            [bgbottomView addSubview:commentImage];
            
            //右角图标
            
            UIImageView *rightFooterView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightfooter"]];
            [bgbottomView addSubview:rightFooterView];
            self.rightFooterView=rightFooterView;
            
            
            //点赞
            UILabel *zanLabel=[[UILabel alloc]init];
            zanLabel.textColor=[UIColor grayColor];
            zanLabel.textAlignment=NSTextAlignmentCenter;
            self.zanLabel=zanLabel;
            [bgbottomView addSubview:zanLabel];
            
            //评论
            UILabel *commentLabel=[[UILabel alloc]init];
            commentLabel.textColor=[UIColor grayColor];
            self.commentLabel=commentLabel;
            commentLabel.textAlignment=NSTextAlignmentCenter;
            [bgbottomView addSubview:commentLabel];
            
        }
    return self;
}


-(void)setStyle:(WorldTagIndexResult *)style
{
    _style=style;
    
    if (style.if_hidden==1) {
        [self.imageView setImage:[UIImage imageNamed:@"evertime_hidden.jpg"]];
    }else if(style.image_url !=nil && ![style.image_url isEqualToString:@""]){
        
         NSURL *imageUrl=[NSURL URLWithString:style.image_url];
       
        [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"pictureholderYellow"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
          
           CLog(@"%@",error);
           
           if (error!=nil) {
               [self.imageView setImage:[UIImage imageNamed:@"jiazaishibai"]];
           }
           
       }];
    }else{
        
        [self.imageView setImage:[UIImage imageNamed: @"evertime_riji"]];
        
    }
    

    self.zanLabel.text=[NSString stringWithFormat:@"%d",style.dianzan_num];
    self.commentLabel.text=[NSString stringWithFormat:@"%d",style.comment_num];
    
    
    if (style.if_anonymity) {
        [self.avatarImage setImage:[UIImage imageNamed:@"touxiang_niming"]];
        self.nicknameLabel.text=@"匿名";
    }else if (style.user_head_image_url !=nil && ![style.user_head_image_url  isEqualToString:@""]) {
         NSURL *avatarImageUrl=[NSURL URLWithString:style.user_head_image_url ];
        [self.avatarImage sd_setImageWithURL:avatarImageUrl placeholderImage:[UIImage imageNamed:@"avatarholder"]];
        self.nicknameLabel.text=style.user_nickname;
    }

    self.nicknameLabel.font=[UIFont systemFontOfSize:13];

}

-(void)layoutSubviews
{
    self.imageView.frame=CGRectMake(0, 0, kScreen_Width*0.5-8, kScreen_Width*0.5-8);
    
    self.bgAboveView.frame=CGRectMake(0,CGRectGetMaxY(self.imageView.frame),CGRectGetWidth(self.imageView.frame), 40);
    
    self.avatarImage.frame=CGRectMake(5, -10, 40, 40);
    [self.avatarImage doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:20];
    
    self.nicknameLabel.frame=CGRectMake(CGRectGetMaxX(self.avatarImage.frame)+2,5,300, 20);
 
     self.bgbottomView.frame=CGRectMake(0, CGRectGetMaxY(self.bgAboveView.frame)+1, self.bgAboveView.width, 40);


    self.zanImage.frame=CGRectMake(3, 10, 18, 18);
    
    self.zanLabel.frame=CGRectMake(CGRectGetMaxX(self.zanImage.frame)+2, CGRectGetMinY(self.zanImage.frame), 30, 18);
    
    self.commentImage.frame=CGRectMake(CGRectGetMaxX(self.zanLabel.frame)+3, 10, 18, 18);
    
    self.rightFooterView.frame=CGRectMake(CGRectGetMaxX(self.imageView.frame )-40, 0, 40, 40);
    

    self.commentLabel.frame=CGRectMake(CGRectGetMaxX(self.commentImage.frame)+2,CGRectGetMinY(self.commentImage.frame), 30, 18);
}



@end
