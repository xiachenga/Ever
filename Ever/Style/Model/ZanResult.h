//
//  ZanResult.h
//  Ever
//
//  Created by Mac on 15-3-24.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface ZanResult : AppBeanResultBase


//点赞操作后的状态 -1没有赞状态  1已经赞状态

@property (nonatomic , assign) int zan_status;


@property (nonatomic , assign) long cid;







@end
