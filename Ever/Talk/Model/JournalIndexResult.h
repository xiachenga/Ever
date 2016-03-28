//
//  JournalIndexResult.h
//  Ever
//
//  Created by Mac on 15-3-22.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JournalIndexResult : NSObject



//ID
@property (nonatomic , assign) long journal_id;

//题目

@property (nonatomic , copy) NSString *title_text_content;

//摘要文字

@property (nonatomic , copy) NSString *summary_content;

@property (nonatomic , assign) int see_num;

 //摘要图片
 @property (nonatomic , copy) NSString *summary_image_url;



@property (nonatomic , assign) int dianzan_num;


@property (nonatomic , assign) BOOL if_dianzan;

@property (nonatomic , assign) BOOL if_save_success;

@property (nonatomic , copy) NSString *reason;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , copy) NSString *user_head_image_url;

@property (nonatomic , assign) long user_id;

@property (nonatomic , assign) BOOL if_has_image;







@end
