//
//  CustomFoldMenu.m
//  Ever
//
//  Created by Mac on 15-1-6.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CustomFoldMenu.h"


@interface CustomFoldMenu ()

@property (nonatomic , weak) UIButton *cover,*stateButton,*erweimaButton,*globalButton,*settingButton;
@property (nonatomic , weak) UIImageView *menuView;
@end

@implementation CustomFoldMenu

- (id)init
{
    self=[super init];
    if (self) {
        
        //注册一个通知
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
        
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加一个遮盖按钮
        UIButton *cover=[[UIButton alloc]init];
        cover.backgroundColor=[UIColor clearColor];
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        self.cover=cover;
        
        //添加带箭头的菜单图片
        [self initWithMenuView];
    }
    return self;
   
    
}

//初始化加号点击后的menu菜单，可以在此调整他的frame
- (void)initWithMenuView
{
    UIImageView *menuView=[[UIImageView alloc]init];
    menuView.frame=CGRectMake(kScreen_Width-180-10, 70, 180, 255);
    menuView.userInteractionEnabled=YES;
    menuView.image=[UIImage imageNamed:@"zhedie_background"];
    [self addSubview:menuView];
    self.menuView=menuView;
    
    //折叠菜单上面的照相机
   [self initWithCameraImage];
    
    //折叠上面的按钮
    [self addButton];
    
}

- (void)initWithCameraImage
{
    UIImageView *cameraView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)
                             ];
    cameraView.image=[UIImage imageNamed:@"zhedie_camera"];
    cameraView.userInteractionEnabled=YES;
    cameraView.center=CGPointMake(180/2, 110/2);
    [self.menuView addSubview:cameraView];
    cameraView.userInteractionEnabled=YES;
    UITapGestureRecognizer *cameraTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraClicked)];
    [cameraView addGestureRecognizer:cameraTap];
 
    
    self.cameraView=cameraView;
    
}

//添加折叠上面的按钮
- (void)addButton
{
  
    //最新动态
    UIButton *stateButton= [self buttonWithSubViews:LOCALIZATION(@"GlobalFoldMenuNewStates")  image:@"zhedie_dong_tai"  selectedImage:@"zhedie_dong_tai_selected" frame:CGRectMake(30,100,120,50)  action:@selector(buttonClicked:)];
    self.stateButton=stateButton;
   
    stateButton.tag=1;
    
//    //二维码
//    UIButton *erweimaButton=[self buttonWithSubViews:LOCALIZATION(@"GlobalFoldMenuerewima") image:@"zhedie_erweima_selected" selectedImage:@"zhedie_erweima" frame:CGRectMake(30,CGRectGetMaxX(stateButton.frame),120,50) action:@selector(buttonClicked:)];
//    self.erweimaButton=erweimaButton;
//    erweimaButton.tag=2;
    
    //全球榜
    UIButton *globalButton =[self buttonWithSubViews:LOCALIZATION(@"GlobalFoldMenuWorldbang")image:@"zhedie_quan_qiu_bang" selectedImage:@"zhedie_quan_qiu_bang_selected" frame:CGRectMake(30,CGRectGetMaxY(stateButton.frame),120,50)  action:@selector(buttonClicked:)];
    self.globalButton=globalButton;
    globalButton.tag=3;
    
   //设置
    UIButton *settingButton=[self buttonWithSubViews:LOCALIZATION(@"GlobalFoldMenuSetting")image:@"zhedie_setting" selectedImage:@"zhedie_setting_selected" frame:CGRectMake(30,CGRectGetMaxY(globalButton.frame),120,50)  action:@selector(buttonClicked:)];
    self.settingButton=settingButton;
    settingButton.tag=4;
}

- (UIButton *)buttonWithSubViews:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage frame:(CGRect)frame  action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);

    [button setTitle:title forState:UIControlStateNormal];
   
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    button.adjustsImageWhenHighlighted=NO;
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    
    button.frame=frame;
    [self.menuView addSubview:button];
    [self addLineInMenu:frame];
    return button;
    
}

//下面的那个线
- ( void)addLineInMenu:(CGRect)frame
{
    UIImageView *lineView=[[UIImageView alloc]init];
  
    lineView.backgroundColor=[UIColor colorWithHexString:@"c8c8c8"];
    lineView.frame= CGRectMake(5, CGRectGetMinY(frame), 170, 1);
    [self.menuView addSubview:lineView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cover.frame=self.bounds;
}


- (void)coverClick
{
    [self dismiss];
    
}

- (void)dismiss
{
    
 [self removeFromSuperview];
  
}

- (void)showMenu
{

 //添加菜单整体到窗口身上
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
 
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                        self.alpha = 1.0f;
                        self.frame=window.bounds;
                       
                         
                     } completion:^(BOOL completed) {
                         
                         
                     }];
}


- (void)buttonClicked:(UIButton *)button
{
    
    
    if ([self.delegate respondsToSelector:@selector(selectButton:)]) {
        
        [self.delegate selectButton:button];
    }
    
    [self dismiss];
        
}

//点击照相机

-(void)cameraClicked
{
    self.cameraView.image=[UIImage imageNamed:@"camera_selected"];
    
    if ([self.delegate respondsToSelector:@selector(tapCamera)]) {
        [self.delegate tapCamera];
    }
   
    [self dismiss];
    
}


//语言变换
- (void)languageChange
{
    CLog(@"收到通知");
    [self.stateButton setTitle:LOCALIZATION(@"GlobalFoldMenuNewStates")  forState:UIControlStateNormal];
     [self.stateButton setTitle:LOCALIZATION(@"GlobalFoldMenuerewima")   forState:UIControlStateNormal];
     [self.stateButton setTitle:LOCALIZATION(@"GlobalFoldMenuWorldbang")  forState:UIControlStateNormal];
     [self.stateButton setTitle:LOCALIZATION(@"GlobalFoldMenuSetting")  forState:UIControlStateNormal];
    
}

//头像更换
- (void)avatarviewChanged
{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}



@end
