//
//  AppDelegate.h
//  Ever
//
//  Created by Mac on 15-1-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#define UmengAppkey @"5545ced367e58ebfc600239e"

#import <UIKit/UIKit.h>
#import <RCIM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMUserInfoFetcherDelegagte>

@property (strong, nonatomic) UIWindow *window;

@end