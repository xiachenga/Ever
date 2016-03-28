//
//  UIImageView+Common.h
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Common)

- (void)doCirclebead;
- (void)doCircleFrame;
- (void)doNotCircleFrame;
-(void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end
