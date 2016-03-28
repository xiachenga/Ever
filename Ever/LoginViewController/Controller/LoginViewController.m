//
//  LoginViewController.m
//  Ever
//
//  Created by Mac on 15-4-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "LoginViewController.h"
#import "PersonInfoViewController.h"
#import "UserInfo.h"
#import "CustomPopbottomView.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"
#import "GoIntoMainScreen.h"
#import "PhoneLoginViewController.h"

@interface LoginViewController ()<CustomPopbottomViewDelegate>

@property (nonatomic,weak)UIImageView *imageView;

@property (nonatomic , weak) CustomPopbottomView *popBottomView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景图片
    [self setupBackgroundImage];
    
    //添加logo
    [self addLogoImage];
    
    //添加底部按钮
    [self addBottomButton];
}

/**
 *  设置背景图片
 */
- (void)setupBackgroundImage

{
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    imageView.image=[UIImage imageNamed:@"login_bg"];
    [self.view addSubview:imageView];
    self.imageView=imageView;
}

/**
 *  添加logo
 *
 *  @return <#return value description#>
 */

- (void)addLogoImage
{
    UIImageView *logoImage=[[UIImageView alloc]init];
    logoImage.image=[UIImage imageNamed:@"login_logo"];
    [self.imageView addSubview:logoImage];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
        make.centerY.mas_equalTo(self.view.mas_centerY).with.offset(-80);
        
        make.size.mas_equalTo(CGSizeMake(200, 100));
    
    }];
}

/**
 *  添加登陆按钮
 */

- (void)addBottomButton
{
    UIView *bottomBgView=[[UIView alloc]init];
    bottomBgView.backgroundColor=[UIColor colorWithHexString:@"3f300f"];
    bottomBgView.alpha=0.75;
    bottomBgView.frame=CGRectMake(0, kScreen_Height-60, kScreen_Width, 60);
    [self.imageView addSubview:bottomBgView];
    
    UIImageView *lineView=[[UIImageView alloc]init];
    lineView.backgroundColor=[UIColor lightGrayColor];
   
    lineView.frame=CGRectMake(kScreen_Width*0.5, 2, 2, 50);
    [bottomBgView addSubview:lineView];
    
    
    UIButton *loginBtn=[self buttonWithTitle:@"点击登录"];
    loginBtn.frame=CGRectMake(30, kScreen_Height-50, kScreen_Width/2-2*30+5, 40);
    loginBtn.tag=1;
  
    UIButton *intoBtn=[self buttonWithTitle:@"直接进入"];
    intoBtn.frame=CGRectMake(kScreen_Width/2+30, kScreen_Height-50, kScreen_Width/2-2*30, 40);
    intoBtn.tag=2;
    
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:kThemeColor];
    button.layer.cornerRadius=4;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:button];
    return button;
}

#pragma mark CustomPopBottomViewDelegate
- (void)buttonClicked:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
            CustomPopbottomView *popBottomView=[[CustomPopbottomView alloc]init];
            popBottomView.deletate=self;
            self.popBottomView=popBottomView;
            [popBottomView showPopView];
        }
            break;
            
        default:
        {
            
            [GoIntoMainScreen goIntoMainScreen];
            
        }
            break;
    }
    
}

#pragma mark CustomPopviewDeleagte

-(void)didSelected:(UIButton *)button
{
    switch (button.tag)
    {
        case 1:
            [self phone];
            break;
        case 2:
            [self qq];
            
            break;
        case 3:
            [self weixin];
            
            break;
        case 4:
           [self sina];
            break;
        
    }
}

#pragma mark 手机登录

- (void)phone {
    
    PhoneLoginViewController *phoneLoginVC=[[PhoneLoginViewController alloc]init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
    
}

#pragma mark Sina登录
- (void)sina
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self getSinaInfo];
            
        }});
}

