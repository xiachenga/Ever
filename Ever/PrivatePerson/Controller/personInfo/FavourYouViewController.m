//
//  FavourYouViewController.m
//  Ever
//
//  Created by Mac on 15-3-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "FavourYouViewController.h"
#import "DianzanDynamicResult.h"
#import "DianzanDynamicCell.h"
#import "PersonhomeViewController.h"

@interface FavourYouViewController ()

@property (nonatomic,strong)NSMutableArray *zanArray;

@property (nonatomic , assign) long lastIndex;

@property (nonatomic , assign) long firstIndex;

@property (nonatomic , assign) int pageNum;



@end

@implementation FavourYouViewController



-(NSMutableArray *)zanArray
{
    if (_zanArray==nil) {
        _zanArray=[NSMutableArray array];
    }
    
    return _zanArray;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    
    
    __unsafe_unretained typeof(self) vc = self;
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [vc refresh];
//    }];
    
    [self.tableView addHeaderWithCallback:^{
        
         [vc refresh];
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        
        [vc loadMoreData];
        
    }];
    
    //加载数据
    [self loadData];
}
//加载数据
- (void)loadData
{
    
     NSString *urlstring=[kSeverPrefix stringByAppendingString:@"dynamic/dianzan/1/10/1/0"];

    [HttpTool get:urlstring params:nil success:^(id responseobj) {
    
        CLog(@"%@",responseobj);
        if (responseobj!=nil) {
            
            NSArray *zanResults=[DianzanDynamicResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:zanResults.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            
            DianzanDynamicResult *firstResult=[zanResults firstObject];
            self.firstIndex=firstResult.dynamic_id;
            
            DianzanDynamicResult *lastResult=[zanResults lastObject];
            self.lastIndex=lastResult.dynamic_id;
            
            [self.zanArray addObjectsFromArray:zanResults];
            
            [self.tableView reloadData];
        }
        
        self.pageNum=2;
        
    } failure:^(NSError *erronr) {
        CLog(@"%@",erronr);
        
        [self.view endLoading];
        
       [MBProgressHUD showError:@"似乎已断开与互联网的连接"];
        [self.view configBlankPage:BlankPagetypeRefresh     hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [self loadData];
            
        }];
        
    }];
}

- (void)refresh
{
    
    NSString *string=[NSString stringWithFormat:@"dynamic/dianzan/-1/10/1/%ld",self.firstIndex];
    NSString *urlstring=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil)
        {
            NSArray  *zanRelults=[DianzanDynamicResult objectArrayWithKeyValuesArray:responseobj];
            
            if (zanRelults.count!=0)
            {
            
                NSRange range=NSMakeRange(0, zanRelults.count);
                NSIndexSet *indexset=[NSIndexSet indexSetWithIndexesInRange:range];
                [self.zanArray insertObjects:zanRelults atIndexes:indexset];
                [self.tableView reloadData];
                
            }
        }else
        {
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *erronr) {
        
       
        [self.tableView headerEndRefreshing];
        
    }];
    
    
}

- (void)loadMoreData
{
   NSString *string=[NSString stringWithFormat:@"dynamic/dianzan/1/10/%d/%ld",self.pageNum,self.lastIndex];
    
  
    NSString *urlstring=[kSeverPrefix stringByAppendingString:string];
    
    
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
           
            NSArray *zanResults=[DianzanDynamicResult objectArrayWithKeyValuesArray:responseobj];
            
            if (zanResults.count==0) {
//                [MBProgressHUD showError:@"没有更多数据"];
            }else{
                DianzanDynamicResult *lastResult=[zanResults lastObject];
                self.lastIndex=lastResult.dynamic_id;
                [self.zanArray addObjectsFromArray:zanResults];
                [self.tableView reloadData];
               
                
                self.pageNum++;
                
            }
            
        }else{
            
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSError *erronr) {
        CLog(@"%@",erronr);
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zanArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DianzanDynamicResult *result=self.zanArray[indexPath.row];
    static NSString *identifier=@"Dyanmiczan";
    DianzanDynamicCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[DianzanDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.dynamicResult=result;
    
    [cell addLineUp:YES andDown:NO];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DianzanDynamicResult *zanResult=self.zanArray[indexPath.row];
    
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=zanResult.user_id;
    personhomeVC.guanzhuButtonType=GuanzhuButtonTypeNone;

    UIViewController *controller=[self viewController];
    
    
    [controller.navigationController pushViewController:personhomeVC animated:YES];
    
}


- (UIViewController*)viewController {
    
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
