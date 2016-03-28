//
//  AddSoundViewController.h
//  Ever
//
//  Created by Mac on 15-5-19.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSoundViewControllerDelegate <NSObject>

- (void)selectColor_type:(int)color_type pathForAudio:(NSURL *)pathForAudio lastTime:(int)time;

@end

@interface AddSoundViewController : UIViewController

@property (nonatomic , weak) id<AddSoundViewControllerDelegate> delegate;


@end
