//
//  FashionShoppingViewController.m
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "FashionShoppingViewController.h"
#import "ShowcaseIndexResult.h"
#import "FashionShopCell.h"
#import "ShopViewController.h"

@interface FashionShoppingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *fashionList;

@property (nonatomic , weak) UITableView *myTableView;

@end

@implementation FashionShoppingViewController

-(NSMutableArray *)fashionList{
    if (_fashionList==nil) {
        _fashionList=[NSMutableArray array];
    }
    return _fashionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.title=@"品牌橱窗";
    //加载数据
    [self loadData];
    
    [self setupTableView];
    
}

//加载数据
- (void)loadData {
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"business/showcase/list/1/3/1/0"];
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        NSArray *fashionList=[ShowcaseIndexResult objectArrayWithKeyValuesArray:responseobj];
        
   
            [self.fashionList addObjectsFromArray:fashionList];
            
            [self.myTableView reloadData];
        
    
        
    } failure:^(NSError *erronr) {
        
    }];

}

- (void)setupTableView{
    
    UITableView *myTableView=[[UITableView alloc]init];
    [self.view addSubview:myTableView];
    self.myTableView=myTableView;
    myTableView.tableFooterView=[[UIView alloc]init];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.edges.mas_equalTo(self.view);
    }];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    
    
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fashionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"FashionCell";
      
    ShowcaseIndexResult *fashionCase=self.fashionList[indexPath.row];

    
    
    FashionShopCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[FashionShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.shopLogoviewClicked=^(void){
//        
//        [self gotoShop:fashionCase.bid];
    };
    cell.fashionCase=fashionCase;
    
  
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 310;
}


//进入商店首页
- (void)gotoShop:(long)bid {
    
    ShopViewController *shopVC =[[ShopViewController alloc]init];
    shopVC.bid=bid;
    [self.navigationController pushViewController:shopVC animated:YES];
    
    
}


@end
