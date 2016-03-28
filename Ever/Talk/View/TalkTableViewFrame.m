//
//  TalkTableViewFrame.m
//  Ever
//
//  Created by Mac on 15-3-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "TalkTableViewFrame.h"
#import "JournalIndexResult.h"
@implementation TalkTableViewFrame



-(void)setJournalIndex:(JournalIndexResult *)journalIndex
{
    
    _journalIndex=journalIndex;
    
    //
   
    
    
    //头像
    CGFloat iconX =10;
    CGFloat iconY = 10;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    self.iconF=CGRectMake(iconX, iconY, iconW, iconH);
    
    //标题
    CGFloat titleX=CGRectGetMaxX(self.iconF)+5;
    CGFloat titleY=iconY;
 //   CGSize titleSize=[journalIndex.title_text_content sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(kScreen_Width-titleX-10, MAXFLOAT)];
    CGSize titleSize=[journalIndex.title_text_content boundingRectWithSize:CGSizeMake(kScreen_Width-titleX-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.titleF=(CGRect){{titleX,titleY},titleSize};
    
    //时间
    CGFloat timeX=titleX;
    CGFloat timeY=CGRectGetMaxY(self.titleF);
    self.timeF=CGRectMake(timeX, timeY, 150, 15);
    
    //内容
    CGFloat contextX=iconX;
    CGFloat contextY=(CGRectGetMaxY(self.iconF)>CGRectGetMaxY(self.timeF))?CGRectGetMaxY(self.iconF):CGRectGetMaxY(self.timeF);
    
    
    
    if (journalIndex.if_has_image==0) {
        
        CGSize contextSize=[journalIndex.summary_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width-iconX-12, MAXFLOAT)];
        
        
        self.summaryF=(CGRect){{contextX,contextY},contextSize};
        
        
        
    }else
    {
        
        CGSize contextSize=[journalIndex.summary_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width-16-iconX-60, MAXFLOAT)];
        self.summaryF=(CGRect){{contextX,contextY},contextSize};
        
        self.imageF=CGRectMake(kScreen_Width-16-55, CGRectGetMaxY(self.timeF), 50, 50);
     }
   
    
    
    self.cellHeight=(CGRectGetMaxY(self.summaryF)>CGRectGetMaxY(self.imageF))?CGRectGetMaxY(self.summaryF)+5:CGRectGetMaxY(self.imageF)+5;
    
    self.backgroundViewF=CGRectMake(8, 0, kScreen_Width-16, self.cellHeight);
    
    
}

@end