- (void)getSinaInfo
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        
        CLog(@"个人信息为 : %@",response.data);
        
        UserInfo *user=[UserInfo objectWithKeyValues:response.data];
        
    
        
        NSString *urlstring=[kSeverPrefix stringByAppendingString:@"user/disanfang"];
        
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setValue:user.uid forKey:@"uid"];
        [params setValue:@"4" forKey:@"loginType"];
        
        [HttpTool send:urlstring params:params success:^(id responseobj) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil ];
            
            NormalResult *normal=[NormalResult objectWithKeyValues:dic];
            
            if ([normal.prompt isEqualToString:@"-1"]) {
                
                PersonInfoViewController *personinfoVC=[[PersonInfoViewController alloc]init];
                personinfoVC.WeiboUser=user;
                
                [self.navigationController pushViewController:personinfoVC animated:YES];
            }else
            {
              
                
                NSString *string=[kSeverPrefix stringByAppendingString:@"user/login"];
                
                NSMutableDictionary *param=[NSMutableDictionary dictionary];
                [param setValue:user.uid forKey:@"uid"];
                [HttpTool send:string params:param success:^(id responseobj) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableLeaves error:nil];
                    LoginResult *account=[LoginResult objectWithKeyValues:dic];
                    
                    [AccountTool save:account];
                    
                    [GoIntoMainScreen goIntoMainScreen];
                }];
            }
        }];
        
        
    }];
}

#pragma mark qq登录
- (void)qq
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self getqqInfo];
            
        }});
    
}

- (void)getqqInfo
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        

        
       UserInfo *user=[UserInfo objectWithKeyValues:response.data];

        
       // NSString *urlstring= @"https://manager.ooo.do/server/user/disanfang";
        
          NSString *urlstring=[kSeverPrefix stringByAppendingString:@"user/disanfang"];
        
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setValue:user.uid forKey:@"uid"];
        [params setValue:@"2" forKey:@"loginType"];
        
        [HttpTool send:urlstring params:params success:^(id responseobj) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil ];
            
            NormalResult *normal=[NormalResult objectWithKeyValues:dic];
            
            if ([normal.prompt isEqualToString:@"-1"]) {
                PersonInfoViewController *personinfoVC=[[PersonInfoViewController alloc]init];
                personinfoVC.qquser=user;
                
                [self.navigationController pushViewController:personinfoVC animated:YES];
            }else
            {
             
                 NSString *string=[kSeverPrefix stringByAppendingString:@"user/login"];
                
                NSMutableDictionary *param=[NSMutableDictionary dictionary];
                [param setValue:user.uid forKey:@"uid"];
                [HttpTool send:string params:param success:^(id responseobj) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableLeaves error:nil];
                    LoginResult *account=[LoginResult objectWithKeyValues:dic];
                    
                    [AccountTool save:account];
                    
                    [GoIntoMainScreen goIntoMainScreen];
                }];
                
            }
        }];
        
        
    }];
}

#pragma mark weixin 登录
- (void)weixin
{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self getwexinInfo];
            
        }
        
    });
    
}


- (void)getwexinInfo
{
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        CLog(@"SnsInformation is %@",response.data);
        
        UserInfo *user=[UserInfo objectWithKeyValues:response.data];
        
        
        
     //   NSString *urlstring=  @"https://manager.ooo.do/server/user/disanfang";
         NSString *urlstring=[kSeverPrefix stringByAppendingString:@"user/disanfang"];
        
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setValue:user.uid forKey:@"uid"];
        [params setValue:@"3" forKey:@"loginType"];
        
        [HttpTool send:urlstring params:params success:^(id responseobj) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil ];
            
            NormalResult *normal=[NormalResult objectWithKeyValues:dic];
            
            if ([normal.prompt isEqualToString:@"-1"]) {
                PersonInfoViewController *personinfoVC=[[PersonInfoViewController alloc]init];
                personinfoVC.qquser=user;
                
                [self.navigationController pushViewController:personinfoVC animated:YES];
            }else
            {
              
                
                 NSString *string=[kSeverPrefix stringByAppendingString:@"user/login"];
                
                NSMutableDictionary *param=[NSMutableDictionary dictionary];
                [param setValue:user.uid forKey:@"uid"];
                [HttpTool send:string params:param success:^(id responseobj) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableLeaves error:nil];
                    LoginResult *account=[LoginResult objectWithKeyValues:dic];
                    
                    [AccountTool save:account];
                    
                    [GoIntoMainScreen goIntoMainScreen];
                }];
                
            }
        }];
        
        
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popBottomView dismiss];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}


@end
