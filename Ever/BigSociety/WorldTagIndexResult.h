//
//  WorldTagIndexResultModel.h
//  Ever
//
//  Created by Mac on 15-1-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionDTO.h"
#import "AppBeanResultBase.h"
@interface WorldTagIndexResult : AppBeanResultBase

//麻点描述
@property (nonatomic , copy) NSString *descriptions;
 //注册时间
@property (nonatomic , copy) NSString *time;

 //20个颜色类型
@property (nonatomic , assign) int color_type;

@property (nonatomic , strong) PositionDTO *position;

@property (nonatomic , copy) NSString *delete_time;

 //*麻点类型 3日记 6语音 5格调
@property (nonatomic , assign) int tag_type;

@property (nonatomic , assign) long cid;

@property (nonatomic , copy) NSString *image_url;

@property (nonatomic , assign) int dianzan_num;

@property (nonatomic , assign) int comment_num;

@property (nonatomic , assign) long world_tag_id;

//*是否设置为?隐藏 -1为不隐藏 1为隐藏（需要替换成问号图片）
@property (nonatomic , assign) BOOL if_hidden;

//*是否是匿名的
@property (nonatomic , assign) BOOL if_anonymity;

//是否永久 
@property (nonatomic , assign) BOOL if_ever;


@end
