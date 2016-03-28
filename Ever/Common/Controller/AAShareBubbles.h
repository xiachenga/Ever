//
//  AAShareBubbles.h
//  AAShareBubbles
//
//  Created by Almas Adilbek on 26/11/13.
//  Copyright (c) 2013 Almas Adilbek. All rights reserved.
//  https://github.com/mixdesign/AAShareBubbles
//

#import <UIKit/UIKit.h>

@protocol AAShareBubblesDelegate;

typedef enum AAShareBubbleType : int {
    AAShareBubbleTypeFacebook = 0,
    AAShareBubbleTypeTwitter = 1,
    AAShareBubbleTypeTumblr = 2,
    AAShareBubbleTypeYoutube = 3,
    AAShareBubbleTypeVimeo = 4,
    AAShareBubbleTypeReddit = 5,
    
    
} AAShareBubbleType;

@interface AAShareBubbles : UIView

@property (nonatomic, assign) id<AAShareBubblesDelegate> delegate;

// The radius from center point to each share button
@property (nonatomic, assign) int radius;

// Bubble button radius
@property (nonatomic, assign) int bubbleRadius;

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, assign) int facebookBackgroundColorRGB;
@property (nonatomic, assign) int twitterBackgroundColorRGB;
@property (nonatomic, assign) int tumblrBackgroundColorRGB;
@property (nonatomic, assign) int youtubeBackgroundColorRGB;
@property (nonatomic, assign) int vimeoBackgroundColorRGB;
@property (nonatomic, assign) int redditBackgroundColorRGB;


-(id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView;
-(void)show;
-(void)hide;

@end

@protocol AAShareBubblesDelegate<NSObject>

@optional

// On buttons pressed
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType;

// On bubbles hide
-(void)aaShareBubblesDidHide:(AAShareBubbles *)shareBubbles;
@end
