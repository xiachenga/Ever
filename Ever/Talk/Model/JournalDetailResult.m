//
//  JournalDetailResult.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "JournalDetailResult.h"
#import "HeadimageResult.h"
#import "ImageResult.h"

@implementation JournalDetailResult


- (NSDictionary *)objectClassInArray
{
        
    return @{@"headimages":[HeadimageResult class],@"images":[ImageResult class]};
}





@end
