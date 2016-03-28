//
//  UptokenResult.h
//  Ever
//
//  Created by Mac on 15-5-20.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UptokenResult : NSObject

@property (nonatomic , copy) NSString *uptoken;

@property (nonatomic , copy) NSString *random_file_name;

@property (nonatomic , copy) NSString *create_time;

@property (nonatomic , assign) BOOL if_success;

@end
