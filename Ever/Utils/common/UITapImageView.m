//
//  UITapImageView.m
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "UITapImageView.h"

@interface UITapImageView ()

@property (nonatomic,copy)void (^tapAction)(id);

@property (nonatomic , copy) void (^longTapAction)(id);

@end
@implementation UITapImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}




-(void)addTapBlock:(void (^)(id))tapAction
{
    self.tapAction=tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}


- (void)addLongTapBlock:(void (^)(id))longTapAction{
    
    self.longTapAction=longTapAction;
    
    self.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longTap=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
    longTap.minimumPressDuration=1;
    
    [self addGestureRecognizer:longTap];

}

-(void)tap
{
    if (self.tapAction) {
        self.tapAction(self);
    }
    
}

//长时间点击
- (void)longTap:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        if(self.longTapAction){
            self.longTapAction(self);
        }
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
    }
    
   
    
    
}

- (void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void (^)(id))tapAction
{
    [self sd_setImageWithURL:imgUrl placeholderImage:placeholderImage];
    [self addTapBlock:tapAction];
    
    
}

@end
