//
//  SegmentControlViewController.h
//  Ever
//
//  Created by Mac on 15-3-12.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentControlViewController : BaseViewController


@property(nonatomic, strong) UIViewController *selectedViewController;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

- (void)setViewControllers:(NSArray *)viewControllers;
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title;

@end
