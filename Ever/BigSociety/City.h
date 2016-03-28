//
//  City.h
//  Ever
//
//  Created by Mac on 15-1-30.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic , assign) int cityid;
@property (nonatomic , copy) NSString *cityName;

+ (instancetype)cityWithDic:(NSDictionary *)dic;

- (instancetype)initWithDic:(NSDictionary *)dic;


@end
