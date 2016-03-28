//
//  BusinessIndexResult.h
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BusinessIndexResult : AppBeanResultBase

//banner图片URL
@property (nonatomic , copy) NSString *banner_image_url;

@property (nonatomic , assign) int shoucang_num;

//品牌名称
@property (nonatomic , copy) NSString *bname;

//所在地

@property (nonatomic , copy) NSString *bcity;

@property (nonatomic , copy) NSString *brandTypeName;

@property (nonatomic , copy) NSString *introduce;

//商家ID
@property (nonatomic , assign) long bid;


@property (nonatomic , assign) BOOL if_focus;

  //品牌中心的外链地址
@property (nonatomic , copy) NSString *webview_url;

@property (nonatomic , strong) NSArray *headimageResults;

@property (nonatomic , strong) NSArray *tuijianList;


@end
