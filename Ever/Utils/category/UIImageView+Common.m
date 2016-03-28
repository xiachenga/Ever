//
//  UIImageView+Common.m
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "UIImageView+Common.h"

@implementation UIImageView (Common)

-(void)doCircleFrame
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=self.frame.size.width/2;
    self.layer.borderWidth=0.5;
    self.layer.borderColor=[UIColor whiteColor].CGColor;
}

- (void)doNotCircleFrame
{
    self.layer.cornerRadius=0.0;
    self.layer.borderWidth=0.0;
    
}

- (void)doCirclebead
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=5;
}

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=cornerRadius;
    self.layer.borderWidth=width;
    if (!color) {
        self.layer.borderColor=[UIColor whiteColor].CGColor;
        
    }else
    {
        self.layer.borderColor=color.CGColor;
        
    }
    
}

@end
