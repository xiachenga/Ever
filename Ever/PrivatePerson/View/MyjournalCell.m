//
//  MyjournalCell.m
//  Ever
//
//  Created by Mac on 15-5-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "MyjournalCell.h"
#import "MyJournalIndexResult.h"

@interface MyjournalCell ()

@property(nonatomic,weak)UILabel *titleLabel;

@property (nonatomic , weak) UILabel  *timeLabel;

@end

@implementation MyjournalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
         [self addLineUp:YES andDown:NO];
        
        
//        UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
//        UIImage *image=[UIImage resizedImageWithName:@"paihangbang_beijing"];
//        bgView.image=image;
//        [self.contentView addSubview:bgView];
        
        
        //题目
        
        UILabel *titleLabel=[[UILabel alloc]init];
        [self.contentView addSubview:titleLabel];
        titleLabel.font=[UIFont systemFontOfSize:18];
        self.titleLabel=titleLabel;
        
        //时间
        UILabel *timeLabel=[[UILabel alloc]init];
        [self.contentView addSubview:timeLabel];
        timeLabel.font=[UIFont systemFontOfSize:15];
        timeLabel.textColor=[UIColor grayColor];
        self.timeLabel=timeLabel;
        
        //向右箭头
        UIImageView *arrowRight=[[UIImageView alloc]init];
        arrowRight.image=[UIImage imageNamed:@"tongxunlu_jiantou"];
        arrowRight.frame=CGRectMake(kScreen_Width-30, 18, 24, 24);
        [self.contentView addSubview:arrowRight];
        
    }
    return self;
}


-(void)setJournalIndex:(MyJournalIndexResult *)journalIndex
{
    
    _journalIndex=journalIndex;
    
    CGFloat leftMargin=10;
    self.titleLabel.text=journalIndex.title_text_content;
    self.titleLabel.frame=CGRectMake(leftMargin, 10, kScreen_Width, 18);
    
    self.timeLabel.text=journalIndex.time;
    self.timeLabel.frame=CGRectMake(leftMargin, CGRectGetMaxY(self.titleLabel.frame)+10, kScreen_Width, 12);
    
}

@end
