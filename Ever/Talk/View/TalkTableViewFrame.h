//
//  TalkTableViewFrame.h
//  Ever
//
//  Created by Mac on 15-3-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JournalIndexResult;
@interface TalkTableViewFrame : NSObject


//头像frame
@property (nonatomic , assign) CGRect iconF;

//标题frame
@property (nonatomic , assign) CGRect titleF;


//时间frame

@property (nonatomic , assign) CGRect timeF;

//图片F
@property (nonatomic , assign) CGRect imageF;

//摘要frame
@property (nonatomic , assign) CGRect summaryF;

@property (nonatomic , assign) CGRect backgroundViewF;

@property (nonatomic , strong) JournalIndexResult *journalIndex;

@property (nonatomic , assign) CGFloat cellHeight;



@end
