//
//  AccountTool.m
//  Ever
//
//  Created by Mac on 15-4-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


//#define AccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account"]

#import "AccountTool.h"
#import "LoginResult.h"
@implementation AccountTool

+(void)save:(LoginResult *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFilepath];
    
}

+(LoginResult *)account
{
    
    // 读取帐号
   LoginResult *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilepath];
    return account;
    
}

+(BOOL)isLogin
{
   LoginResult *account= [self account];
    
    if (account.user_id!=0) {
        return YES;
    }else{
        return NO;
    }
    
    
}
@end
