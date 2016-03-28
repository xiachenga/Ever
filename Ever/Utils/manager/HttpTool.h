//
//  HttpTool.h
//  Ever
//
//  Created by Mac on 15-4-5.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject


/**
 *  发送一个GET请求
 */


+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseobj))success failure:(void (^)(NSError *erronr))failure;


+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseobj))success failure:(void (^)(NSError * error))failure;


+(void)send:(NSString *)urlstring params:(NSDictionary *)params success:(void(^)(id responseobj))success ;




@end
