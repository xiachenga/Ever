//
//  FashionShopCell.h
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShowcaseIndexResult.h"
@interface FashionShopCell : UITableViewCell



@property (nonatomic , strong) ShowcaseIndexResult *fashionCase;

@property (nonatomic , copy) void(^shopLogoviewClicked)();

@property (nonatomic , copy) void(^oneGoodViewClicked)();

@property (nonatomic , copy) void(^twoGoodViewClicked)();





@end
