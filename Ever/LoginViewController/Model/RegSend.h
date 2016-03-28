//
//  RegSend.h
//  Ever
//
//  Created by Mac on 15-4-10.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegSend : NSObject

//设备唯一标识符
@property (nonatomic , copy) NSString *uuid;

@property (nonatomic , copy) NSString *qqnum;



//1为男 2为女
@property (nonatomic , assign) int sex;
//头像图片 name

@property (nonatomic , copy) NSString *head_image_name;

@property (nonatomic , copy) NSString *nickname;

@property (nonatomic , assign) long birthday;

@property (nonatomic , copy) NSString *city_name;

//1是自己的 2是QQ 3是微信 4是微博
@property (nonatomic , assign) int login_type;

//授权秘钥
@property (nonatomic , copy) NSString *uid;




@end
