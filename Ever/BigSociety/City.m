//
//  City.m
//  Ever
//
//  Created by Mac on 15-1-30.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "City.h"

@implementation City


- (instancetype)initWithDic:(NSDictionary *)dic

{
    if (self=[super init]) {
        self.cityid=[dic[@"cityid"]intValue];
        self.cityName=dic[@"cityname"];
    }
    return self;
}



+ (instancetype)cityWithDic:(NSDictionary *)dic


{
    
    return [[self alloc]initWithDic:dic];
    
}

@end
