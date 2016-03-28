//
//  GuanzhuResult.h
//  Ever
//
//  Created by Mac on 15-4-23.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface GuanzhuResult : AppBeanResultBase

 //关注按钮点击后的状态 -1没有关注  1已关注
@property (nonatomic , assign) int guanzhu_status;


@end
