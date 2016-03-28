//
//  PersonDocumentViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "PersonDocumentViewController.h"
#import "MyDataViewController.h"
#import "MyFigureViewController.h"
#import "MyStyleViewController.h"
#import "MyTalkViewController.h"
#import "SystemSettingViewController.h"
#import "NewStatusSegViewController.h"
@interface PersonDocumentViewController ()



@property (nonatomic , weak) UIScrollView *scrollView;

@property (nonatomic , weak) UILabel *nickNameLabel,*EverIDLabel,*mieliLabel;

@property (nonatomic , weak) UIButton *myDataBtn,*myFigureBtn,*myStyleBtn,*myDairyBtn,*settingBtn,*StateButton;

@property (nonatomic , weak) UIImageView *avatarView;

@end

@implementation PersonDocumentViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarImageChanged) name:kNotificationAvatarImageChanged object:nil];
    
    
    //添加背景图片
    
    [self addBackgroundImage];
    
    
    //添加滑动图片
    [self addScrollView];
    
    
    //添加滑动图片上面的图像
    [self addAvataImage];
    
    //添加滑动图片上面的按钮
    [self addChildButton];
    
}

  //添加背景图片
- (void)addBackgroundImage
{
    UIImageView *backgroundView=[[UIImageView alloc]init];
    backgroundView.image=[UIImage imageNamed:@"gerendang_beijing.jpg"];
    backgroundView.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Height);
    [self.view addSubview:backgroundView];
    
}

 //添加滑动图片
- (void)addScrollView
{
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.frame=self.view.bounds;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.contentSize=CGSizeMake(0, 600);
    scrollView.bounces=YES;
    self.scrollView=scrollView;
    [self.view addSubview:scrollView];
    
}

//添加滑动图片上面个头像以及信息

