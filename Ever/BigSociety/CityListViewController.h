//
//  CityListViewController.h
//  Ever
//
//  Created by Mac on 15-1-29.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CityListViewCotrollerDelegate <NSObject>

@optional
- (void)trsnsmitLocation:(NSString *)cityName;

@end


@interface CityListViewController : UIViewController

@property (nonatomic , strong) id<CityListViewCotrollerDelegate> delegate;



@end
