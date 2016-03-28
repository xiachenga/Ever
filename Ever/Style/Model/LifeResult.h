//
//  LifeResult.h
//  Ever
//
//  Created by Mac on 15-4-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeResult : NSObject

@property (nonatomic , copy) NSString *create_time;

//图片URL
@property (nonatomic , copy) NSString *image_url;

//是否有图片
@property (nonatomic , assign) BOOL if_has_image;


@property (nonatomic , copy) NSString *summary;

//操作类型
@property (nonatomic , assign) int do_type;


@property (nonatomic , assign) long cid;


@end
