//
//  GediaoDetailResult.h
//  Ever
//
//  Created by Mac on 15-3-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


#import "GediaoResult.h"
#import <Foundation/Foundation.h>

@interface GediaoDetailResult : NSObject

/**
 *  格调单元
 */
@property (nonatomic , strong) GediaoResult *gediao;

/**
 *  
 */
@property (nonatomic , strong) NSArray *headimages;

@end
