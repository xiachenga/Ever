//
//  ThreeUserCell.h
//  Ever
//
//  Created by Mac on 15-5-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreeUserCellDelegate<NSObject>

@optional

- (void)gotoPersonhomeWithUserid:(long)userid;

@end

@interface ThreeUserCell : UITableViewCell

@property (nonatomic , strong) NSArray *threeUserArray;

@property (nonatomic , weak) id<ThreeUserCellDelegate> delegate;

@end
