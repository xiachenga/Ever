//
//  CustomSearchBar.h
//  自定义SearchBar
//
//  Created by Mac on 15-3-26.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSearchBar : UITextField

@property (nonatomic , weak) NSString *leftImageName;
+ (instancetype)searchBar;

@end
