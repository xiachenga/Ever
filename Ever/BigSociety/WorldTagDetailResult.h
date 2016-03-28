//
//  WorldTagDetailResult.h
//  Ever
//
//  Created by Mac on 15-1-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GediaoDetailResult.h"
#import "JournalDetailResult.h"
#import "TagVoiceDetailResult.h"

@interface WorldTagDetailResult : NSObject

//颜色

@property (nonatomic , assign) int color_type;

@property (nonatomic , copy) NSString *address;

@property (nonatomic , assign) long cid;

@property (nonatomic , strong) GediaoDetailResult *gediao;

@property (nonatomic , strong) JournalDetailResult *journal;

//语音
@property (nonatomic , strong) TagVoiceDetailResult *tag_voice;

//麻点类型，1文字，2语音 3图集

//消失时间
@property (nonatomic , copy) NSString *delete_time;

@property (nonatomic , assign) BOOL if_can_comment;

//匿名
@property (nonatomic , assign) BOOL if_anonymity;


@end
