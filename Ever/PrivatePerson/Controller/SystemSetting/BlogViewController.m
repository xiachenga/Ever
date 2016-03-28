//
//  BlogViewController.m
//  Ever
//
//  Created by Mac on 15-3-13.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "BlogViewController.h"

@interface BlogViewController ()<UIWebViewDelegate>



@end

@implementation BlogViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
   
    self.title=@"关注微博";
    
    [self loadWeibo];
}


-(void)loadWeibo
{
    UIWebView *blogView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    blogView.delegate=self;
    [self.view addSubview:blogView];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://weibo.com/lixuancheng123"]];
    
    [blogView loadRequest:request];
    
}

#pragma UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
   
    
    [MBProgressHUD hideHUDForView:self.view];
    
}


@end
