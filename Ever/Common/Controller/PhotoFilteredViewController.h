//
//  PhotoFilteredViewController.h
//  Ever
//
//  Created by Mac on 15-5-13.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KindItem.h"
@interface PhotoFilteredViewController : UIViewController

@property (nonatomic , weak) UIImage *selectedImage;

//@property (nonatomic , assign) int type;

@property (nonatomic , strong) KindItem *kind;



@end
