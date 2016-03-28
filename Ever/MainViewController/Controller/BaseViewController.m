//
//  BaseViewController.m
//  Ever
//  主页面（有加号的页面）
//  Created by Mac on 15/5/30.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomFoldMenu.h"
#import "ReleaseaViewController.h" 
#import "TalkViewController.h"
#import "GlobalViewController.h"
#import "SystemSettingViewController.h"
#import "NewStatusSegViewController.h"
#import "RNGridMenu.h"
#import "SelectLocationViewController.h"


@interface BaseViewController ()<CustomFoldMenuDelegate,RNGridMenuDelegate>

@property (nonatomic , weak) UITapImageView *bgView;

@property (nonatomic , weak) UIButton *gediaoBtn,*rijiBtn;

@property (nonatomic , weak) UILabel *gediaoLabel,*rijiLabel ;

@end

@implementation BaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏左面的按钮
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuBtn_Nav"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    //导航栏右边的按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"moreBtn_Nav"] style:UIBarButtonItemStyleBordered target:self action:@selector(showFoldMenu)];
}


- (void)showMenu
{
  
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    
}

- (void)showFoldMenu
{
    CustomFoldMenu *foldMenu=[[CustomFoldMenu alloc]init];
    foldMenu.delegate=self;
    [foldMenu showMenu];
}

//点击照相机
- (void)tapCamera
{
    
    NSInteger numberOfOptions = 2;
    NSArray *items = @[
                       
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"fabu_zhaopian"] title:LOCALIZATION(@"PublishPhoto")],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"fabu_riji"] title:LOCALIZATION(@"PublishJournal")],
                       
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.animationDuration=0.5;
    av.cornerRadius=0;
    av.highlightColor=nil;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    

    
}

#pragma RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    
    
    if ([AccountTool isLogin]){
    
    if (itemIndex==0) {
        
        SelectLocationViewController *selectLocVC=[[SelectLocationViewController alloc]init];
        KindItem *kind=[[KindItem alloc]init];
        kind.kind=2;
        selectLocVC.kindItem=kind;
        [self.navigationController pushViewController:selectLocVC animated:YES];
    
       
    }else{
        

        
        SelectLocationViewController *selectLocVC=[[SelectLocationViewController alloc]init];
        KindItem *kind=[[KindItem alloc]init];
        kind.kind=3;
        selectLocVC.kindItem=kind;
        [self.navigationController pushViewController:selectLocVC animated:YES];
        
        
    }
        
    }else{
        
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
        
    }
}


- (void)miss
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.gediaoLabel.alpha=0;
        self.rijiLabel.alpha=0;
        self.gediaoBtn.alpha=0;
        self.rijiBtn.alpha=0;
        
        self.bgView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [self.gediaoLabel removeFromSuperview];
        [self.rijiLabel removeFromSuperview];
        [self.gediaoBtn removeFromSuperview];
        [self.rijiBtn removeFromSuperview];
        
    }];
}

- (void)addButton
{
    UIButton *gediaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gediaoBtn.frame=CGRectMake((kScreen_Width-100)*0.5, (kScreen_Height-200)/3, 100, 100);
    self.gediaoBtn=gediaoBtn;
    [gediaoBtn setImage:[UIImage imageNamed:@"zhedie_fabu_tanlun" ] forState:UIControlStateNormal];
    
    [self.navigationController.view addSubview:gediaoBtn];
    
    [gediaoBtn addTarget:self action:@selector(gediaoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *gediaoLabel=[[UILabel alloc]initWithFrame:CGRectMake((kScreen_Width-40)*0.5, CGRectGetMaxY(gediaoBtn.frame)+5, 40, 20)];
    gediaoLabel.text=@"照片";
    gediaoLabel.textColor=[UIColor whiteColor];
    gediaoLabel.font=[UIFont systemFontOfSize:20];
    self.gediaoLabel=gediaoLabel;
    [self.navigationController.view addSubview:gediaoLabel];
    
    
    
    UIButton *rijiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rijiBtn.frame=CGRectMake((kScreen_Width-100)*0.5, (kScreen_Height-200)/3*2+100, 100, 100);
    [rijiBtn setImage:[UIImage imageNamed:@"zhedie_fabu_tanlun"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:rijiBtn];
    self.rijiBtn=rijiBtn;
    [rijiBtn addTarget:self action:@selector(rijiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *rijiLabel=[[UILabel alloc]initWithFrame:CGRectMake((kScreen_Width-40)*0.5, CGRectGetMaxY(rijiBtn.frame)+5, 40, 20)];
    rijiLabel.text=@"日记";
    rijiLabel.textColor=[UIColor whiteColor];
    rijiLabel.font=[UIFont systemFontOfSize:20];
    self.rijiLabel=rijiLabel;
    [self.navigationController.view addSubview:rijiLabel];
    
     
    
}

- (void)gediaoBtnClicked
{
    [self miss];
    
    ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
    
    KindItem *kind=[[KindItem alloc]init];
    kind.kind=2;
    
    releaseVC.kind=kind;
    [self.navigationController pushViewController:releaseVC animated:YES];
    
}
- (void)rijiBtnClicked
{
    [self miss];
    TalkViewController *talkVC=[[TalkViewController alloc]init];
    [self.navigationController pushViewController:talkVC animated:YES];
    
}

- (void)selectButton:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
            if ([AccountTool isLogin]) {
                
                NewStatusSegViewController *newStatusSegVC=[[NewStatusSegViewController alloc]init];
                [self.navigationController pushViewController:newStatusSegVC animated:YES];
                
            }else
            {
                DoAlertView *alertView=[[DoAlertView alloc]init];
                [alertView show];
            }
           
        }
            break;
        case 2:
        {
            [MBProgressHUD showError:@"此功能还没有开放"];
            
        }
            break;
        case 3:
        {
            GlobalViewController *globalVC=[[GlobalViewController alloc]init];
            [self.navigationController pushViewController:globalVC animated:YES];
        }
            break;
            
        case 4:
        {
            SystemSettingViewController *systemVC=[[SystemSettingViewController alloc]init];
            [self.navigationController pushViewController:systemVC animated:YES];
            
            
        }
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
}


@end
