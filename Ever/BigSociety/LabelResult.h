//
//  LabelResult.h
//  Ever
//
//  Created by Mac on 15-1-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelResult : NSObject

@property (nonatomic , assign) long label_id;

@property (nonatomic , assign) int color_type;

//标签上的文字
@property (nonatomic , assign) NSString *text_name;

@property (nonatomic , assign) double topMargin;

@property (nonatomic , assign) double leftMargin;

@property (nonatomic , assign) int icon_type;

@property (nonatomic , strong) NSString *voice_url;

@property (nonatomic , assign) int voice_time;

@end
