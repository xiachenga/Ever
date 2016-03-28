//
//  ArticleIndexResult.m
//  Ever
//
//  Created by Mac on 15-4-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ArticleIndexResult.h"
#import "HeadimageResult.h"

@implementation ArticleIndexResult

-(NSDictionary *)objectClassInArray
{
    return @{@"headimages":[HeadimageResult class]};
}



@end
