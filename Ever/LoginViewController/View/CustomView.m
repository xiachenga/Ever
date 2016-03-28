//
//  CustomView.m
//  Ever
//
//  Created by Mac on 15-4-9.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomView.h"
#import "HeadimageResult.h"

@interface CustomView ()

@end

@implementation CustomView

-(instancetype)initWithFrame:(CGRect)frame
{
    
   self= [super initWithFrame:frame  ];
    if (self) {
        
        self.userInteractionEnabled=YES;
        
        
        /**
         *  添加子控件
         */
        [self setupSubViews];
        

    }
    return self;
    
    
}

/**
 *  添加子控件
 */
- (void)setupSubViews
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width*0.25, kScreen_Width*0.25)];
    [imageView doBorderWidth:3 color:[UIColor whiteColor] cornerRadius:kScreen_Width*0.25*0.5];
    self.imageView=imageView;
    [self addSubview:imageView];
   
    UIImageView *duihaoView=[[UIImageView alloc]init];
    duihaoView.image=[UIImage imageNamed:@"duihao"];
    duihaoView.frame=CGRectMake(kScreen_Width*0.25-25, 0, 20, 20);
    [self addSubview:duihaoView];
    self.duihaoView=duihaoView;
    duihaoView.hidden=YES;
    
    
}


-(void)setHeadImage:(HeadimageResult *)headImage
{
    _headImage=headImage;
    
    NSString *urlstring=headImage.user_head_image_url;
    NSURL *url=[NSURL URLWithString:urlstring];
    [self.imageView sd_setImageWithURL:url placeholderImage:nil];
    
    
}




@end
