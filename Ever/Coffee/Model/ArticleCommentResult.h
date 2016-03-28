//
//  ArticleCommentResult.h
//  Ever
//
//  Created by Mac on 15-4-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
#import "ImageResult.h"

@interface ArticleCommentResult : AppBeanResultBase

@property (nonatomic , strong) ImageResult *image;

@property (nonatomic , copy) NSString *content;



@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) long comment_id;








@end
