//
//  ImageResult.h
//  Ever
//
//  Created by Mac on 15-1-28.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelResult.h"

@interface ImageResult : NSObject

//完整图
@property (nonatomic , copy) NSString *image_url;

//图片ID
@property (nonatomic , assign) long image_id;

//标签单元

@property (nonatomic , strong) NSArray *labels;




@end
