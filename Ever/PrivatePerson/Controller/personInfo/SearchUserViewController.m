//
//  SearchUserViewController.m
//  Ever
//
//  Created by Mac on 15-5-7.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "SearchUserViewController.h"
#import "CustomSearchBar.h"
#import "HisHomeResult.h"
#import "PersonhomeViewController.h"
@interface SearchUserViewController ()
@property(nonatomic,weak)CustomSearchBar *searchBar;

@end

@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];

    
    self.title=LOCALIZATION(@"Search_friend_title");

    
    //添加搜索框
    
    [self addSearchBar];
    
    [self addSearchButton];
        
}
- (void)addSearchBar
{
    CustomSearchBar *searchBar=[[CustomSearchBar alloc]init];
    searchBar.placeholder=LOCALIZATION(@"Search_textField");
    CGFloat padding=10;
    searchBar.keyboardType=UIKeyboardTypeNumberPad;
    searchBar.leftImageName=@"tongxunlu_sousuo";
    searchBar.frame=CGRectMake(10, 100, kScreen_Width-2*padding, 50);
    self.searchBar=searchBar;
    [self.view addSubview:searchBar];
    
}


- (void)addSearchButton
{
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:LOCALIZATION(@"Search_Friend_btn") forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage resizedImageWithName:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage resizedImageWithName:@"dashehui_anniu_huang_selected"] forState:UIControlStateHighlighted];
    searchBtn.frame=CGRectMake(10, kScreen_Height*0.5, kScreen_Width-20, 40);
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}

- (void)searchBtnClicked
{
  
    NSString *string=[kSeverPrefix stringByAppendingString:@"user/search"];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:self.searchBar.text forKey:@"email"];
    
    
    [HttpTool send:string params:params success:^(id responseobj) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
        if (dic!=nil) {
        
            HisHomeResult *result=[HisHomeResult objectWithKeyValues:dic];
            
            if (result.if_success) {
                PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
                personhomeVC.user_id=result.user_id;
                [self.navigationController pushViewController:personhomeVC animated:YES];
            }else{
                
                [MBProgressHUD showError:result.prompt];
            }
            
          
            
        }
        
    }];
    
    
//    [HttpTool post:string params:params success:^(id responseobj) {
//        
//        CLog(@"%@",params);
//        CLog(@"%@",responseobj);
//        
//    } failure:^(NSError *error) {
//        
//        CLog(@"%@",error);
//        
//    }];
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}




@end
