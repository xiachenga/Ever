//
//  ImageResult.m
//  Ever
//
//  Created by Mac on 15-1-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ImageResult.h"

@implementation ImageResult

-(NSDictionary *)objectClassInArray
{
    return @{@"labels" : [LabelResult class]};
}


@end
