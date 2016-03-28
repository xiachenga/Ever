//
//  MenuViewContoller1.h
//  Ever
//
//  Created by Mac on 15-1-2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface MenuViewContoller : UIViewController

@property (nonatomic , weak) UIButton *styleButton;

@property (nonatomic , strong) RootViewController *styleVC;

- (void)buttonClicked:(UIButton *)button;


@end
