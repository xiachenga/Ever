//
//  ArticleCommentController.h
//  Ever
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleCommentControllerDelegate <NSObject>

- (void)articleCommentSuccess;

@end

@interface ArticleCommentController : UIViewController

@property (nonatomic , assign) long articleID;


@property (nonatomic , weak) id<ArticleCommentControllerDelegate> delegate;

- (void)refresh;

@end
