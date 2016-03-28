//
//  CommentCell.h
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KindItem.h"
@class CommentFrames;
@interface CommentCell : UITableViewCell

@property (nonatomic , strong) CommentFrames *commentFrame;

@property (nonatomic , weak) UITapImageView *userIconView;

@property (nonatomic , strong) KindItem *kindItem;



@end
