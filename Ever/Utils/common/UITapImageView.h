//
//  UITapImageView.h
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView

//点击
- (void)addTapBlock:(void(^)(id obj))tapAction;

//长时间点击
- (void)addLongTapBlock:(void(^)(id obj))longTapAction;

- (void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void (^)(id obj))tapAction;

@end
