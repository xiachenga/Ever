//
//  ArticleDetailResult.m
//  Ever
//
//  Created by Mac on 15-4-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ArticleDetailResult.h"
#import "ImageResult.h"
@implementation ArticleDetailResult


-(NSDictionary *)objectClassInArray
{
    
    return @{@"images":[ImageResult class]};
}

@end
