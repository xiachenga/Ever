//
//  LifeListResult.h
//  Ever
//
//  Created by Mac on 15-4-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface LifeListResult : AppBeanResultBase

 //账号创建时间
@property (nonatomic , copy) NSString *user_create_time;

@property (nonatomic , copy) NSString *background_image_url;

@property (nonatomic , strong) NSArray *lifes;
@end
