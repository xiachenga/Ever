//
//  CustomReleaseView.h
//  Ever
//
//  Created by Mac on 15-3-19.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomReleaseViewDelegate <NSObject>

@optional

- (void)selectReleaseStyle;
- (void)selectReleaseTalk;

@end

@interface CustomReleaseView : UIView

@property (nonatomic , weak) id<CustomReleaseViewDelegate> delegate;


- (void)show;

@end
