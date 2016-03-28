//
//  CollectionHeaderView.m
//  Ever
//
//  Created by Mac on 15-4-23.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CollectionHeaderView.h"

@interface CollectionHeaderView ()

@property (nonatomic,weak)UILabel *label;
@property (nonatomic , weak) UIImageView *arrowView;

@end

@implementation CollectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
       
        UIImageView *arrowView=[[UIImageView alloc
                                 ]init];
        arrowView.image=[UIImage imageNamed:@"tongxunlu_sanjiao"];
        [self addSubview:arrowView];
        self.arrowView=arrowView;
        
        UILabel *label=[[UILabel alloc]init];
        [self addSubview:label];
        self.label=label;
        label.font=[UIFont systemFontOfSize:20];
        
        [arrowView addSubview:label];
        }
    return self;
}

- (void)setFirst_letter:(NSString *)first_letter
{
    _first_letter=first_letter;
    _first_letter=[_first_letter uppercaseString];
    self.label.text=_first_letter;
    self.label.font=[UIFont systemFontOfSize:15];
    self.label.frame=CGRectMake(15, 5, 20, 20);
    
}



-(void)setLetterFrame:(CGRect)letterFrame
{
    self.arrowView.frame=letterFrame;
}


    

@end
