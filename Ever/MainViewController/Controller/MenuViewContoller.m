//
//  MenuViewContoller1.m
//  Ever
//
//  Created by Mac on 15-1-2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "MenuViewContoller.h"
#import "BaseNavigationController.h"
#import "FashionShoppingViewController.h"
#import "SegmentControlViewController.h"
#import "ArticleIndexResultViewController.h"
#import "AccountTool.h"
#import "LoginResult.h"
#import "Localisator.h"
#import "MyDataViewController.h"

@interface MenuViewContoller ()

@property (nonatomic,weak)UIView *childView;
@property (nonatomic,weak)UIButton *selectedButton;
@property (nonatomic , assign) BOOL fashionVCIsShow,styleVCIsShow,talkSegVCIsShow,coffeeIsShow;
@property (nonatomic , strong) SegmentControlViewController *segmentControlVC;


@property (nonatomic , strong) FashionShoppingViewController *fashionVC;

@property (nonatomic , weak) UIButton *timeButton,*coffeeBtn,*gediaoBtn,*priceBtn;

@property (nonatomic , strong) ArticleIndexResultViewController *articleVC ;

@property (nonatomic , weak) UIImageView *avatarView;


@end

@implementation MenuViewContoller


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor=kThemeColor;
    
    //初始化子控制器
   [self initWithChildView];
    
 //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //头像更改通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarviewChanged) name:kNotificationAvatarImageChanged object:nil];
    
    
   
    _segmentControlVC=(SegmentControlViewController *)self.mm_drawerController.centerViewController.childViewControllerForStatusBarHidden;
}

/**
 *  初始化菜单上面的子控制器
 */

- (void)initWithChildView

{
    LoginResult *account=[AccountTool account];
    //设置头像
    UITapImageView *avatarView=[[UITapImageView alloc]initWithFrame:CGRectMake(50, 50 ,  100,  100)];
    [avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:50];
    [avatarView addTapBlock:^(id obj) {
        [self avatarViewClicked];
    }];
    NSURL *url=[NSURL URLWithString:account.user_head_image_url];
    [avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    self.avatarView=avatarView;
    [self.view addSubview:avatarView];
    
    
    CGFloat buttonHeight=(kScreen_Height-180)*0.25;
    
    //私人时光
    UIButton *timeButton=[self buttonWithImage:@"menu_si_ren_shi_guang" selectedImage:@"menu_si_ren_shi_guang_selected" title:LOCALIZATION(@"RefrostedMenusirenshiguagnBtn") target:self action:@selector(timeButtonClicked:)];
    
    [timeButton setFrame:CGRectMake(40, CGRectGetMaxY(avatarView.frame)+15, 150, buttonHeight)];
    
    self.timeButton=timeButton;
    [self buttonClicked:timeButton];
    
    //Coffee
    UIButton *talkButton=[self buttonWithImage:@"menu_coffee" selectedImage:@"meun_coffee_selected" title:LOCALIZATION(@"RefrostedMenuCoffeeBtn") target:self action:@selector(talkButtonClicked:)];
    [talkButton setFrame:CGRectMake(40, CGRectGetMaxY(timeButton.frame), 150, buttonHeight)];
    self.coffeeBtn=talkButton;
 
    
    //格调
    UIButton *styleButton=[self buttonWithImage:@"menu_ge_diao" selectedImage:@"menu_ge_diao_selected" title:LOCALIZATION(@"RefrostedMenuMygediaoBtn") target:self action:@selector(styleButtonClicked:)];
    self.styleButton=styleButton;
    
    [styleButton setFrame:CGRectMake(40, CGRectGetMaxY(talkButton.frame), 150, buttonHeight)];
    self.gediaoBtn=styleButton;
    
    //发现优品
    UIButton *societyButton=[self buttonWithImage:@"menu_search" selectedImage:@"menu_search_selected" title:LOCALIZATION(@"RefrostedMenuPriceBtn") target:self action:@selector(societyButtonClicked:)];
    
    [societyButton setFrame:CGRectMake(40, CGRectGetMaxY(styleButton.frame), 150, buttonHeight)];
    
    self.priceBtn=societyButton;
    
  //  添加下面的线
    for (int i=0; i<4;i++ ) {
        
        [self addlineInChildView:i];
    }
}

- (UIButton *)buttonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed: selectedImage] forState:UIControlStateSelected];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    

    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    if (kDevice_Is_iPhone4||kDevice_Is_iPhone5) {
         button.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    }else{
        button.titleLabel.font=[UIFont boldSystemFontOfSize:24];
    }
    
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}


