//
//  GediaoSegmentController.h
//  Ever
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KindItem.h"

typedef  NS_ENUM(NSInteger, Type) {
    typeZan=0,
    TypeComment
    
};

@interface GediaoSegmentController : UIViewController

@property (nonatomic , strong) KindItem *kindItem;

@property (nonatomic , assign) Type type;

@end
