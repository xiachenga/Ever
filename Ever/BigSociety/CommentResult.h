//
//  CommentResult.h
//  Ever
//
//  Created by Mac on 15-1-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface CommentResult : AppBeanResultBase

//评论ID
@property (nonatomic , assign) long comment_id;

@property (nonatomic , copy) NSString *create_time;

//被回复人昵称
@property (nonatomic , copy) NSString *replay_user_nickname;

//被回复人ID

@property (nonatomic , assign) long replay_user_id;

//形态 1文字 2语音 3图片  暂时都是文字 暂时APP不支持图片回复和语音回复
@property (nonatomic , assign) int classes;


@property (nonatomic , copy) NSString *text_content;

//回复等级
@property (nonatomic , assign) int replay_type;


@property (nonatomic , copy) NSString *image_url;











@end
