//
//  RootViewController.h
//  Ever
//
//  Created by Mac on 15-5-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : BaseViewController

@property(nonatomic,weak) UISegmentedControl *segmentedControl;

- (void)segmentedControlSelected:(UISegmentedControl *)segmentControl;

//地图刷新

- (void)bigSocityRefresh;
    


@end
