//
//  HisHomeResult.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "HisHomeResult.h"
#import "ImageResult.h"
@implementation HisHomeResult

- (NSDictionary *)objectClassInArray
{
    
    return @{@"images":[ImageResult class]};
}

@dynamic description;

@end
