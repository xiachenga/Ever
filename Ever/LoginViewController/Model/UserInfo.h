//
//  UserInfo.h
//  Ever
//
//  Created by Mac on 15-4-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//性别
@property (nonatomic , copy) NSString *gender;

//昵称
@property (nonatomic , copy) NSString *screen_name;

@property (nonatomic , copy) NSString *profile_image_url;

@property (nonatomic , copy) NSString *access_token;

@property (nonatomic , assign) int login_type;

@property (nonatomic , copy) NSString *uid;




@end
