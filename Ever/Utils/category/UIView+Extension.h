//
//  UIView+Extension.h
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITapImageView.h"

@class LoadingView,BlankPageView;

typedef NS_ENUM(NSInteger, BlankPageType)
{
    BlankPagetypeRefresh=0,
    BlankPagetypeEmpty,
    
    
};

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;






- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown;
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color;
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;


+ (UIView *)lineViewWithPointYY:(CGFloat)pointY;
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color;
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;


@property (nonatomic , weak) LoadingView *loadingView;

- (void)beginLoading;
- (void)endLoading;

# pragma mark BlankPageView
@property (nonatomic , weak) BlankPageView *blankPageView;

- (void)configBlankPage:(BlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;

@end


@interface LoadingView : UIView


- (void)startAnimating;
- (void)stopAnimating;
@property (nonatomic , assign) BOOL isLoading;

@end


@interface BlankPageView : UIView

@property (nonatomic , weak) UITapImageView *logoView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UIButton *reloadButton;
@property (nonatomic , copy) void(^reloadButtonBlock)(id sender);

- (void)configWithType:(BlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;




@end
