//
//  AppBeanResultBase.h
//  Ever
//
//  Created by Mac on 15-4-4.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppBeanResultBase : NSObject

@property (nonatomic , copy) NSString *user_nickname;

@property (nonatomic , assign) long user_id;

@property (nonatomic , copy) NSString *user_head_image_url;

@property (nonatomic , copy) NSString *prompt;

@property (nonatomic , assign) BOOL if_success;

@end
