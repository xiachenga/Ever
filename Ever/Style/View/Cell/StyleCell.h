//
//  StyleCell.h
//  Ever
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorldTagIndexResult;
@interface StyleCell : UICollectionViewCell

@property (nonatomic , strong) WorldTagIndexResult *style;

@property (nonatomic , weak) UIImageView *avatarImage;

@end
