//
//  PaoPaoView.h
//  Ever
//
//  Created by Mac on 15-1-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//



#import <BaiduMapAPI/BMKAnnotationView.h>
#import "WorldTagIndexResult.h"
@interface PaoPaoView : BMKAnnotationView

@property(nonatomic,strong)WorldTagIndexResult *markerModel;

@end
