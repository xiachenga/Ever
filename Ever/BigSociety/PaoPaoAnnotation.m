//
//  PaoPaoAnnotation.m
//  Ever
//
//  Created by Mac on 15-1-27.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "PaoPaoAnnotation.h"

@implementation PaoPaoAnnotation

- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon {
	if (self = [super init]) {
		self.latitude = lat;
		self.longitude = lon;
	}
	return self;
}

-(CLLocationCoordinate2D)coordinate{
    
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}


@end
