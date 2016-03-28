//
//  PaoPaoAnnotation.h
//  Ever
//
//  Created by Mac on 15-1-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
@interface PaoPaoAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property(retain,nonatomic) NSDictionary *locationInfo;
@property(nonatomic,assign)NSInteger tag;
- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;

@end
