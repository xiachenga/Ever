//
//  MeetDetailResult.h
//  Ever
//
//  Created by Mac on 15-4-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
#import "ImageResult.h"
@interface MeetDetailResult : AppBeanResultBase

@property (nonatomic , assign) long meet_id;
@property (nonatomic , assign) int comment_num;
@property (nonatomic , assign) double suyandu;
@property (nonatomic , assign) int meili_num;
@property (nonatomic , copy) NSString *create_time;
@property (nonatomic , strong) ImageResult *image;


@end
