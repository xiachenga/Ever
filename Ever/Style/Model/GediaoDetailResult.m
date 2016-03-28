//
//  GediaoDetailResult.m
//  Ever
//
//  Created by Mac on 15-3-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "GediaoDetailResult.h"
#import "HeadimageResult.h"
@implementation GediaoDetailResult

- (NSDictionary *)objectClassInArray
{
    return @{@"headimages" : [HeadimageResult class]};
    
}




@end
