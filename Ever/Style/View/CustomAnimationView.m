//
//  CustomAnimationView.m
//  Ever
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomAnimationView.h"
#import "LabelResult.h"



@implementation CustomAnimationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


-(void)setLabel:(LabelResult *)label
{
    _label=label;
    //白点
    UIImageView *animationdian=[[UIImageView alloc]init];
    animationdian.frame=CGRectMake(10, 10, 10, 10);
    animationdian.image=[UIImage imageNamed:@"fabu_tab_dian"];
    [self addSubview:animationdian];
    //黑点
    UIImageView *animationBlackdian=[[UIImageView alloc]init];
    animationBlackdian.frame=CGRectMake(7, 8, 15, 15);
    animationBlackdian.image=[UIImage imageNamed:@"fabu_tab_dianbg"];
    animationBlackdian.alpha=0;
    [self addSubview:animationBlackdian];
    [self startAnimation:animationdian blackdian:animationBlackdian ];
    
    
    CGSize textSize=[label.text_name boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    NSString *imageName=[NSString stringWithFormat:@"fabu_qipao_%d",label.color_type];
    
    UIImage *bgImage = [UIImage imageNamed:imageName];
  
    
  

    bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 5, textSize.width+10+15, 20)];
    if (label.icon_type==2) {
        imageView.frame=CGRectMake(30, 5, 120, 20);
    }else{
        imageView.frame=CGRectMake(30, 5, textSize.width+10+15, 20);
    }
    imageView.image=bgImage;
    
    [self addSubview:imageView];
    
    //小图像
    UIImageView *typeImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 12, 12)];
    NSString *imageString=[NSString stringWithFormat:@"fabu_biaoqian_%d",label.icon_type];
    typeImage.image=[UIImage imageWithName:imageString];
    [imageView addSubview:typeImage];
    
    UILabel *biaoqian=[[UILabel alloc]init];
    biaoqian.font=[UIFont systemFontOfSize:15];
    [biaoqian setTextColor:[UIColor whiteColor]];
    
    if(label.icon_type==2)
    {
        biaoqian.text=@"点击听取语音";
        biaoqian.frame=CGRectMake(20, 2, 100, 15);
        
    }else{
        biaoqian.text=label.text_name;
        biaoqian.frame=CGRectMake(20, 2, textSize.width, 15);
    }
    
    [imageView addSubview:biaoqian];
    
    
    if (label.icon_type==2) {
        
        UIGestureRecognizer *ges= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceClicked)];
        [self addGestureRecognizer:ges];
        
         self.frame=CGRectMake(label.leftMargin*kScreen_Width-10, label.topMargin*kScreen_Height-64-10, 150, 30);
    }else{
         self.frame=CGRectMake(label.leftMargin*kScreen_Width, label.topMargin*kScreen_Width, textSize.width+30+10+12, 30);
    }
   
}

//动画
- (void)startAnimation:(UIImageView *)animationdian blackdian:(UIImageView *)blackdian
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        animationdian.transform=CGAffineTransformMakeScale(0.8, 0.8);
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            animationdian.transform=CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            
            animationdian.transform=CGAffineTransformMakeScale(1, 1);
            
            [UIView animateWithDuration:1 animations:^{
                blackdian.alpha=0.5;
                blackdian.transform=CGAffineTransformMakeScale(2, 2);
                
            } completion:^(BOOL finished) {
                
                blackdian.alpha=0;
                
                blackdian.transform=CGAffineTransformMakeScale(1.0, 1.0);
                
                [self startAnimation:animationdian blackdian:blackdian];
                
            }];
            
        }];
        
        
    }];
    
}


- (void)voiceClicked
{
    CLog(@"播放语音");
    
    
    [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:self.label.voice_url andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        
    }];
    

}

@end
