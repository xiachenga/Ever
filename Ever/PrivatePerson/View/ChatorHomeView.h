//
//  ChatorHomeView.h
//  Ever
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserRelationResult;

@protocol ChatorHomeViewDelegate <NSObject>

- (void)chatOrHomeBtnClicked:(UIButton *)button withUser:(UserRelationResult*)user;

@end


@interface ChatorHomeView : UIView

@property (nonatomic , strong) UserRelationResult *user;

@property (nonatomic , weak) id<ChatorHomeViewDelegate> delegate;

-(void)show;

@end
