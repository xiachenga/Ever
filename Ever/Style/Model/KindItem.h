//
//  KindItem.h
//  Ever
//
//  Created by Mac on 15-4-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindItem : NSObject

@property (nonatomic , assign) long itemID;

//判断评论的类型 1 发布形象 2 发布格调 3 发表日记
@property (nonatomic , assign) long kind;

@property (nonatomic , assign) BOOL if_can_comment;

@property (nonatomic , strong) NSMutableDictionary *position;

@end