- (void)addlineInChildView:(int)i
{
    CGFloat buttonHeight=(kScreen_Height-180)*0.25;
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10 , CGRectGetMaxY(self.timeButton.frame)+i*buttonHeight, 180, 1)];
    line.backgroundColor=[UIColor colorWithHexString:@"f2b11c"];
    
    [self.view addSubview:line];
}

- (void)buttonClicked:(UIButton *)button

{
    
    self.selectedButton.selected=NO;
    button.selected=YES;
    self.selectedButton=button;
}

/**
 *  私人时光
 *
 *  @param button <#button description#>
 */
- (void)timeButtonClicked:(UIButton *)button
{
    
    [self buttonClicked:button];
    
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        BaseNavigationController *nav =(BaseNavigationController *)self.mm_drawerController.centerViewController;
        nav.viewControllers=@[_segmentControlVC];
        
    }];
    
    
    //隐藏menu
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
}


- (void)societyButtonClicked:(UIButton *)button
{
    [self buttonClicked:button];
    
    
    UINavigationController *searchNav=[[UINavigationController alloc]init];
    
    
     searchNav = (UINavigationController *)self.mm_drawerController.centerViewController;
    
    if (self.fashionVCIsShow) {
        
    }else{
    
       FashionShoppingViewController *fashionVC=[[FashionShoppingViewController alloc]init];
        self.fashionVC=fashionVC;
        _fashionVCIsShow=YES;
    }
    
   searchNav.viewControllers=@[_fashionVC];
   [self.mm_drawerController closeDrawerAnimated:YES completion:nil];    
   
}



/**
 *  格调
 *
 *  @param button <#button description#>
 */
- (void)styleButtonClicked:(UIButton *)button
{
    [self buttonClicked:button];

    BaseNavigationController *styleSegNav = (BaseNavigationController *)(BaseNavigationController *)self.mm_drawerController.centerViewController;
    
    if (self.styleVCIsShow) {
        
        
    }else{
    
        RootViewController *rootVC=[[RootViewController alloc]init];
        self.styleVC=rootVC;
        self.styleVCIsShow=YES;
        
    }
    
   styleSegNav.viewControllers=@[_styleVC];
   
    //隐藏menu
     [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

/**
 *  谈论
 *
 *  @param button <#button description#>
 */
- (void)talkButtonClicked:(UIButton *)button
{
    [self buttonClicked:button];
    
    
    BaseNavigationController *talkSegNav = (BaseNavigationController *)(BaseNavigationController *)self.mm_drawerController.centerViewController;
    
    if (self.coffeeIsShow) {
        
    }else{
    

        ArticleIndexResultViewController *articleVC=[[ArticleIndexResultViewController alloc]init];
        self.articleVC=articleVC;
        self.coffeeIsShow=YES;
        
    }
    
    talkSegNav.viewControllers=@[_articleVC];
    
    
    //隐藏menu
   [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
    
}



- (void) avatarViewClicked
{
    

    [self timeButtonClicked:self.timeButton];
   
}


//语言变换
- (void)languageChange
{
    CLog(@"收到通知");
    
    [self.timeButton setTitle:LOCALIZATION(@"RefrostedMenusirenshiguagnBtn") forState:UIControlStateNormal];
    [self.coffeeBtn setTitle:LOCALIZATION(@"RefrostedMenuCoffeeBtn") forState:UIControlStateNormal];
    [self.gediaoBtn setTitle:LOCALIZATION(@"RefrostedMenuMygediaoBtn") forState:UIControlStateNormal];
    [self.priceBtn setTitle:LOCALIZATION(@"RefrostedMenuPriceBtn") forState:UIControlStateNormal];
}


- (void)avatarviewChanged
{
    CLog(@"收到更改头像的通知");
     LoginResult *account=[AccountTool account];
     NSURL *url=[NSURL URLWithString:account.user_head_image_url];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}




@end
