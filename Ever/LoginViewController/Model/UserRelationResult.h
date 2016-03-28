//
//  UserRelationResult.h
//  Ever
//
//  Created by Mac on 15-4-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBeanResultBase.h"
@interface UserRelationResult : AppBeanResultBase

//用户昵称首字母
@property (nonatomic , copy) NSString *first_letter;

//用户邮箱

@property (nonatomic , copy) NSString *user_email;


@property (nonatomic , assign) int meilinum;






@end
