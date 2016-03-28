//
//  FocusOnMeViewController.m
//  Ever
//
//  Created by Mac on 15-5-7.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "FocusOnMeViewController.h"
#import "UserRelationResult.h"
#import "FocusOnMeUserCell.h"
#import "SearchUserViewController.h"
@interface FocusOnMeViewController ()

@property (nonatomic,strong)NSMutableArray *focusUserArray;

@end

@implementation FocusOnMeViewController


-(NSMutableArray *)focusUserArray
{
    if (_focusUserArray==nil) {
        _focusUserArray=[NSMutableArray array];
    }
    return _focusUserArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=LOCALIZATION(@"MyFollowers");
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tongxunlu_sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchUser)];
    
    [self loadData];
    
   
}

- (void)loadData
{

    [self.view beginLoading];
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"user/list/-1/-1/20/1/0"];
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        [self.view endLoading];
        
        if ( responseobj!=nil) {
            
            
            NSArray *array=[UserRelationResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:array.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];

            
            [self.focusUserArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *erronr) {
        
         [self.view endLoading];
        
        [MBProgressHUD showError:@"似乎断开了与互联网的连接"];
        [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [self loadData];
            
        }];
       
        
    }];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.focusUserArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"cell";
    
    UserRelationResult *user=self.focusUserArray[indexPath.row];
    FocusOnMeUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell=[[FocusOnMeUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    

    cell.focusUser=user;
    
    [cell addLineUp:YES andDown:NO];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight=60;
    
    [tableView.tableFooterView addLineUp:NO andDown:YES];
    
    
    return rowHeight;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserRelationResult *user=self.focusUserArray[indexPath.row];
    
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=user.user_id;
    [self.navigationController pushViewController:personhomeVC animated:YES];
    
}

- (void)searchUser
{
    SearchUserViewController *searchUserVC=[[SearchUserViewController alloc]init];
    [self.navigationController pushViewController:searchUserVC animated:YES];
    
}



@end
