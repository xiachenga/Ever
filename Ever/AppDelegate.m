//
//  AppDelegate.m
//  Ever
//
//  Created by Mac on 15-1-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import <BaiduMapAPI/BMKMapView.h>
#import "SegmentControlViewController.h"
#import "MenuViewContoller.h"
#import "LoginViewController.h"


#import "UMSocialWechatHandler.h"

#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialRenrenHandler.h"


#import <TuSDK/TuSDK.h>
#import "APService.h"

#import "GoIntoMainScreen.h"
#import "UserRelationResult.h"

#import "LCNewFeatureVC.h"

@interface AppDelegate ()
{
    LCNewFeatureVC *_newFeatureVC;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置友盟社会化组件appkey
    
    [UMSocialData setAppKey:UmengAppkey];
  

    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
  //设置微信AppId，设置分享url，默认使用友盟的网址
    
   [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    
    //设置分享到qq空间的id
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    //设置没有客户端的情况下，使用sso授权
     [UMSocialQQHandler setSupportWebView:YES];
    
    //人人
    
    [UMSocialRenrenHandler openSSO];
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    

    //百度地图
    BMKMapManager *mapManager=[[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"vb4vtlTrDbnz6EHbigYgPnmZ"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //注册融云
    [RCIM initWithAppKey:RONGCLOUD_IM_APPKEY deviceToken:nil];
    // 设置用户信息提供者
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
    
    
   // [RCIM setFriendsFetcherWithDelegate:self];
    
    
    RCIM *rcim=[[RCIM alloc]init];
    [rcim setUserPortraitClickEvent:^(UIViewController *viewController, RCUserInfo *userInfo) {
        
        CLog(@"点击头像了");
        
    
        PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
        personhomeVC.user_id=(long)[[userInfo.userId substringFromIndex:1]longLongValue];
        
        UINavigationController *nav=viewController.navigationController;
        [nav pushViewController:personhomeVC animated:YES];
        
        
    }];
    
    
    
    [TuSDK initSdkWithAppKey:@"4816c2995a38ec81-00-k7con1"];
    
    //判断程序的语言版本
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *languageType=[defaults objectForKey:kSaveLanguageDefaultKey];
    if (languageType==nil) {
        [defaults setObject:@"Chinese" forKey:kSaveLanguageDefaultKey];
        [defaults synchronize];
    }
    
    
    //JPush
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    //是否显示新特性
    BOOL showNewFeature = [LCNewFeatureVC shouldShowNewFeature];
    
    //  showNewFeature=YES;
    if (showNewFeature) {
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [enterBtn setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [enterBtn setBackgroundImage:[UIImage imageNamed:@"guide_enter"] forState:UIControlStateNormal];
        
        [enterBtn setFrame:(CGRect){kScreen_Width-120, SCREEN_SIZE.height * 0.85, 100, 30.0f}];
        
        [enterBtn addTarget:self action:@selector(didClickedBtn) forControlEvents:UIControlEventTouchUpInside];
        
        LCNewFeatureVC *newFeatureVC = [LCNewFeatureVC newFeatureWithImageName:@"guide"
                                                                    imageCount:3
                                                               showPageControl:YES
                                                                   enterButton:enterBtn];
        _newFeatureVC=newFeatureVC;
        
        self.window.rootViewController=newFeatureVC;
    }else{
        
        if ([AccountTool isLogin]) {
            [GoIntoMainScreen goIntoMainScreen];
        }else{
            
            LoginViewController *loginVC=[[LoginViewController alloc]init];
            BaseNavigationController *loginNav=[[BaseNavigationController alloc]initWithRootViewController:loginVC];
            
            self.window.rootViewController=loginNav;
        }
        
    }
    
    
    return YES;
}


/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

/**
 
 友盟获取用户的信息
 
 */
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    
    if ([AccountTool isLogin]) {
        
   
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"user/list/1/1/200/1/0"];
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        if (responseobj!=nil) {
            
            NSArray *friends=[UserRelationResult objectArrayWithKeyValuesArray:responseobj];
            
            for (int i=0; i< friends.count; i++) {
                
                UserRelationResult *account=friends[i];
                
                if ([[NSString stringWithFormat:@"u%ld",account.user_id] isEqual:userId]) {
                    RCUserInfo *user = [[RCUserInfo alloc]init];
                    user.userId = [NSString stringWithFormat:@"u%ld",account.user_id];
                    
                   
                    user.portraitUri = account.user_head_image_url;
                    return completion(user);
                }
                
                
            }
            
        }
       
    
    } failure:^(NSError *erronr) {
        
    }];
    
    
    LoginResult *account=[AccountTool account];
    long id= account.user_id;
    
    if ([[NSString stringWithFormat:@"u%ld",id] isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [NSString stringWithFormat:@"u%ld",id];
        user.portraitUri = account.user_head_image_url;
        return completion(user);
    }
        
    }

}


/**
 
 极光推送
 
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)didClickedBtn {
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _newFeatureVC.view.transform = CGAffineTransformMakeTranslation(-SCREEN_SIZE.width, 0);
        
    } completion:^(BOOL finished) {
        
        if ([AccountTool isLogin]) {
            [GoIntoMainScreen goIntoMainScreen];
        }else{
            
            LoginViewController *loginVC=[[LoginViewController alloc]init];
            BaseNavigationController *loginNav=[[BaseNavigationController alloc]initWithRootViewController:loginVC];
            
            self.window.rootViewController=loginNav;
        }
    }];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
