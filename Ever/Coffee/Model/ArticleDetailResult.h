//
//  ArticleDetailResult.h
//  Ever
//
//  Created by Mac on 15-4-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDetailResult : NSObject


@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *content;

@property (nonatomic , strong) NSArray *images;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) BOOL if_dianzan;

@property (nonatomic , assign) int comment_num;

@property (nonatomic , copy) NSString *times;

@property (nonatomic , assign) long article_id;

@property (nonatomic , assign) int dianzan_num;








@end
