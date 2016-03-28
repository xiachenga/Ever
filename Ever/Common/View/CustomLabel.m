//
//  CustomLabel.m
//  Ever
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomLabel.h"

@interface CustomLabel ()<UIAlertViewDelegate>

@end

@implementation CustomLabel


-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        UILongPressGestureRecognizer *longGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesClicked:)];
       
        [self addGestureRecognizer:longGesture];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CLog(@"点击label");
    

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CLog(@"开始移动了");
    
    UITouch *touch=[touches anyObject];
    CGPoint touchPoint=[touch locationInView:self.superview];
    self.center= CGPointMake(touchPoint.x, touchPoint.y);
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint touchPoint=[touch locationInView:self.superview];
    
    if ([self.delegate respondsToSelector:@selector(labelMovedendWithX:endWithY:withViewTag:)]) {
        
        [self.delegate labelMovedendWithX:touchPoint.x endWithY:touchPoint.y withViewTag:self.tag];
    }
    
    
   
}

- (void)longGesClicked:(UIGestureRecognizer *)longGesture
{
    if(longGesture.state==UIGestureRecognizerStateBegan)
    {
    
    CLog(@"长时间按了");
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"你要删除吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (buttonIndex==0) {
        CLog(@"不删除");
    }else
    {
        CLog(@"删除");
        
        [self removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(labelDelete:)]) {
            [self.delegate labelDelete:self.tag];
        }
    }
}




@end
