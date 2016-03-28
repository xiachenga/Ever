//
//  PersonhomeViewController.h
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuanzhuButtonType) {
    
    GuanzhuButtonTypeHas=0,
    GuanzhuButtonTypeNone

};

static NSString *const kNotificationGuanzhu=@"kNotificationGuan";

@interface PersonhomeViewController : UIViewController

@property (nonatomic , assign) long user_id;

@property (nonatomic , assign) GuanzhuButtonType guanzhuButtonType;

@end
