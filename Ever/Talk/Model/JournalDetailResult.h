//
//  JournalDetailResult.h
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppBeanResultBase.h"
@interface JournalDetailResult : AppBeanResultBase

//ID
@property (nonatomic , assign) long  journal_id;

//标题名称
@property (nonatomic , copy) NSString *title_text_content;

//文字内容
@property (nonatomic , copy) NSString *text_content;

@property (nonatomic , assign) BOOL if_has_image;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) BOOL if_dianzan;


@property (nonatomic , assign) int dianzan_num;

@property (nonatomic , assign) int comment_num;

@property (nonatomic , strong) NSArray *headimages;

@property (nonatomic , strong) NSArray *images;

@end
