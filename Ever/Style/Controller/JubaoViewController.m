//
//  JubaoViewController.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "JubaoViewController.h"
#import "CustomTextView.h"

@interface JubaoViewController ()

@property (nonatomic,weak)CustomTextView *textView;

@end

@implementation JubaoViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        self.title=LOCALIZATION(@"Report");
    }
    return self;
}
    
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setupTextView];
    
    [self addSendButton];
   
}

- (void)setupTextView
{
    CustomTextView *customTextView=[[CustomTextView alloc]init];
    customTextView.frame=CGRectMake(5, 20, kScreen_Width-2*5, 200);
    customTextView.placeholder=@"吐槽一下";
    self.textView=customTextView;
    [self.view addSubview:customTextView];
    
}
- (void)addSendButton
{
    UIButton *sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage resizedImageWithName:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage resizedImageWithName:@"dashehui_anniu_huang_selected"] forState:UIControlStateHighlighted];
    
    sendButton.frame=CGRectMake(5,230, kScreen_Width-2*5, 30);
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
}

-(void)setCid:(long)cid
{
    _cid=cid;
}

- (void)sendButtonClicked
{
//    NSString *string=@"https://manager.ooo.do/server/app/report";
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/report"];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:self.textView.text forKey:@"reason"];
    [params setValue:[NSString stringWithFormat:@"%ld",self.cid] forKey:@"cid"];
    [params setValue:[NSString stringWithFormat:@"%d",3] forKey:@"token_type"];
    
   [HttpTool send:string params:nil success:^(id responseobj) {
       
       NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
       if (dic!=nil) {
           
            
       }
       
   }];
    
}
@end
