//
//  PersonInfoViewController.h
//  Ever
//
//  Created by Mac on 15-4-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo,PhoneNumRes;
@interface PersonInfoViewController : UIViewController

@property (nonatomic , weak) UIImage *image;
@property (nonatomic , strong) UserInfo *qquser;
@property (nonatomic , strong) UserInfo *WeiboUser;

@property (nonatomic , strong) UserInfo *user;

@property (nonatomic , strong) PhoneNumRes *phone;

@end
