//
//  GoIntoMainScreen.m
//  Ever
//
//  Created by Mac on 15-4-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "GoIntoMainScreen.h"
#import "SegmentControlViewController.h"
#import "BaseNavigationController.h"
#import "MenuViewContoller.h"
#import "LoginViewController.h"

@implementation GoIntoMainScreen


+(void)goIntoMainScreen
{
    
    
    SegmentControlViewController *segmentVC=[[SegmentControlViewController alloc]init];
    BaseNavigationController *segmentNav=[[BaseNavigationController alloc]initWithRootViewController:segmentVC];
    
     [segmentNav setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    
    MenuViewContoller *menuVC=[[MenuViewContoller alloc]init];
    
    MMDrawerController *drawerVC=[[MMDrawerController alloc]initWithCenterViewController:segmentNav leftDrawerViewController:menuVC];
    
    [drawerVC setMaximumLeftDrawerWidth:200];
    [drawerVC setShowsShadow:NO];
    
    [drawerVC setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
    [drawerVC setRestorationIdentifier:@"MMDrawer"];
    [drawerVC setMaximumRightDrawerWidth:200.0];
    [drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
    
   
    
    drawerVC.bezelPanningCenterViewRange=5;
    [drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    

    
    
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController=drawerVC;
    
}

+ (void)gotoLogin
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    BaseNavigationController *loginNav=[[BaseNavigationController alloc]initWithRootViewController:loginVC];
    window.rootViewController=loginNav;
    
}

@end
