//
//  ArticleReplaySend.h
//  Ever
//
//  Created by Mac on 15-4-4.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleReplaySend : NSObject


@property (nonatomic , assign) long article_id;

@property (nonatomic , copy) NSString *text_content;

@property (nonatomic , copy) NSString *image_name;


@end
