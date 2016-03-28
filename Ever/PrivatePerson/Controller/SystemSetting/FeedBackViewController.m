//
//  FeedBackViewController.m
//  Ever
//
//  Created by Mac on 15-3-13.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "FeedBackViewController.h"
#import "CustomTextView.h"

@interface FeedBackViewController ()<UITextViewDelegate>
@property (nonatomic,weak)CustomTextView *textView;
@end

@implementation FeedBackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"意见反馈";
    
   //创建一个TextView
    [self setupTextView];
    
    //创建一个发送按钮
    [self setupSendButton];
}

//创建一个uitextView
- (void)setupTextView
{

    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 84, kScreen_Width-20, 220)];
    imageView.layer.borderWidth=2;
    imageView.layer.borderColor=kThemeColor.CGColor;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];

    CustomTextView *textView=[[CustomTextView alloc]initWithFrame:CGRectMake(20, 90, kScreen_Width-40, 200)];
 
    textView.clearsOnInsertion=YES;
    self.textView=textView;
    textView.delegate=self;
    textView.placeholder=@"吐槽一下...";

    textView.font=[UIFont systemFontOfSize:15];
    textView.returnKeyType=UIReturnKeyDone;
    
    [self.view addSubview:textView];
   
    
    
}

//发送按钮
- (void)setupSendButton
{
  UIButton *sendButton=  [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
 
    [sendButton setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang_selected"] forState:UIControlStateHighlighted];
    sendButton.frame=CGRectMake(10, kScreen_Height-150, kScreen_Width-2*10, 40);
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
}

- (void)sendButtonClicked
{
    
    [self.view beginLoading];

    
    
     NSString *string=[kSeverPrefix stringByAppendingString:@"app/feedback"];

    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:self.textView.text forKey:@"content"];
    
    [HttpTool post:string params:@{@"content":@"susubsbssbsbsbs"} success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        
    } failure:^(NSError *error) {
        
        CLog(@"%@",error);
        
    }];
    
        
//    [HttpTool send:string params:params success:^(id responseobj) {
//        
//        if (responseobj!=nil) {
//            
//            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
//            if (dic!=nil) {
//                
//                NormalResult *normal=[NormalResult objectWithKeyValues:dic];
//                
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                [MBProgressHUD showError:normal.prompt];
//                
//            }
//        }
    
        
//        [self.view endLoading];
//    
//    }];
    
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    
}


#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}



@end
