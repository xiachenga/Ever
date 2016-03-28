//
//  CommentViewController.h
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KindItem;
@interface CommentViewController : UIViewController

@property (nonatomic , strong) KindItem *kindItem;

- (UIViewController*)viewController;

@end
