//
//  CityGroup.m
//  Ever
//
//  Created by Mac on 15-1-30.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CityGroup.h"
#import "City.h"

@implementation CityGroup





-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self=[super init]) {
        self.firstWord=dic[@"firstWord"];
        
        NSArray *citys=dic[@"citys"];
        
        
        
        NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:citys.count];
        
        
        
        
        for (NSDictionary *dict in citys) {
            
            City *city=[[City alloc]initWithDic:dict];
            [arrayM addObject:city];
            
            
        }
        
        self.citys=arrayM;
        
        
    }
    return self;
    
}


+(instancetype)cityGroupWithDic:(NSDictionary *)dic
{
    
    return [[self alloc]initWithDic:dic];
    
    
    
}



@end
