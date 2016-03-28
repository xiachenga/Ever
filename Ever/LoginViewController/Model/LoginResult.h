//
//  LoginResult.h
//  Ever
//
//  Created by Mac on 15-4-10.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "AppBeanResultBase.h"

@interface LoginResult : AppBeanResultBase<NSCoding>

@property (nonatomic , copy) NSString *rong_token;

@property (nonatomic , copy) NSString *uuid;

@property (nonatomic , assign) BOOL if_has_reg;

@property (nonatomic , copy) NSString *password;

@property (nonatomic , copy) NSString *email;

@property (nonatomic , copy) NSString *telephone;

@property (nonatomic , assign) int sex;

@property (nonatomic , assign) int meili_num;

@property (nonatomic , assign) double money;

@property (nonatomic , copy) NSString *description_content;

@property (nonatomic , copy) NSString *real_name;

@property (nonatomic , copy) NSString *detail_address;

//所在城市 【自动定位！不能修改】
@property (nonatomic , copy) NSString *city;

//生日时间戳
@property (nonatomic , assign) long  birthday_time_stamp;

//是否可以查看其个人中心
@property (nonatomic , assign) BOOL can_see_center;

@property (nonatomic , assign) BOOL can_search;

//-1为还未申请 1为实体商家  2为虚拟商家
@property (nonatomic , assign) int business_type;

//第三方密钥
@property (nonatomic , copy) NSString *uid;

//登录方式 1是自己的 2是QQ 3是微信 4是微博
@property (nonatomic , assign) int loginType;

@end
