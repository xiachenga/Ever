//
//  CustomPopbottomView.h
//  Ever
//
//  Created by Mac on 15-4-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomPopbottomViewDelegate <NSObject>

@optional
-(void)didSelected:(UIButton *)button;

@end

@interface CustomPopbottomView : UIView

@property (nonatomic , weak) id<CustomPopbottomViewDelegate> deletate;

-(void)showPopView;

- (void)dismiss;


@end
