//
//  CustomFoldMenu.h
//  Ever
//
//  Created by Mac on 15-1-6.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomFoldMenuDelegate <NSObject>

@optional

- (void)selectButton:(UIButton *)button;

- (void)tapCamera;

@end

@interface CustomFoldMenu : UIView

@property (nonatomic , weak) UIImageView *imageView;
@property (nonatomic , weak) UIImageView *cameraView;
@property (nonatomic , weak) id<CustomFoldMenuDelegate> delegate;



- (void)showMenu;

@end
