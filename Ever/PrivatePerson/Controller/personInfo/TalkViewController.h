//
//  TalkViewController.h
//  Ever
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KindItem.h"

@interface TalkViewController : UIViewController

@property (nonatomic , weak) UIImage *selectedImage;

@property (nonatomic , strong) KindItem *kindItem;



- (void)selectedImage:(UIImage *)image labels:(NSArray *)labels withyuyin:(NSArray *)yuyin;

@end
