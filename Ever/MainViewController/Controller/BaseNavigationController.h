//
//  BaseNavigationController.h
//  Ever
//
//  Created by Mac on 15-1-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewStyleViewController,BigSocietyViewController;
@interface BaseNavigationController : UINavigationController

//- (void)returnMenu:(id)sender;

@property (nonatomic , strong) NewStyleViewController *newstyleVC;
@property (nonatomic , assign) BOOL newstyleIsShowed;
@property (nonatomic , assign) BOOL bigSocietyIsShowed;
@property (nonatomic , strong) BigSocietyViewController *bigSocietyVC;

@end
