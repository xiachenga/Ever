//
//  HisHomeResult.h
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface HisHomeResult :AppBeanResultBase


//魅力值
@property (nonatomic , assign) int meili_num;

@property (nonatomic , copy) NSString *sex;

@property (nonatomic , assign) BOOL if_friend;

//一句话介绍
@property (nonatomic , copy) NSString *description_content;


//所在地 例如：上海市
@property (nonatomic , copy) NSString *address;



@property (nonatomic , strong) NSArray *images;

@property (nonatomic , assign) BOOL if_dianzan;


//是否可以看个人中心
@property (nonatomic , assign) BOOL can_see_center;








@end
