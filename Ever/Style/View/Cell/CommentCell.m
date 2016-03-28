//
//  CommentCell.m
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//好好学习，好好做人

#define kPaddingLeftWidth 15.0
#define kCommentCell_FontContent [UIFont systemFontOfSize:15.0]

#import "CommentCell.h"
#import "CommentResult.h"
#import "CommentFrames.h"
#import "PersonhomeViewController.h"
#import "CommentViewController.h"
@interface CommentCell ()

@property (nonatomic , weak) UILabel *nickNameLabel,*timeLabel,* contentLabel;

@end

@implementation CommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
         self.selectionStyle=UITableViewCellSelectionStyleNone;
       
        //用户的头像
        if (!_userIconView) {
            UITapImageView * userIconView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            
            self.userIconView=userIconView;
            [self.userIconView doCircleFrame];
            [self.contentView addSubview:self.userIconView];
        }
        
        
        //用户昵称
        if (!_nickNameLabel) {
            UILabel *nickNameLabel=[[UILabel alloc]init];
            self.nickNameLabel=nickNameLabel;
            nickNameLabel.font=[UIFont systemFontOfSize:18];
            [self.contentView addSubview:nickNameLabel];
            
        }
        
        if(!_timeLabel)
        {
            UILabel *timeLabel=[[UILabel alloc]init];
            self.timeLabel=timeLabel;
            timeLabel.font=[UIFont systemFontOfSize:12];
            timeLabel.textColor=[UIColor grayColor];
            [self.contentView addSubview:timeLabel];
            
        }
        
        //评论的内容
       
        if (!_contentLabel) {
            UILabel *contentLabel=[[UILabel alloc]init];
            self.contentLabel=contentLabel;
            contentLabel.font=[UIFont systemFontOfSize:15];
            contentLabel.font=kCommentCell_FontContent;
            contentLabel.textColor=[UIColor grayColor];
            [self.contentView addSubview:contentLabel];
            
        }
    }
    return self;
}

- (void)setCommentFrame:(CommentFrames *)commentFrame
{
    _commentFrame=commentFrame;
    NSURL *imageurl=[NSURL URLWithString:commentFrame.comment.user_head_image_url];
    [self.userIconView sd_setImageWithURL:imageurl placeholderImage:nil];

    
    self.nickNameLabel.text=commentFrame.comment.user_nickname;
    
    self.contentLabel.numberOfLines=0;
    
    if (commentFrame.comment.replay_user_id==0) {
        
        self.contentLabel.text=commentFrame.comment.text_content;
    }else
    {
        NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复#%@#:%@",commentFrame.comment.replay_user_nickname,commentFrame.comment.text_content]];
        NSRange range=NSMakeRange(0, [[string string]rangeOfString:@":"].location+1);
        [string addAttributes:@{NSForegroundColorAttributeName:kThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:15]} range:range];
        [self.contentLabel setAttributedText:string];
    }
    
    self.timeLabel.text=commentFrame.comment.create_time;
    
    if (_commentFrame.comment.replay_user_id!=0) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(CGRectGetMinX(self.commentFrame.contentLabelF), CGRectGetMinY(self.commentFrame.contentLabelF),(_commentFrame.comment.replay_user_nickname.length)*15, 20);
        [button addTarget:self action:@selector(gotoPersonhome) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:button];
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
   
    self.userIconView.frame=self.commentFrame.userIconF;
    
    self.nickNameLabel.frame=self.commentFrame.nickNameLabelF;
    
    self.timeLabel.frame=self.commentFrame.timeLabelF;
    
    self.contentLabel.frame=self.commentFrame.contentLabelF;
    
}

-(void)gotoPersonhome
{
    UIViewController *controlelr;
    if (self.kindItem.kind==2||self.kindItem.kind==3) {
        
      controlelr =[self viewController];
    }else{
        CommentViewController *tableController=(CommentViewController *)[self viewController];
        controlelr =[tableController viewController];
    }
    
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=_commentFrame.comment.replay_user_id;

    [controlelr.navigationController pushViewController:personhomeVC animated:YES];
    
}

- (UIViewController*)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