- (void)addAvataImage
{
    LoginResult *account=[AccountTool account];
    
    NSURL *url=[NSURL URLWithString:account.user_head_image_url];
    UITapImageView *avataImageView=[[UITapImageView alloc]init];
    [avataImageView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:30];
    [avataImageView addTapBlock:^(id obj) {
        [self changeAvatar];
    }];
    [avataImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    self.avatarView=avataImageView;
    [self.scrollView addSubview:avataImageView];
    
    avataImageView.frame=CGRectMake((kScreen_Width-60)*0.5, 80, 60, 60);
    
    //昵称
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=account.user_nickname;
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.textColor=[UIColor whiteColor];
    CGSize nameLabelSize=[nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    nameLabel.frame=CGRectMake((kScreen_Width-nameLabelSize.width)*0.5,CGRectGetMaxY(avataImageView.frame)+5,nameLabelSize.width,15);
    
    [self.scrollView addSubview:nameLabel];
    
   
    
    //ever
    UILabel *everLabel=[[UILabel alloc]init];
    everLabel.textColor=[UIColor whiteColor];
    everLabel.font=[UIFont systemFontOfSize:15];
    everLabel.text=[NSString stringWithFormat:@" Ever:%ld",account.user_id];
    CGSize everLabelSize=[everLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    everLabel.frame=CGRectMake((kScreen_Width-everLabelSize.width)*0.5,CGRectGetMaxY(nameLabel.frame),everLabelSize.width,15);
    [self.scrollView addSubview:everLabel];
    
    //魅力
    UILabel *meiliLabel=[[UILabel alloc]init];
    meiliLabel.textColor=[UIColor whiteColor];
    meiliLabel.font=[UIFont systemFontOfSize:15];
    meiliLabel.text=[NSString stringWithFormat:@"魅力值:%d",account.meili_num];
    CGSize meiliLabelSize=[meiliLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    meiliLabel.frame=CGRectMake((kScreen_Width-meiliLabelSize.width)*0.5,CGRectGetMaxY(everLabel.frame)+5,meiliLabelSize.width,15);
    [self.scrollView addSubview:meiliLabel];
    
}

//添加滑动图片上面的按钮
- (void)addChildButton
{
    
    UIButton *newStateButton=[self setupChildButton:LOCALIZATION(@"GlobalFoldMenuNewStates") backgroundImage:@"gerendang_qipao_heise_you" target:@selector(newStateButtonClicked)];
    newStateButton.frame=CGRectMake(20, 200, 120, 50);
    self.StateButton=newStateButton;

    
    //我的资料
    UIButton *dataButton=[self setupChildButton:LOCALIZATION(@"PersonDocumentData") backgroundImage:@"gerendang_qipao_zuo_huangse" target:@selector(dataButtonClicked)];
    dataButton.frame=CGRectMake(kScreen_Width-120-20, 260, 120, 50);
    self.myDataBtn=dataButton;
    
    
    
    UIButton *figureButton=[self setupChildButton:LOCALIZATION(@"PersonDocumentFigure") backgroundImage:@"gerendang_qipao_you_huangse" target:@selector(figureButtonClicked)];
    figureButton.frame=CGRectMake(20, 320, 120, 50);
    self.myFigureBtn=figureButton;
    
    //我的格调
    
    UIButton *styleButton=[self setupChildButton:LOCALIZATION(@"PersonDocumentgediao") backgroundImage:@"gerendang_qipao_heise_zuo" target:@selector(styleButtonClicked)];
    styleButton.frame=CGRectMake(kScreen_Width-120-20, 380, 120, 50);
    self.myStyleBtn=styleButton;
    
    //我的日记
    
    UIButton *talkButton=[self setupChildButton:LOCALIZATION(@"PersonDocumentDiary")backgroundImage:@"gerendang_qipao_heise_you" target:@selector(talkButtonClicked)];
    talkButton.frame=CGRectMake(20 , 440, 120, 50);
    self.myDairyBtn=talkButton;
    
    //系统设置
    
    UIButton *settingButton=[self setupChildButton:LOCALIZATION(@"PersonDocumentSetting")backgroundImage:@"gerendang_qipao_zuo_huangse" target:@selector(settingButtonClicked)];
    settingButton.frame=CGRectMake(kScreen_Width-120-20, 500, 120, 50);;
    self.settingBtn=settingButton;
    
    
    for (int i=0; i<6; i++) {
        UIImageView *loopView=[[UIImageView alloc]init];
        loopView.image=[UIImage imageNamed:@"list_loop"];
        loopView.frame=CGRectMake(kScreen_Width*0.5-7, 260+i*60, 15, 15);
        [self.scrollView addSubview:loopView];
    }
    
}

- (UIButton *)setupChildButton:(NSString *)title backgroundImage:(NSString *)backgroundImage target:(SEL)selector
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    //设置高亮状态下不可点
    button.adjustsImageWhenHighlighted=NO;
    button.titleLabel.font=[UIFont systemFontOfSize:20.0f];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    return button;
    
}



- (void)newStateButtonClicked
{
    if ([AccountTool isLogin]) {
        
        NewStatusSegViewController *newStateVC=[[NewStatusSegViewController alloc]init];
        [self.navigationController pushViewController:newStateVC animated:YES];
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
    
   
}
- (void)dataButtonClicked
{
    
    if ([AccountTool isLogin]) {
        
        MyDataViewController *myDataVC=[[MyDataViewController alloc]init];
        [self.navigationController pushViewController:myDataVC animated:YES];
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
   
    
}

- (void)figureButtonClicked
{

    if ([AccountTool isLogin]) {
        
        MyFigureViewController *myFigureVC=[[MyFigureViewController alloc]init];
        [self.navigationController pushViewController:myFigureVC animated:YES];
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
   
    
    
}

- (void)styleButtonClicked
{

    if ([AccountTool isLogin]) {
        
        MyStyleViewController *myStyleVC=[[MyStyleViewController alloc]init];
        [self.navigationController pushViewController:myStyleVC animated:YES];
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
    
}
- (void)talkButtonClicked
{
   
    if ([AccountTool isLogin]) {
        
        MyTalkViewController *myTalkVC=[[MyTalkViewController alloc]init];
        [self.navigationController pushViewController:myTalkVC animated:YES];
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
   
    
}


- (void)settingButtonClicked
{

    SystemSettingViewController *systemSettingVC=[[SystemSettingViewController alloc]init];
    [self.navigationController pushViewController:systemSettingVC animated:YES];
}



- (void)changeAvatar
{
    MyDataViewController *myData=[[MyDataViewController alloc]init];
    [self.navigationController pushViewController:myData animated:YES];    
}


//语言切换
- (void)languageChange
{
    CLog(@"收到通知");
    
    [self.StateButton setTitle:LOCALIZATION(@"GlobalFoldMenuNewStates")  forState:UIControlStateNormal];
    [self.myDataBtn setTitle:LOCALIZATION(@"PersonDocumentData") forState:UIControlStateNormal];
    [self.myFigureBtn setTitle:LOCALIZATION(@"PersonDocumentFigure") forState:UIControlStateNormal];
    [self.myStyleBtn setTitle:LOCALIZATION(@"PersonDocumentgediao") forState:UIControlStateNormal];
    [self.myDairyBtn setTitle:LOCALIZATION(@"PersonDocumentDiary") forState:UIControlStateNormal];
    [self.settingBtn setTitle:LOCALIZATION(@"PersonDocumentSetting") forState:UIControlStateNormal];

}

//及时切换头像
- (void)avatarImageChanged
{
   
    LoginResult *account=[AccountTool account];
    
    NSURL *url=[NSURL URLWithString:account.user_head_image_url];
    
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationAvatarImageChanged object:nil];
}



@end
