//
//  ChatViewController.h
//  Ever
//
//  Created by Mac on 15-4-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCChatViewController.h"
@class UserRelationResult;
@class AppBeanResultBase;
@interface ChatViewController : RCChatViewController

@property (nonatomic , strong) UserRelationResult *guanzhu;

@property (nonatomic , copy) NSString *userAvatarUrl;

@property (nonatomic , strong) AppBeanResultBase *user;



@end
