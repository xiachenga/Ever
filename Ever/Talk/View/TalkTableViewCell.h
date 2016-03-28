//
//  TalkTableViewCell.h
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkTableViewFrame.h"
@class JournalIndexResult;
@interface TalkTableViewCell : UITableViewCell

@property (nonatomic , strong) JournalIndexResult *journalIndex;

@property (nonatomic , strong) TalkTableViewFrame *talkFrame;

@end
