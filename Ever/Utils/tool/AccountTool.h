//
//  AccountTool.h
//  Ever
//
//  Created by Mac on 15-4-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResult.h"
@interface AccountTool : NSObject

+(void)save:(LoginResult *)account;

+(LoginResult *)account;

+(BOOL)isLogin;
@end
