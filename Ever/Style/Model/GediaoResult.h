//
//  GediaoResult.h
//  Ever
//
//  Created by Mac on 15-3-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
#import "ImageResult.h"
@interface GediaoResult : AppBeanResultBase

/**
 *  图片单元
 */
@property (nonatomic , strong) ImageResult *image;

@property (nonatomic , copy) NSString *create_time;

//-1无标签 1有标签
@property (nonatomic , assign) int image_type;

//格调名称
@property (nonatomic , copy) NSString *name;

@property (nonatomic , assign) int comment_num;

@property (nonatomic , assign) long gediao_id;

@property (nonatomic , assign) BOOL if_himself;

/**
 *  是否已经点赞
 */
@property (nonatomic , assign) BOOL if_dianzan;


@end
