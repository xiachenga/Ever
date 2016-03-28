//
//  CustomLabel.h
//  Ever
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomLabel;
@protocol CustomLabelDelegate <NSObject>

- (void)labelDelete:(int)sender;

- (void)labelMovedendWithX:(double)X endWithY:(double)Y withViewTag:(int)tag;

@end
@interface CustomLabel : UIView

@property (nonatomic , weak)  id<CustomLabelDelegate> delegate;

@end
