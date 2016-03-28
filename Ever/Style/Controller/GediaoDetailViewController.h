//
//  GediaoDetailViewController.h
//  Ever
//
//  Created by Mac on 15-3-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GediaoDetailViewController : UIViewController


@property (nonatomic , assign) long gediaoid;
//判断是从格调册子中进入的还是从我的格调里面进入的 1是从格调册子里面进入的

@property (nonatomic , assign) int gediaoType;



@end
