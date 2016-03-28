//
//  DianzanDynamicResult.h
//  Ever
//
//  Created by Mac on 15-5-25.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface DianzanDynamicResult : AppBeanResultBase

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) long cid;

//点赞类型内容形象\谈论\MEET\格调
@property (nonatomic , copy) NSString *type_name;

//点赞类型标识 1形象 3谈论 4MEET 5格调
@property (nonatomic , assign) int type;

@property (nonatomic , assign) BOOL if_friend;

@property (nonatomic , assign) long dynamic_id;





@end
