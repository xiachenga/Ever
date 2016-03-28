//
//  GediaoZanListViewController.m
//  Ever
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "GediaoZanListViewController.h"
#import "DianzanResult.h"
#import "DianzanListCell.h"
@interface GediaoZanListViewController ()

@property (nonatomic,strong)NSMutableArray *zanArray;

@property (nonatomic , assign) long lastIndex;

@property (nonatomic , assign) long firstIndex;

@property (nonatomic , assign) int pageNum;

@end

@implementation GediaoZanListViewController


-(NSMutableArray *)zanArray
{
    if (_zanArray==nil) {
        _zanArray=[NSMutableArray array];
    }
    return _zanArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self refresh];
//    }];
//    
//    
//    
//    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self loadMoreData];
//    }];
    
    __unsafe_unretained typeof(self) vc = self;
    
    [self.tableView addHeaderWithCallback:^{
        [vc refresh];
        
    }];
    
    [self.tableView addFooterWithCallback:^{
        [vc loadMoreData];
        
    }];
}

-(void)setKindItem:(KindItem *)kindItem
{
    _kindItem=kindItem;
    
    [self loadData];
}

- (void)loadData
{

    NSString *string=[NSString stringWithFormat:@"gediao/zan/list/%ld/1/8/1/0",self.kindItem.itemID];
    
   NSString * urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString  params:nil success:^(id responseobj) {
        
       
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            
            NSArray *zanResults=[DianzanResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:zanResults.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            
            DianzanResult *firstResult=[zanResults firstObject];
            self.firstIndex=firstResult.zan_id;
            
            DianzanResult *lastResult=[zanResults lastObject];
            self.lastIndex=lastResult.zan_id;
            
            [self.zanArray addObjectsFromArray:zanResults];
        
            [self.tableView reloadData];
        }
        
        self.pageNum=2;
        
    } failure:^(NSError *erronr) {
        
        [MBProgressHUD showError:@"似乎已断开与互联网的连接"];
        [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [self loadData];
            
        }];
        
    }];

}

- (void)refresh
{
    NSString *string=[NSString stringWithFormat:@"gediao/zan/list/%ld/-1/8/1/%ld",self.kindItem.itemID,self.firstIndex];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil)
        {
            NSArray  *zanRelults=[DianzanResult objectArrayWithKeyValuesArray:responseobj];
            
            if (zanRelults.count!=0)
            {
                
                NSRange range=NSMakeRange(0, zanRelults.count);
                NSIndexSet *indexset=[NSIndexSet indexSetWithIndexesInRange:range];
                [self.zanArray insertObjects:zanRelults atIndexes:indexset];
                [self.tableView reloadData];
                
            }else
            {
                [MBProgressHUD showError:@"没有最新数据"];
            }
        }else
        {
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *erronr) {
        
        CLog(@"%@",erronr);
        
    }];
    
    
}

- (void)loadMoreData
{
     NSString *string=[NSString stringWithFormat:@"gediao/zan/list/%ld/1/8/%d/%ld",self.kindItem.itemID,self.pageNum,self.lastIndex];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            
            NSArray *zanResults=[DianzanResult objectArrayWithKeyValuesArray:responseobj];
            
            if (zanResults.count==0) {
                [MBProgressHUD showError:@"没有更多数据"];
            }else{
                DianzanResult *lastResult=[zanResults lastObject];
                self.lastIndex=lastResult.zan_id;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.zanArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"zanListCell";
    DianzanResult *dianzanResult=self.zanArray[indexPath.row];
    DianzanListCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[DianzanListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.dianzanResult=dianzanResult;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
