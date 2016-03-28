//
//  CustomBMKAvatarView.m
//  Ever
//
//  Created by Mac on 15/6/24.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomBMKAvatarView.h"

@interface CustomBMKAvatarView ()

@property (nonatomic,weak)UIImageView *avatarView;

@end

@implementation CustomBMKAvatarView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.canShowCallout=NO;
        UIImageView *avatarView=[[UIImageView alloc]init];
        self.avatarView=avatarView;
        [self addSubview:avatarView];
        
    }
    return self;
}


-(void)setWorldtagIndex:(WorldTagIndexResult *)worldtagIndex
{
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:worldtagIndex.user_head_image_url] placeholderImage:[UIImage imageWithName:@"avatarholder"]];
    self.avatarView.frame=CGRectMake(0, 0, 50, 50);
    [self.avatarView doCircleFrame];
    self.frame=CGRectMake(0, 0, 50, 50);

}




@end
