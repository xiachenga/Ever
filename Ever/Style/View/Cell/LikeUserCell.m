//
//  LikeUserCell.m
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


#import "LikeUserCell.h"
#import "HeadimageResult.h"

@interface LikeUserCell ()

@property(weak,nonatomic)UIImageView *headerView;


@end

@implementation LikeUserCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        UITapImageView *headerView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [headerView doCircleFrame];
        self.headerView=headerView;
        [self.contentView addSubview:headerView];
        
        
        
    }
    return self;
}



-(void)setHeadResult:(HeadimageResult *)headResult{
    
    _headResult=headResult;
    
    NSURL *urlstring=[NSURL URLWithString:headResult.user_head_image_url];
    [self.headerView sd_setImageWithURL:urlstring placeholderImage:nil];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}





@end
