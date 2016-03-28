//
//  ReleaseaViewController.h
//  Ever
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AssetsLibrary/AssetsLibrary.h>

#import "KindItem.h"
typedef NS_ENUM(NSInteger, PhotoFromType) {
    
    PhotoFromTypeFigure=0,
    PhotoFromTypeGediao,
    PhotoFromTypeJournal,
    PhotoFromTypeAvatar,
    PhotoFromTypeCoffeeComment,
    
};

@interface ReleaseaViewController : UICollectionViewController

//判断是发表什么1 形象 2 格调 3 日记 4 头像 5coffee评论 6注册头像
//@property (nonatomic , assign) int type;

@property (nonatomic , assign) PhotoFromType photoFromType;

@property (nonatomic , strong) KindItem *kind;




@end
