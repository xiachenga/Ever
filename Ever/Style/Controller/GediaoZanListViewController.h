//
//  GediaoZanListViewController.h
//  Ever
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KindItem.h"
@interface GediaoZanListViewController : UITableViewController

@property (nonatomic , strong) KindItem *kindItem;

- (UIViewController*)viewController;

@end
