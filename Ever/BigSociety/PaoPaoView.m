//
//  PaoPaoView.m
//  Ever
//
//  Created by Mac on 15-1-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "PaoPaoView.h"


@interface PaoPaoView ()
@property (nonatomic , weak) UIImageView *iconView,*detailArrow,*paopaoviewBg;
@property (nonatomic , weak) UILabel *nickNameLabel,*timeLabel,*descLabel;


@end
@implementation PaoPaoView


- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * paopaoviewBg=[[UIImageView alloc]init];
        self.paopaoviewBg=paopaoviewBg;
        
        
        self.paopaoviewBg=paopaoviewBg;
        [self addSubview:_paopaoviewBg];
        //头像
        UIImageView *iconView=[[UIImageView alloc]init];
        self.iconView=iconView;
        [_paopaoviewBg addSubview:_iconView];
        
        //昵称
        UILabel *nickNameLabel=[[UILabel alloc]init];
        nickNameLabel.font=[UIFont systemFontOfSize:15];
        nickNameLabel.textColor=[UIColor whiteColor];
        self.nickNameLabel=nickNameLabel;
        [_paopaoviewBg addSubview:_nickNameLabel];
        
        
        //向右的箭头
//        UIImageView * detailArrow=[[UIImageView alloc]init];
//        s
//        [_paopaoviewBg addSubview:_detailArrow];
        
        //描述
        UILabel *descLabel=[[UILabel alloc]init];
        descLabel.font=[UIFont systemFontOfSize:16];
        descLabel.textColor=[UIColor whiteColor];
        self.descLabel=descLabel;
        [_paopaoviewBg addSubview:descLabel];
        

        //注册时间
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.textColor=[UIColor whiteColor];
        timeLabel.font=[UIFont systemFontOfSize:15];
        self.timeLabel=timeLabel;
        [_paopaoviewBg addSubview:timeLabel];
        
        
        self.backgroundColor=[UIColor clearColor];
        self.canShowCallout=NO;
        self.centerOffset=CGPointMake(4, -65);
        
        
    }
    return self;
}


- (void)setMarkerModel:(WorldTagIndexResult *)markerModel
{

    CGFloat iconViewX=5;
    CGFloat iconViewY=10;
    CGFloat iconviewWH=30;
    
    
    if (markerModel.tag_type==3||markerModel.tag_type==5) {
        
        _iconView.frame=CGRectMake(iconViewX, iconViewY, iconviewWH, iconviewWH);
        
        if (markerModel.if_anonymity) {
            [_iconView setImage:[UIImage imageNamed:@"touxiang_niming"]];
        }else{
            
             [_iconView sd_setImageWithURL:[NSURL URLWithString:markerModel.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
            
        }
        
        [_iconView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:15];
       
        
        if (markerModel.tag_type==3) {
            self.descLabel.text=@"有一张私密日记";
        }else{
            self.descLabel.text=@"有一个私密照片";
        }
        self.descLabel.frame=CGRectMake(CGRectGetMaxX(self.iconView.frame)+5, CGRectGetMinY(self.iconView.frame), 150, 20);
        
        _paopaoviewBg.frame=CGRectMake(0, 0 , 200,60);
        UIImage *paopaoBg=[UIImage resizedImageWithName:@"dashehui_madiannormalBg"];
        self.paopaoviewBg.image=paopaoBg;

        
    }else{
        
        self.nickNameLabel.text= [NSString stringWithFormat:@"昵称:%@",markerModel.user_nickname];
        self.nickNameLabel.frame=CGRectMake(5, 5, 200, 20);
        
        
        self.timeLabel.text=[NSString stringWithFormat:@"注册时间:%@",markerModel.time];
        self.timeLabel.frame=CGRectMake(5, CGRectGetMaxY(self.nickNameLabel.frame)+10, 200, 20);
        
        _paopaoviewBg.frame=CGRectMake(0, 0, 200, 75);
        UIImage *paopaoBg=[UIImage resizedImageWithName:@"dashehui_touxiangAvatarBg"];
        self.paopaoviewBg.image=paopaoBg;
    }
    

    self.frame=self.paopaoviewBg.frame;
    
}




@end
