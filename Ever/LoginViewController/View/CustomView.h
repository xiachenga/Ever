//
//  CustomView.h
//  Ever
//
//  Created by Mac on 15-4-9.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeadimageResult;
@interface CustomView : UIView

@property (nonatomic , strong) HeadimageResult *headImage;

@property (nonatomic , assign) BOOL isSelected;

@property (nonatomic,weak)UIImageView *imageView;



@property (nonatomic , weak) UIImageView *duihaoView ;

@end
