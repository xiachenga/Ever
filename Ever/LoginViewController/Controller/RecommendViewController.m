//
//  RecommendViewController.m
//  Ever
//
//  Created by Mac on 15-4-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


NSString *const CollectionViewCellIdentifier = @"Cell";

#import "RecommendViewController.h"
#import "CustomView.h"
#import "HttpTool.h"
#import "HeadimageResult.h"
#import "RegisterSucessViewController.h"
#import "NormalResult.h"


@interface RecommendViewController ()

@property (nonatomic,strong)NSMutableArray *headerArrays;


@property (nonatomic , strong) NSMutableArray *imageArrays;

@property (nonatomic , strong) NSMutableArray *userIDArrays;

@end

@implementation RecommendViewController

-(NSMutableArray *)headerArrays
{
    if (_headerArrays==nil) {
        _headerArrays=[NSMutableArray array];
    }
    return _headerArrays;
    
}

-(NSMutableArray *)imageArrays
{
    if (_imageArrays==nil) {
        _imageArrays=[NSMutableArray array];
    }
    return _imageArrays;
    
}


-(NSMutableArray *)userIDArrays
{
    if (_userIDArrays==nil) {
        _userIDArrays=[NSMutableArray array];
    }
    return _userIDArrays;
    
}

- (id)init
{
    //uiCollectionViewFlowLayout的初始化，
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //设置每个UICollectionView的大小
    layout.itemSize=CGSizeMake(kScreen_Width*0.25,kScreen_Width*0.25);
    //设置每个UICollectinView的间距
    CGFloat padding=(kScreen_Width-kScreen_Width*0.75)*0.25;
    layout.sectionInset=UIEdgeInsetsMake(10, padding, 0, padding);
    //左右间的间距
    layout.minimumInteritemSpacing=2;
    //上下间的间距
    layout.minimumLineSpacing=20;
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnClicked)];
      self.title=@"推荐关注";
    
    [self setupCollectionView];
    
    [self loadHeaderImage];
    
}
- (void)setupCollectionView
{
    self.collectionView.backgroundColor=kColor(230, 230, 224);
    
    self.collectionView.alwaysBounceVertical=YES;
    
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
}


//加载网络数据
- (void)loadHeaderImage
{
   // NSString *urlstring=@"https://manager.ooo.do/server/user/focus_user";
    
     NSString *urlstring=[kSeverPrefix stringByAppendingString:@"user/focus_user"];
    
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        
        NSArray *array=[HeadimageResult objectArrayWithKeyValuesArray:responseobj];
        [self.headerArrays addObjectsFromArray:array];
        
       
        [self.collectionView reloadData];
       
   } failure:^(NSError *erronr) {
       
   }];
    
}

- (void)sureBtnClicked
{
    NSString *urlstring=@"https://manager.ooo.do/server/user/batch_focus";
    
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    
    NSMutableString *email=[NSMutableString string];
    for (int i=0; i<self.userIDArrays.count; i++) {
        
        NSNumber *userID=self.userIDArrays[i];
        [email appendString:[NSString stringWithFormat:@"%@",userID]];
        
        if (i==self.userIDArrays.count-1) {
            [email appendString:@""];
        }else
        {
          [email appendString:@","];
        }
        
}
    [params setValue:email  forKey:@"email"];
    
    
    [HttpTool send:urlstring params:params success:^(id responseobj) {
        
        if (responseobj!=nil) {
            
             NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
           
            
            if (dic!=nil) {
                NormalResult *normal=[NormalResult objectWithKeyValues:dic];
                [MBProgressHUD showError:normal.prompt];
                
                
                if (normal.if_success==1) {
                    
                    RegisterSucessViewController *registerVC=[[RegisterSucessViewController alloc]init];
                    [self.navigationController pushViewController:registerVC animated:YES];
                    
                }
                
            }
            
        }
        
        
}];
    
}


#pragma uicollectionViewcontorllerdelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.headerArrays.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
       
    UICollectionViewCell  *headerCell=[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (headerCell==nil) {
        headerCell=[[UICollectionViewCell alloc]init];
}
    
   CustomView *headerView=[[CustomView alloc]init];
    headerView.headImage=self.headerArrays[indexPath.row];
    [headerCell.contentView addSubview:headerView];
    
    [self.imageArrays addObject:headerView];
    
    return headerCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    CustomView *view=self.imageArrays[indexPath.row];
   HeadimageResult *header=self.headerArrays[indexPath.row];
    if (!view.isSelected) {
        
        NSNumber *userid=[NSNumber numberWithLong:header.user_id];
        [self.userIDArrays addObject:userid];
        
        view.imageView.layer.borderColor=kThemeColor.CGColor;
        view.duihaoView.hidden=NO;
        
        view.isSelected=YES;
        
        
    }else{
        
        
        NSNumber *userid=[NSNumber numberWithLong:header.user_id];
        [self.userIDArrays removeObject:userid];
        
        view.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
        view.duihaoView.hidden=YES;
        view.isSelected=NO;
    }
    
    
   
    
}








@end
