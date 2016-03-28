//
//  WorldTagListSend.h
//  Ever
//
//  Created by Mac on 15-4-4.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionDTO.h"

@interface WorldTagListSend : NSObject


//数据所在城市 为空则为列表态
@property (nonatomic , copy) NSString *cityName;

//当前位置信息
@property (nonatomic , strong) PositionDTO *position;

//没用时 置为0

@property (nonatomic , assign) long cursorID;

@property (nonatomic , assign) int flushType;

@property (nonatomic , assign) int pageSize;

@property (nonatomic , assign) int pageNum;







@end
