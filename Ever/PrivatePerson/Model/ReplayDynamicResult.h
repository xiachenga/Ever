//
//  ReplayDynamicResult.h
//  Ever
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplayDynamicResult : NSObject

@property (nonatomic , copy) NSString *his_nickname;

@property (nonatomic , assign) long his_user_id;

@property (nonatomic , copy) NSString *his_head_image_url;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) long cid;

//2心情 3谈论 4MEET 5格调 6世界标签

@property (nonatomic , assign) int type;

@property (nonatomic , copy) NSString *summary;

@property (nonatomic , copy) NSString *image_url;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , assign) BOOL if_has_image ;

@property (nonatomic , assign) long dynamic_id;

@property (nonatomic , copy) NSString *replay_content;

@property (nonatomic , copy) NSString *replay_nickname;

@property (nonatomic , assign) long replay_user_id;




@end
