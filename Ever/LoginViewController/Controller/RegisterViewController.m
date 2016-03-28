//
//  RegisterViewController.m
//  Ever
//
//  Created by Mac on 15/8/26.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "RegisterViewController.h"
#import "PersonInfoViewController.h"
#import "PhoneNumRes.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic , weak) UITextField *phoneField,*password,*identify;


@property (nonatomic , weak) UIButton *getIdentify,*zoneNum;




@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //设置背景图片
    [self setupBackgroundImage];
    
    //添加logo
    [self addLogoImage];
    
    //添加注册框
    
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


//添加注册框
- (void)addInputField {
    
    UIView *backgroundView=[[UIView alloc]init];
    backgroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(30);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-80, 150));
        
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
    phoneField.placeholder=@"手机号码";
    self.phoneField=phoneField;
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
    self.password=password;
    password.delegate=self;
    password.returnKeyType=UIReturnKeyDone;
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneField.mas_bottom);
        make.centerX.mas_equalTo(backgroundView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-90, 50));
        
    }];
    
    [password addLineUp:YES andDown:YES];
    
    UITextField *identify=[[UITextField alloc]init];
    [backgroundView addSubview:identify];
    identify.delegate=self;
    self.identify=identify;
    identify.returnKeyType=UIReturnKeyDone;
    identify.placeholder=@"输入验证码";
    [identify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backgroundView.mas_left).offset(5);
        make.top.mas_equalTo(password.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-205, 50));
        
    }];
    
    [identify addLineUp:YES andDown:NO];
    
    UIButton *getIdentify=[UIButton buttonWithType:UIButtonTypeCustom];
    [backgroundView addSubview:getIdentify];
    self.getIdentify=getIdentify;
    getIdentify.titleLabel.font=[UIFont systemFontOfSize:15];
  
    [getIdentify setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 
    [getIdentify setBackgroundImage:[UIImage imageNamed:@"tongxunluanniubg"] forState:UIControlStateNormal];
    [getIdentify addTarget:self action:@selector(getInentifyClicked) forControlEvents:UIControlEventTouchUpInside];
    getIdentify.adjustsImageWhenHighlighted=NO;
    [getIdentify setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getIdentify mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(identify.mas_right);
        make.top.mas_equalTo(password.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120, 50));
        
    }];
    
    //下一步
    UIButton *nextStepBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextStepBtn setBackgroundColor:kThemeColor];
    [self.view addSubview:nextStepBtn];
    nextStepBtn.adjustsImageWhenHighlighted=NO;
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn addTarget:self action:@selector(nextStepBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backgroundView.mas_left);
        make.top.mas_equalTo(backgroundView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-80, 40));
        
    }];
}

//获取验证码
- (void)getInentifyClicked {
    
    [self  verificationCode:^{
        
    } blockNo:^(id time) {
        
    }];
    
    NSString*phones=@"86-";
    NSString *phonestwo=[phones stringByAppendingString:self.phoneField.text];
    NSString *string=[NSString stringWithFormat:@"%@app/authcode/%@",kSeverPrefix,phonestwo];
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        NormalResult *result=[NormalResult objectWithKeyValues:responseobj];
        
        [MBProgressHUD showError:result.prompt];
        
        
    } failure:^(NSError *erronr) {
        
    }];
    
    
}

//下一步
- (void)nextStepBtnClicked {
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"user/first_reg"];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%@-%@",self.zoneNum.titleLabel.text,self.phoneField.text] forKey:@"tel"];
    [params setValue:self.identify.text forKey:@"authcode"];
    [HttpTool send:string params:params success:^(id responseobj) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
        NormalResult *result=[NormalResult objectWithKeyValues:dic];
        [MBProgressHUD showError:result.prompt];
        if (result.if_success) {
            
            PersonInfoViewController *personInfoVC=[[PersonInfoViewController alloc]init];
            PhoneNumRes *phone=[[PhoneNumRes alloc]init];
            phone.phoneNum=self.phoneField.text;
            phone.password=self.password.text;
            personInfoVC.phone=phone;
            [self.navigationController pushViewController:personInfoVC animated:YES];
        }
        
    }];
    
   
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


- (void)backBtnClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=YES;
}


//
- (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
                [self.getIdentify setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getIdentify.enabled=YES;
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                blockNo(strTime);
                
                
                [self.getIdentify setTitle:[NSString stringWithFormat:@"%d秒后重新获取",seconds] forState:UIControlStateNormal];
                self.getIdentify.enabled=NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



@end
