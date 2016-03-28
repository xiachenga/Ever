//
//  ShowcaseIndexResult.h
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowcaseIndexResult : NSObject

//cursorID 以此为依据
@property (nonatomic , assign) long bid;

//商家名
@property (nonatomic , copy) NSString *bname;

//是否关注了 false为没关注
@property (nonatomic , assign) BOOL if_focus;

//品牌中心URL链接地址
@property (nonatomic , copy) NSString *webview_url;

 //商家banner图
@property (nonatomic , copy) NSString *banner_image_url;

//是否加V了 false为没有加v
@property (nonatomic , assign) BOOL if_addv;

@property (nonatomic , copy) NSString *goods_image_one_url;

@property (nonatomic , copy) NSString *goods_image_two_url;
@end
