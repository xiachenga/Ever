//
//  CommentYouViewController.m
//  Ever
//
//  Created by Mac on 15-3-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CommentYouViewController.h"
#import "ReplayDynamicResult.h"
#import "ReplayDynamicCell.h"
#import "GediaoDetailViewController.h"
#import "TalkDetailViewController.h"
#import "MeetViewCotroller.h"
@interface CommentYouViewController ()
//@property (nonatomic , weak) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *replayArray;

@property (nonatomic , assign) long firstID,lastID;

@property (nonatomic , assign) int pageNum;



@end

@implementation CommentYouViewController


- (NSMutableArray *)replayArray
{
    if (_replayArray==nil) {
        _replayArray=[NSMutableArray array];
    }
    
    return _replayArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    
    __unsafe_unretained typeof(self) vc = self;
    

    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [vc refresh];
//    }];
//    
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [vc loadMore];
//    }];
    
    [self.tableView addHeaderWithCallback:^{
        
        [vc refresh];
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        
        [vc loadMore];
        
    }];
    
    [self loadData];
}

- (void)loadData
{
     NSString *urlstring=[kSeverPrefix stringByAppendingString:@"dynamic/comment/1/5/1/0"];
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        
       
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            NSArray *replays=[ReplayDynamicResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:replays.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            
            if (replays.count>0) {
                
              
                ReplayDynamicResult *replayResult=[replays firstObject];
                self.firstID=replayResult.dynamic_id;
                
                ReplayDynamicResult *lastResult=[replays lastObject];
                self.lastID=lastResult.dynamic_id;
                
                [self.replayArray addObjectsFromArray:replays];
                [self.tableView reloadData];
                
                self.pageNum=2;
            }
        }
        
    } failure:^(NSError *erronr) {
        
        [MBProgressHUD showError:@"似乎已断开与互联网的连接"];
        [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [self loadData];
            
        }];
       
        
    }];
}

//刷新
- (void)refresh
{
    
     NSString *string=[NSString stringWithFormat:@"dynamic/comment/-1/5/1/%ld",self.firstID];
     NSString *urlstring=[kSeverPrefix stringByAppendingString:string];
    
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        CLog(@"%@",responseobj);
      
        if (responseobj!=nil) {
            NSArray *replays=[ReplayDynamicResult objectArrayWithKeyValuesArray:responseobj];
            if (replays.count>0) {
                
                ReplayDynamicResult *replayResult=[replays firstObject];
                self.firstID=replayResult.dynamic_id;
                
                NSRange rangge=NSMakeRange(0, replays.count);
                NSIndexSet *indexSet=[NSIndexSet indexSetWithIndexesInRange:rangge];
                [self.replayArray insertObjects:replays atIndexes:indexSet];
                [self.tableView reloadData];
                
            }
        }else{
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *erronr) {
        
        [self.tableView headerEndRefreshing];
    }];
    
   
}
//加载更多
- (void)loadMore
{
    NSString *string=[NSString stringWithFormat:@"dynamic/comment/1/5/%d/%ld",self.pageNum,self.lastID];
  
    NSString *urlstring=[kSeverPrefix stringByAppendingString:string];
    
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            NSArray *replays=[ReplayDynamicResult objectArrayWithKeyValuesArray:responseobj];
            if (replays.count>0) {
                
                ReplayDynamicResult *replayResult=[replays lastObject];
                self.lastID=replayResult.dynamic_id;
                [self.replayArray addObjectsFromArray:replays];
                [self.tableView reloadData];
                self.pageNum++;
                
            }
        }else{
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *erronr) {
        CLog(@"%@",erronr);
        [self.tableView footerEndRefreshing];
    }];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.replayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    
    ReplayDynamicResult *replayResult=self.replayArray[indexPath.row];
    
    ReplayDynamicCell *replayCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (replayCell==nil) {
        replayCell=[[ReplayDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    replayCell.replayResult=replayResult;
    
    [replayCell addLineUp:YES andDown:NO];
    return  replayCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller=[self viewController];
    
    ReplayDynamicResult *replayResult=self.replayArray[indexPath.row];
    //如果是日记
    if (replayResult.type==3) {
        
        TalkDetailViewController *talkDetailVC=[[TalkDetailViewController alloc]init];
        talkDetailVC.talkid=replayResult.cid;
        [controller.navigationController pushViewController:talkDetailVC animated:YES];
        
    }else if (replayResult.type==4)//meet
    {
        
        
    }else if (replayResult.type==5)//格调
    {
        GediaoDetailViewController *gediaoDetailVC=[[GediaoDetailViewController alloc]init];
        gediaoDetailVC.gediaoType=2;
        gediaoDetailVC.gediaoid=replayResult.cid;
        [controller.navigationController pushViewController:gediaoDetailVC animated:YES];
    
    }
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
