//
//  CommentFrames.h
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentResult;
@interface CommentFrames : NSObject

@property (nonatomic , assign) CGRect userIconF;

@property (nonatomic,assign) CGRect timeLabelF;

@property (nonatomic , assign) CGRect nickNameLabelF;

@property (nonatomic , assign) CGRect contentLabelF;

@property (nonatomic , strong) CommentResult *comment;

@property (nonatomic , assign) CGFloat cellHeight;

@end
