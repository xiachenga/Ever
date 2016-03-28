//
//  CEOViewController.m
//  Ever
//
//  Created by Mac on 15-3-13.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CEOViewController.h"
#import "BlogViewController.h"
#import "FeedBackViewController.h"

@interface CEOViewController ()

@property(nonatomic,weak)UIButton *blogBtn,*feedBackBtn,*callCeoBtn;
@end

@implementation CEOViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.title=@"关于EVER";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //添加头像
    [self addAvatarImage];
    
    [self addButton];
}


/**
 *  添加头像
 */
- (void)addAvatarImage
{
    UIImageView *avatarImage=[[UIImageView alloc]init];
    avatarImage.image=[UIImage imageNamed:@"EVERLogo"];
    [self.view addSubview:avatarImage];
    

  
    avatarImage.frame=CGRectMake(kScreen_Width*0.5-50, 100, 100, 100);
    avatarImage.layer.cornerRadius=5;
    avatarImage.layer.masksToBounds=YES;
   
    
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"EVER";
    label.font=[UIFont systemFontOfSize:25];
    label.frame=CGRectMake(kScreen_Width*0.5-50, CGRectGetMaxY(avatarImage.frame)+10, 100, 30);
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *versionLabel=[[UILabel alloc]init];
    versionLabel.text=@"1.0.1版本";
    versionLabel.font=[UIFont systemFontOfSize:15];
    versionLabel.textColor=[UIColor grayColor];
    versionLabel.frame=CGRectMake(kScreen_Width*0.5-50, CGRectGetMaxY(label.frame)+10, 100, 20);
    versionLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UILabel *descLabel=[[UILabel alloc]init];
    descLabel.text=@"版本所有@上海奇狐信息科技有限公司";
    descLabel.textColor=[UIColor grayColor];
    descLabel.font=[UIFont systemFontOfSize:15];
    descLabel.textAlignment=NSTextAlignmentCenter;
    descLabel.frame=CGRectMake(0, CGRectGetMaxY(versionLabel.frame), kScreen_Width, 20);
    [self.view addSubview:descLabel];
    
}

/**
 *  添加下面的button
 */
- (void)addButton
{
    //关注微博button
    UIButton *blogButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image=[UIImage resizedImageWithName:@"paihangbang_beijing"];

    
    [blogButton setTitle:LOCALIZATION(@"SystemGuanzhuSina") forState:UIControlStateNormal];
    blogButton.adjustsImageWhenHighlighted=NO;
    [blogButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [blogButton setBackgroundImage:image forState:UIControlStateNormal];
    [blogButton setFrame:CGRectMake(10, kScreen_Height-180, kScreen_Width-2*10, 40)];
    [blogButton addTarget:self action:@selector(blogButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
    self.blogBtn=blogButton;
    [self.view addSubview:blogButton];
    
    //意见反馈
    UIButton *feedBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [feedBackButton setTitle:LOCALIZATION(@"SystemFeedBack") forState:UIControlStateNormal];
   
    [feedBackButton setBackgroundImage:image forState:UIControlStateNormal];
    feedBackButton.adjustsImageWhenHighlighted=NO;
    [feedBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [feedBackButton setFrame:CGRectMake(10, CGRectGetMaxY(blogButton.frame)+20, kScreen_Width-2*10, 40)];
    [feedBackButton addTarget:self action:@selector(feedBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.feedBackBtn=feedBackButton;
    [self.view addSubview:feedBackButton];
    
    //电话按钮
    UIButton *callButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *CEOCallBg=[UIImage resizedImageWithName:@"dashehui_anniu_huang"];
    [callButton setBackgroundImage:CEOCallBg forState:UIControlStateNormal];
    callButton.adjustsImageWhenHighlighted=NO;
    [callButton setTitle:LOCALIZATION(@"SystemCallCeo") forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton setFrame:CGRectMake(10, CGRectGetMaxY(feedBackButton.frame)+20, kScreen_Width-2*10, 40)];
    [callButton addTarget:self action:@selector(callButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.callCeoBtn=callButton;
    [self.view addSubview:callButton];
    
    
}

//进入微博
- (void)blogButtonClicked
{
    BlogViewController *blogVC=[[BlogViewController alloc]init];
    [self.navigationController pushViewController:blogVC animated:YES];
    
}

//意见反馈
- (void)feedBackButtonClicked
{
    FeedBackViewController *feedBackVC=[[FeedBackViewController alloc]init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
    
}

- (void)callButtonClicked
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18838048296"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}


- (void)languageChange
{
    
    
    [self.blogBtn setTitle:LOCALIZATION(@"SystemGuanzhuSina") forState:UIControlStateNormal];
    [self.feedBackBtn setTitle:LOCALIZATION(@"SystemFeedBack") forState:UIControlStateNormal];
    [self.blogBtn setTitle:LOCALIZATION(@"SystemCallCeo") forState:UIControlStateNormal];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}

@end
