//
//  GediaoIndexResult.h
//  Ever
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GediaoIndexResult : NSObject

//图片URL
@property (nonatomic , copy) NSString *image_url;

@property (nonatomic , assign) long gediao_id;

//图片名称

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , copy) NSString *nickname;

@property (nonatomic , assign) long user_id;

@property (nonatomic , copy) NSString *head_image_url;


@property (nonatomic , assign) int dianzan_num;

@property (nonatomic , assign) int comment_num;



@end
