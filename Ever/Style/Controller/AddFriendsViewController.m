//
//  AddFriendsViewController.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "CustomTextView.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor whiteColor];
        
        self.title=@"验证信息";
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextView];
    [self addsendButton];

}

- (void)setupTextView
{
    CustomTextView *customView=[[CustomTextView alloc]init];
    customView.frame=CGRectMake(5, 0, kScreen_Width-2*5, 200);
    
    customView.placeholder=@"对方需要你填写验证信息";
    [customView becomeFirstResponder];
    [self.view addSubview:customView];
}


- (void)addsendButton
{
    UIButton *sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundColor:kThemeColor];
    sendButton.frame=CGRectMake(5,250, kScreen_Width-2*5, 30);
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
}

- (void)sendButtonClicked
{
    CLog(@"发送");
    
}

@end
