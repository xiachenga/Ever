//
//  ArticleIndexResult.h
//  Ever
//
//  Created by Mac on 15-4-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ArticleIndexResult : NSObject

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *title_image_url;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) long article_id;

@property (nonatomic , strong) NSArray *headimages;



@end
