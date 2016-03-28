//
//  GediaoPublishSettingViewController.h
//  Ever
//
//  Created by Mac on 15/7/9.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GediaoPublishSettingViewController;
@protocol GediaoPublishSettingViewControllerDelegatte <NSObject>

@optional
-(void)Controller:(GediaoPublishSettingViewController *)controller disappear:(NSString *)date time:(NSString *)time isAnnoymity:(BOOL)isAnnoymity allowComment:(BOOL)comment showOnMap:(BOOL)showOnMap;

@end

@interface GediaoPublishSettingViewController : UITableViewController

@property (nonatomic , weak) id<GediaoPublishSettingViewControllerDelegatte> delegate;

@end
