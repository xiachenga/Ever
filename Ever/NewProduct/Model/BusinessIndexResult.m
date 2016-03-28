//
//  BusinessIndexResult.m
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "BusinessIndexResult.h"
#import "HeadimageResult.h"
#import "GoodsIndexResult.h"

@implementation BusinessIndexResult

- (NSDictionary *)objectClassInArray{
    
    return @{@"headimageResults":[HeadimageResult class],@"tuijianList":[GoodsIndexResult class]};
    
    //  return @{@"headimageResults":[HeadimageResult class]};
}

@end
