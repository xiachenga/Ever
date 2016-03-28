//
//  MeiliUserViewController.m
//  Ever
//
//  Created by Mac on 15-5-7.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "MeiliUserViewController.h"
#import "CommonUserCell.h"
#import "RankResult.h"
#import "ThreeUserCell.h"
#import "PersonhomeViewController.h"
@interface MeiliUserViewController ()<ThreeUserCellDelegate>
@property (nonatomic,strong)NSMutableArray *meiliUserArray;

@property (nonatomic , strong) NSArray *threeUserArray;
@property (nonatomic , assign) int num;
@property (nonatomic , assign) long lastID;

@end

@interface MeiliUserViewController ()

@end

@implementation MeiliUserViewController

-(NSMutableArray *)meiliUserArray
{
    if (_meiliUserArray==nil) {
        _meiliUserArray=[NSMutableArray array];
    }
    return _meiliUserArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=LOCALIZATION(@"MeiliRanking");
    
    [self reloadData];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
}
- (void)reloadData
{

    
    NSString *string=[kSeverPrefix stringByAppendingString:@"user/ranking/1/60/1/0"];
    
    
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        NSArray *array=[RankResult objectArrayWithKeyValuesArray:responseobj];
        [self.meiliUserArray addObjectsFromArray:array];
        
        
        NSRange range=NSMakeRange(0, 3);
        NSIndexSet *indexset=[NSIndexSet indexSetWithIndexesInRange:range];
        NSArray *threeUserArray=[self.meiliUserArray objectsAtIndexes:indexset];
        self.threeUserArray=threeUserArray;
        
        [self.meiliUserArray removeObjectsAtIndexes:indexset];
        
        RankResult *rangResult=[array lastObject];
        self.lastID=rangResult.user_id;
        
        [self.tableView reloadData];
        
        self.num=2;
        
    } failure:^(NSError *erronr) {
        CLog(@"%@",erronr);
        
    }];
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.meiliUserArray.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"cell";
    
    switch (indexPath.row) {
        case 0:
        {
            ThreeUserCell *threeUserCell=[[ThreeUserCell alloc]init];
            threeUserCell.threeUserArray=self.threeUserArray;
            threeUserCell.delegate=self;
            return   threeUserCell;
            
        }
            break;
            
        default:
        {
            RankResult *rangResult=self.meiliUserArray[indexPath.row-1];
            CommonUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell==nil) {
                cell=[[CommonUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.rankResult=rangResult;
            
            return cell;
            
        }
            break;
    }
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 300;
    }else{
        return 50;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    switch (indexPath.row) {
        case 0:
        {
            CLog(@"点第一行了");
        }
            
            break;
            
        default:
            
        {
            RankResult *rankResult=self.meiliUserArray[indexPath.row-1];
            
            PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
            personhomeVC.user_id=rankResult.user_id;
            [self.navigationController pushViewController:personhomeVC animated:YES];
        }
            break;
    }
    
    
}


- (void)gotoPersonhomeWithUserid:(long)userid
{
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=userid;
    [self.navigationController pushViewController:personhomeVC animated:YES];
}
@end
