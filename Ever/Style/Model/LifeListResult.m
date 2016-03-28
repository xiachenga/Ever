//
//  LifeListResult.m
//  Ever
//
//  Created by Mac on 15-4-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "LifeListResult.h"
#import "LifeResult.h"
@implementation LifeListResult

- (NSDictionary *)objectClassInArray
{
   return  @{@"lifes": [LifeResult class]};
    
}

@end
