//
//  AAShareBubbles.m
//  AAShareBubbles
//
//  Created by Almas Adilbek on 26/11/13.
//  Copyright (c) 2013 Almas Adilbek. All rights reserved.
//  https://github.com/mixdesign/AAShareBubbles
//

#import "AAShareBubbles.h"

@interface AACustomShareBubble : NSObject

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIColor *backgroundColor;
@end

@implementation AACustomShareBubble
@end

@interface AAShareBubbles()
@end

@implementation AAShareBubbles
{
    NSMutableArray *bubbles;
    NSMutableDictionary *bubbleIndexTypes;
   
}

- (id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView
{
    self = [super initWithFrame:CGRectMake(point.x - radiusValue, point.y - radiusValue, 2 * radiusValue, 2 * radiusValue)];
    if (self) {
        
        self.radius = radiusValue;
        self.bubbleRadius = 30;
        self.parentView = inView;
       
        self.facebookBackgroundColorRGB = 0x3c5a9a;
        self.twitterBackgroundColorRGB = 0x3083be;
        self.tumblrBackgroundColorRGB = 0x385877;
        self.youtubeBackgroundColorRGB = 0xce3025;
        self.vimeoBackgroundColorRGB = 0x00acf2;
        self.redditBackgroundColorRGB = 0xffffff;
        
    }
    return self;
}

#pragma mark -
#pragma mark Actions

-(void)buttonWasTapped:(UIButton *)button {
    int buttonType = [bubbleIndexTypes[@(button.tag)] intValue];
    [self shareButtonTappedWithType:buttonType];
}

-(void)shareButtonTappedWithType:(int)buttonType {
    [self hide];
    if([self.delegate respondsToSelector:@selector(aaShareBubbles:tappedBubbleWithType:)]) {
        [self.delegate aaShareBubbles:self tappedBubbleWithType:buttonType];
    }
}

#pragma mark -
#pragma mark Methods

-(void)show
{
    
    bubbles = [NSMutableArray array];
    bubbleIndexTypes = [NSMutableDictionary dictionary];
    
    [self createButtonWithIcon:@"fabu_biaoqian_aiqing" backgroundColor:self.youtubeBackgroundColorRGB andType:AAShareBubbleTypeFacebook];
    [self createButtonWithIcon:@"fabu_biaoqian_meishi" backgroundColor:self.redditBackgroundColorRGB andType:AAShareBubbleTypeTwitter];
    [self createButtonWithIcon:@"fabu_biaoqian_putong" backgroundColor:self.redditBackgroundColorRGB andType:AAShareBubbleTypeTumblr];
    [self createButtonWithIcon:@"fabu_biaoqian_renwu" backgroundColor:self.tumblrBackgroundColorRGB andType:AAShareBubbleTypeYoutube];
    [self createButtonWithIcon:@"fabu_biaoqian_weisuo" backgroundColor:self.facebookBackgroundColorRGB andType:AAShareBubbleTypeVimeo];
    [self createButtonWithIcon:@"fabu_biaoqian_yuyin_normal@2x" backgroundColor:self.twitterBackgroundColorRGB andType:AAShareBubbleTypeReddit];
    
    float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
    
    float bubblesBetweenAngel = 360 / bubbles.count;
    
    //开始的角度
    float startAngel = 180;
    
    NSMutableArray *coordinates = [NSMutableArray array];
    
    for (int i = 0; i < bubbles.count; ++i)
    {
        UIButton *bubble = bubbles[i];
        bubble.tag = i;
        
        CGFloat padding=(kScreen_Width-2*self.radius)*0.5;
        
        float angle = startAngel + i * bubblesBetweenAngel;
        float x = (float) (cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius)+padding;
        float y = (float) (sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius);
        
        [coordinates addObject:@{@"x" : @(x), @"y" : @(y)}];
        
        bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
        bubble.center = CGPointMake(self.radius, self.radius);
    }
    
    int inetratorI = 0;
    for (NSDictionary *coordinate in coordinates)
    {
        UIButton *bubble = bubbles[inetratorI];
        float delayTime = (float) (inetratorI * 0.1);
        [self performSelector:@selector(showBubbleWithAnimation:) withObject:@{@"button" : bubble, @"coordinate" : coordinate} afterDelay:delayTime];
        ++inetratorI;
    }
    
}

-(void)hide
{
    int inetratorI = 0;
    for (UIButton *bubble in bubbles)
    {
        CGFloat delayTime = (CGFloat) (inetratorI * 0.1);
        [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
        ++inetratorI;
    }
  
}

#pragma mark -
#pragma mark Helper functions

-(void)showBubbleWithAnimation:(NSDictionary *)info
{
    UIButton *bubble = (UIButton *) info[@"button"];
    
    [self.parentView addSubview:bubble];
    
    NSDictionary *coordinate = (NSDictionary *) info[@"coordinate"];
    
    [UIView animateWithDuration:0.2 animations:^{
        bubble.center = CGPointMake([coordinate[@"x"] floatValue], [coordinate[@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == bubbles.count - 1)
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
            }];
        }];
    }];
}
-(void)hideBubbleWithAnimation:(UIButton *)bubble
{
    [UIView animateWithDuration:0.2 animations:^{
        bubble.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            bubble.center = CGPointMake(self.radius, self.radius);
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            if(bubble.tag == bubbles.count - 1) {
                
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    [bubble removeFromSuperview];
                }];
            }
            
        }];
    }];
}

-(void)createButtonWithIcon:(UIImage *)icon backgroundColor:(UIColor *)color andButtonId:(int)buttonId
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 2 * self.bubbleRadius, 2 * self.bubbleRadius);
    

    [button setImage:icon forState:UIControlStateNormal];
    
    [bubbles addObject:button];
    bubbleIndexTypes[@(bubbles.count - 1)] = @(buttonId);
    
    [self addSubview:button];
}

-(void)createButtonWithIcon:(NSString *)iconName backgroundColor:(int)rgb andType:(AAShareBubbleType)type
{
    UIImage *icon = [UIImage imageNamed:iconName];
    UIColor *color = [self colorFromRGB:rgb];
    [self createButtonWithIcon:icon backgroundColor:color andButtonId:type];
}
//
-(UIColor *)colorFromRGB:(int)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}






@end
