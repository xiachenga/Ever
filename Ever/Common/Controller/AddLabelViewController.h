//
//  AddLabelViewController.h
//  Ever
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddLabelViewControllerDelegate <NSObject>

-(void)addLabelText:(NSString *)labelText color_type:(int)color_type;

@end
@interface AddLabelViewController : UIViewController

@property (nonatomic , weak) id<AddLabelViewControllerDelegate> delegate;

@end
