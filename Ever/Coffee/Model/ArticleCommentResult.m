//
//  ArticleCommentResult.m
//  Ever
//
//  Created by Mac on 15-4-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ArticleCommentResult.h"

@implementation ArticleCommentResult

-(NSDictionary *)objectClassInArray{
    
    return @{@"image":[ImageResult class]};
}

@end
