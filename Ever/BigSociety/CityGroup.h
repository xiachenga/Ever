//
//  CityGroup.h
//  Ever
//
//  Created by Mac on 15-1-30.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityGroup : NSObject


@property (nonatomic , copy) NSString *firstWord;
@property (nonatomic , strong) NSArray *citys;

- (instancetype)initWithDic:(NSDictionary *)dic;

+(instancetype)cityGroupWithDic:(NSDictionary *)dic;

@end
