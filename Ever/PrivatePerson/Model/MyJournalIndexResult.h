//
//  MyJournalIndexResult.h
//  Ever
//
//  Created by Mac on 15-5-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyJournalIndexResult : NSObject

//ID
@property (nonatomic , assign) long journal_id;

 //题目
@property (nonatomic , copy) NSString *title_text_content;

 //摘要文字
@property (nonatomic , copy) NSString *summary_content;

//摘要图片

@property (nonatomic , copy) NSString *summary_image_url;

 //是否有图片

@property (nonatomic , assign) BOOL if_has_image;

@property (nonatomic , copy) NSString *time;


@end
