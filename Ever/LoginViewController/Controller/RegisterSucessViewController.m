//
//  RegisterSucessViewController.m
//  Ever
//
//  Created by Mac on 15-1-4.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "RegisterSucessViewController.h"
#import "GoIntoMainScreen.h"
#import "LoginResult.h"
#import "AccountTool.h"

@interface RegisterSucessViewController ()

@property (nonatomic,weak)UIImageView *avatarView;

@property (nonatomic , weak)  UILabel *result ;

@property (nonatomic , weak)  UILabel *ID ;

@end

@implementation RegisterSucessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor colorWithRed:252/255.0f green:188/255.0f blue:57/255.0f alpha:1.0f];
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  添加子控件
     */
    [self addChildView];
    
    [self setupInfo];
    
    [self entryEver];
    
}

- (void)addChildView
{
    UIImageView *avatarView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-30, 100, 60, 60)];
    self.avatarView=avatarView;
    [avatarView doCircleFrame];
    [self.view addSubview:avatarView];
    
    
    UILabel *result=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-40, CGRectGetMaxY(avatarView.frame)+20, 100, 20)];
    result.font=[UIFont boldSystemFontOfSize:20];
    result.text=@"注册成功";
    self.result=result;
    [self.view addSubview:result];
    
    //账号
    UILabel *ID=[[UILabel alloc]init];
    ID.font=[UIFont systemFontOfSize:20];
    self.ID=ID;
    [self.view addSubview:ID];
    
}

- (void)setupInfo
{
    LoginResult *account=[AccountTool account];
    NSURL *url=[NSURL URLWithString:account.user_head_image_url];
    [self.avatarView sd_setImageWithURL:url];
    
    self.ID.text=[NSString stringWithFormat:@"Ever账号:%ld",account.user_id];
    
    
    CGSize IDsize=[self.ID.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.ID.frame=(CGRect){{(kScreen_Width-IDsize.width)*0.5,CGRectGetMaxY(self.result.frame)+10},IDsize};
    
}

- (void)entryEver
{
    UIButton *Everbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [Everbutton setFrame:CGRectMake(150, 300, 150, 100)];
    [Everbutton setImage:[UIImage imageNamed:@"guide_last_enter"] forState:UIControlStateNormal];
    [Everbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ Everbutton addTarget:self action:@selector(everbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:Everbutton];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)everbuttonClicked
{
    
    [GoIntoMainScreen goIntoMainScreen];
}
@end
