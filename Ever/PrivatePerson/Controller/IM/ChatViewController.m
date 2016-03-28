//
//  ChatViewController.m
//  Ever
//
//  Created by Mac on 15-4-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ChatViewController.h"
#import "PersonhomeViewController.h"
#import "UserRelationResult.h"

@interface ChatViewController ()
@property(nonatomic,weak)UIImageView *avatarImage;
@property (nonatomic , weak) UILabel *titleLabel;

@end

@implementation ChatViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //设置导航栏右边的头像
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, 40, 40);
        view.userInteractionEnabled=YES;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
        UITapImageView *avatarImage=[[UITapImageView alloc]init];
        [avatarImage addTapBlock:^(id obj) {
            
            [self gotoUserhome];
        }];
        avatarImage.size=CGSizeMake(40, 40);
        [avatarImage doCircleFrame];
        self.avatarImage=avatarImage;
        [view addSubview:avatarImage];
    
    }
    
    return self;
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.size=CGSizeMake(30, 30);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
   
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
//    [leftButton setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
//    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
    
}




-(void)setUser:(AppBeanResultBase *)user{
    
    _user=user;
    
    NSURL *url=[NSURL URLWithString:self.user.user_head_image_url];
   [self.avatarImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
}

-(void)setNavigationTitle:(NSString *)title textColor:(UIColor *)textColor
{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=title;
    self.navigationItem.titleView=titleLabel;
}

//个人主页
- (void)gotoUserhome
{
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=self.user.user_id;
    [self.navigationController pushViewController:personhomeVC animated:YES];
}


@end
