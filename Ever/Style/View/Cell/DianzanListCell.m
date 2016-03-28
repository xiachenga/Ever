//
//  DianzanListCell.m
//  Ever
//
//  Created by Mac on 15/7/3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "DianzanListCell.h"
#import "PersonhomeViewController.h"
#import "GediaoZanListViewController.h"


@interface DianzanListCell ()

//头像
@property (nonatomic,weak)UITapImageView *avatarView;

@property (nonatomic , weak) UILabel  *timeLabel,*nickNameLabel;

@end

@implementation DianzanListCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        //设置没有选中效果
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //头像
        UITapImageView *avatarView=[[UITapImageView alloc]init];
        self.avatarView=avatarView;
        [self.contentView addSubview:avatarView];
        
        //昵称
        UILabel *nickNameLabel=[[UILabel alloc]init];
        nickNameLabel.font=[UIFont systemFontOfSize:15];
        self.nickNameLabel=nickNameLabel;
        [self.contentView addSubview:nickNameLabel];
        
        //时间
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.font=[UIFont systemFontOfSize:13];
        self.timeLabel=timeLabel;
        [self.contentView addSubview:timeLabel];
        
    
        
        
    }
    return self;
}

-(void)setDianzanResult:(DianzanResult *)dianzanResult
{
    _dianzanResult=dianzanResult;
    
    //设置头像
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:dianzanResult.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    [self.avatarView addTapBlock:^(id obj) {
        
        [self gotoPersonhome];
        
    }];
    self.avatarView.frame=CGRectMake(10, 10, 40, 40);
    [self.avatarView doCircleFrame];
    
    //昵称
    self.nickNameLabel.text=dianzanResult.user_nickname;
    
    self.nickNameLabel.frame=CGRectMake(CGRectGetMaxX(self.avatarView.frame)+10,20 , 100, 20);
    
    
    
    //时间
    self.timeLabel.text=dianzanResult.create_time;
    self.timeLabel.frame=CGRectMake(kScreen_Width-100, 22, 100, 15);
    
   
    
}


//进入个人首页
- (void)gotoPersonhome
{
     GediaoZanListViewController *tableController=(GediaoZanListViewController *)[self viewController];
     UIViewController *controller=[tableController viewController];
    
    
    
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=self.dianzanResult.user_id;
    
    
    
    CLog(@"%@",tableController);
    
    [controller.navigationController pushViewController:personhomeVC animated:YES];
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


//根据view找出所在的控制器


- (UIViewController*)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



@end
