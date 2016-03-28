//
//  Contactcell.h
//  Ever
//
//  Created by Mac on 15-4-23.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserRelationResult;
@interface Contactcell : UICollectionViewCell

@property (nonatomic , weak) UITapImageView *avatarView;

@property (nonatomic , strong) UserRelationResult *guanzhu;

@property (nonatomic , weak) UIImageView *redDotView;

@property (nonatomic , assign) BOOL showRedDotView;

@end
