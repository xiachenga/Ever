//
//  PositionDTO.h
//  Ever
//
//  Created by Mac on 15-1-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionDTO : NSObject
@property (nonatomic , assign) double longitude;
@property (nonatomic , assign) double latitude;
@property (nonatomic , strong) NSString *title;
@property (nonatomic , strong) NSString *address;
@property (nonatomic , strong) NSString *city;




@end
