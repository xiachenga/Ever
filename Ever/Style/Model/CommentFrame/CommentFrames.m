//
//  CommentFrames.m
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


#define kPaddingLeftWidth 15.0
#define kCommentCell_FontContent [UIFont systemFontOfSize:15.0]
#import "CommentFrames.h"
#import "CommentResult.h"

@implementation CommentFrames


-(void)setComment:(CommentResult *)comment
{
    _comment=comment;
    CGFloat curBottomY = 10;
    CGFloat curWidth=kScreen_Width-45-2*kPaddingLeftWidth;
    self.userIconF=CGRectMake(kPaddingLeftWidth, curBottomY, 40, 40);
    self.nickNameLabelF=CGRectMake(CGRectGetMaxX(self.userIconF)+5, CGRectGetMinY(self.userIconF), 200, 18);
    
    self.timeLabelF=CGRectMake(kScreen_Width-kPaddingLeftWidth-70, CGRectGetMinY(self.userIconF), 100, 14);

   
    NSString *content;
    
    if (comment.replay_user_id==0) {
        content=comment.text_content;
    }else{
        content=[NSString stringWithFormat:@"回复 %@:%@",_comment.replay_user_nickname, _comment.text_content];
    }
    CGSize contentLabelSize=[content boundingRectWithSize:CGSizeMake(curWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    self.contentLabelF=(CGRect){{CGRectGetMinX(self.nickNameLabelF),CGRectGetMaxY(self.nickNameLabelF)+5},contentLabelSize};
    
    self.cellHeight=CGRectGetMaxY(self.contentLabelF)+10;
    
}

@end
