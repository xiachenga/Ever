//
//  ChineseString.h
//  Ever
//
//  Created by Mac on 15-4-23.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserRelationResult;
@interface ChineseString : NSObject

@property(nonatomic, copy)NSString *string;
@property(nonatomic, copy)NSString *pinYin;

@property (nonatomic , copy) NSString *firstNum;

@property (nonatomic , strong) UserRelationResult *usesrRelation;


 @property (nonatomic , assign) BOOL showRedDotView;

@end
