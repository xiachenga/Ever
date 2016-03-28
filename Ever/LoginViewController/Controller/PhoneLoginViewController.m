//
//  PhoneLoginViewController.m
//  Ever
//
//  Created by Mac on 15/8/26.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "PhoneLoginViewController.h"
#import "RegisterViewController.h"

@interface PhoneLoginViewController ()<UITextFieldDelegate>

@property (nonatomic , weak) UITextField *phoneField;

@property (nonatomic , weak) UITextField *password;

@property (nonatomic , weak) UIButton *zoneNum;


@end

@implementation PhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置背景图片
    [self setupBackgroundImage];
    
    //添加logo
    [self addLogoImage];
    
    //添加输入框
    [self addInputField];
    

    //添加返回按钮
    [self addBackBtn];
    
    
}
- (void)setupBackgroundImage

{
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    imageView.image=[UIImage imageNamed:@"login_bg"];
    [self.view addSubview:imageView];
    
}

- (void)addLogoImage
{
    UIImageView *logoImage=[[UIImageView alloc]init];
    logoImage.image=[UIImage imageNamed:@"login_logo"];
    [self.view addSubview:logoImage];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
        make.centerY.mas_equalTo(self.view.mas_centerY).with.offset(-100);
        
        make.size.mas_equalTo(CGSizeMake(200, 100));
        
    }];
}

//添加输入框
- (void)addInputField {
    
    UIView *backgroundView=[[UIView alloc]init];
    backgroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(30);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-80, 100));
        
    }];
    
    //登录按钮
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:kThemeColor];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(backgroundView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-80, 40));
        
        
    }];
    
    //区号
    UIButton *zoneNum=[UIButton buttonWithType:UIButtonTypeCustom];
    [backgroundView addSubview:zoneNum];
    self.zoneNum=zoneNum;
    [zoneNum setTitle:@"+86" forState:UIControlStateNormal];
    [zoneNum setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [zoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(backgroundView.mas_left);
        make.top.mas_equalTo(backgroundView.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    
    //
    UIImageView *lineView=[[UIImageView alloc]init];
    [backgroundView addSubview:lineView];
    lineView.backgroundColor=[UIColor colorWithHexString:@"0xc8c7cc"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zoneNum.mas_right);
        make.top.mas_equalTo(backgroundView.mas_top).offset(2);
        make.size.mas_equalTo(CGSizeMake(0.5, 46));
        
    }];
    
    //电话号

    UITextField *phoneField=[[UITextField alloc]init];
    [backgroundView addSubview:phoneField];
    self.phoneField=phoneField;
    phoneField.placeholder=@"手机号码";
    phoneField.delegate=self;
    phoneField.returnKeyType=UIReturnKeyDone;
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(backgroundView.mas_left).offset(55);
        make.top.mas_equalTo(backgroundView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-130, 50));
        
    }];
    

    //密码
    UITextField *password=[[UITextField alloc]init];
    [backgroundView addSubview:password];
    password.placeholder=@"密码";
    password.delegate=self;
    self.password=password;
    password.returnKeyType=UIReturnKeyDone;
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneField.mas_bottom);
        make.centerX.mas_equalTo(backgroundView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-90, 50));
        
    }];
    
    [password addLineUp:YES andDown:NO];
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"第一次进入?";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
      //  make.left.mas_equalTo(loginBtn.mas_left).offset(20);
        make.centerX.mas_equalTo(loginBtn.centerX).offset(-30);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        
    }];
    
    
    //注册
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(label.mas_right).offset(10);
        make.top.mas_equalTo(label.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];

}

//登录
- (void)loginBtnClicked {
    
    if (self.phoneField.text.length>0 && self.password.text.length>0) {
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        
        [params setValue:[NSString stringWithFormat:@"%@-%@",self.zoneNum.titleLabel.text,self.phoneField.text] forKey:@"tel"];
        [params setValue:self.password.text forKey:@"pwd"];
        
        NSString *string=[kSeverPrefix stringByAppendingString:@"user/login"];
        
        [HttpTool send:string params:params success:^(id responseobj) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
            
            LoginResult *account=[LoginResult objectWithKeyValues:dic];
            
            if (account.if_success) {
                
                [AccountTool save:account];
                
                [GoIntoMainScreen goIntoMainScreen];
                
            }else {
                
                [MBProgressHUD  showError:account.prompt];
            }
            
        }];
    }else {
        
        [MBProgressHUD showError:@"请填写完整"];
    }
    
   
    
    
}

//注册
- (void)registerBtnClicked {
    
    RegisterViewController *registerVC=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}


//添加返回键
- (void)addBackBtn {
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        
    }];
    
    
}

#pragma mark Target

- (void)backBtnClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=YES;
}






@end
