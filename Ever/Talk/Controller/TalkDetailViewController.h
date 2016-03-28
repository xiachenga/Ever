//
//  TalkDetailViewController.h
//  Ever
//
//  Created by Mac on 15-3-22.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkDetailViewController : UIViewController

@property (nonatomic , assign) long talkid;

//判断是从格调首页进入还是从我的日记里面进去
@property (nonatomic , assign) int type;


@end
