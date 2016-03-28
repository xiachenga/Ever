//
//  FocusOnMeUserCell.m
//  Ever
//
//  Created by Mac on 15-5-7.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "FocusOnMeUserCell.h"
#import "UserRelationResult.h"
#import <RCIM.h>
#import "ChatViewController.h"
@interface FocusOnMeUserCell ()

@property (nonatomic,weak)UIImageView *avatarView;
@property (nonatomic , weak) UITapImageView *messageView;
@property (nonatomic , weak) UILabel *nickNameLabel;
@end

@implementation FocusOnMeUserCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       
        self.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        
        //头像
        UIImageView *avatarView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [avatarView doCircleFrame];
        self.avatarView=avatarView;
        [self.contentView addSubview:avatarView];
        
        //名字
        
        UILabel *nickNameLabel=[[UILabel alloc]init];
        self.nickNameLabel=nickNameLabel;
        [self.contentView addSubview:nickNameLabel];
        nickNameLabel.font=[UIFont systemFontOfSize:15];
        
        //信息
        UITapImageView *messageView=[[UITapImageView alloc]init];
        messageView.image=[UIImage imageNamed:@"guanzhu_news"];
        messageView.frame=CGRectMake(kScreen_Width-40, 18, 24, 24);
        self.messageView=messageView;
        [self.contentView addSubview:messageView];
        
        
    }
    return self;
}


-(void)setFocusUser:(UserRelationResult *)focusUser
{
    LoginResult *account=[AccountTool account];
    
    _focusUser=focusUser;
    
    NSURL *url=[NSURL URLWithString:focusUser.user_head_image_url];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
    self.nickNameLabel.text=focusUser.user_nickname;
    self.nickNameLabel.frame=CGRectMake(CGRectGetMaxX(self.avatarView.frame)+5, 20, 200, 20);
    
    [self.messageView addTapBlock:^(id obj) {
        //进入聊天界面
    
        [RCIM connectWithToken:account.rong_token completion:^(NSString *userId) {
            
            ChatViewController *chatVC=[[ChatViewController alloc]init];
            
            chatVC.conversationType=ConversationType_PRIVATE;
            chatVC.currentTarget=[NSString stringWithFormat:@"u%ld",focusUser.user_id];
            chatVC.enablePOI=NO;
            chatVC.enableVoIP=NO;
            chatVC.currentTargetName=focusUser.user_nickname;
            chatVC.enableSettings=NO;
            [chatVC setNavigationTitle:focusUser.user_nickname textColor:[UIColor blackColor]];
            chatVC.portraitStyle=RCUserAvatarCycle;
            
            chatVC.user=focusUser;
            
            UIViewController *viewController= [self viewController];
            [viewController.navigationController pushViewController:chatVC animated:YES];
            
        
        } error:^(RCConnectErrorCode status) {
            CLog(@"连接融云失败");
            
        }];
        
    }];
    
}


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
