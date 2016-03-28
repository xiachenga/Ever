//
//  NewStyleViewController.m
//  Ever
//
//  Created by Mac on 15-3-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

NSString *const CollectionViewIdentifier = @"Cell";

#import "NewStyleViewController.h"
#import "StyleCell.h"
#import "GediaoDetailViewController.h"
#import "WorldTagIndexResult.h"
#import "TalkDetailViewController.h"
#import "WorldTagDetailResult.h"
#import "MeetViewCotroller.h"
#import "BigSocietyViewController.h"
#import "BaseNavigationController.h"
#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface NewStyleViewController ()<NSURLConnectionDataDelegate>

//格调数组
@property (nonatomic , strong) NSMutableArray *styles;

@property (nonatomic , assign) long lastIndex,firstIndex;

@property (nonatomic , assign) int pageNum,itemTag;


@property (nonatomic , strong) AVAudioPlayer *player;


@end

@implementation NewStyleViewController

//懒加载
-(NSMutableArray *)styles
{
    if (_styles==nil) {
        _styles=[NSMutableArray array];
    }
    return _styles;
}


/**
 *  初始化
 */

- (id)init
{
    //uiCollectionViewFlowLayout的初始化，
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //设置每个UICollectionView的大小
    layout.itemSize=CGSizeMake(kScreen_Width*0.5-8,kScreen_Width*0.5+75);
    //设置每个UICollectinView的间距
    layout.sectionInset=UIEdgeInsetsMake(0, 6, 0, 6);
    //左右间的间距
    layout.minimumInteritemSpacing=4;
    //上下间的间距
    layout.minimumLineSpacing=2;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建meet按钮
    [self setupMeetButton];
    
    //创建UICollectionView
    [self setupCollectionView];
    
    //集成上拉刷新控件
    [self setupHeaderRefresh];
    
    //集成下拉刷新控件
    [self setupFooterRefresh];
    
    //加载声音文件
    
//     [self setupVoice];
    
    //加载数据
    
    [self loadNewStyle];

}
//- (void)setupVoice
//{
//    NSString *path  = [[NSBundle mainBundle] pathForResource:@"refreshing_sound" ofType:@"mp3"];
//    NSURL *url=[NSURL fileURLWithPath:path];
//    
//    AVAudioPlayer *player= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    player.volume=1;
//    player.numberOfLoops=2;
//    self.player=player;
//    [player prepareToPlay];
//    
//}

- (void)setupMeetButton
{
    UIButton *meetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    meetBtn.frame=CGRectMake(0, 64, kScreen_Width, 40);
    meetBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    meetBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 05, 0, 0);
    [meetBtn setBackgroundColor:[UIColor blackColor]];
    meetBtn.alpha=0.8;
    [meetBtn setTitle:@"Meet" forState:UIControlStateNormal];
    [meetBtn addTarget:self action:@selector(meetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:meetBtn];
    
    UIImageView *arrowView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrowView.frame=CGRectMake(kScreen_Width-40, 64+4, 32, 32);
    [self.view addSubview:arrowView];
}

//创建CollectionView
- (void)setupCollectionView
{
   
    self.collectionView.backgroundColor=kColor(230, 230, 224);
    
    self.collectionView.alwaysBounceVertical=YES;
    
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[StyleCell class] forCellWithReuseIdentifier:CollectionViewIdentifier];
}

//添加下拉加载控件
- (void)setupHeaderRefresh
{
    

       __unsafe_unretained typeof(self) vc = self;
    
    [self.collectionView addHeaderWithCallback:^{
        
        [vc refresh];
        
        [vc.player play];
        
    }];
    
}

// //加载数据，获得最新的格调
- (void)loadNewStyle
{

    [self.view beginLoading];
    

    
    NSString *urlstring=[kSeverPrefix stringByAppendingString:@"world/list"];
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    [params setValue:@"0" forKey:@"cursorID"];
    [params setValue:@"1" forKey:@"flushType"];
    [params setValue:@"6" forKey:@"pageSize"];
    [params setValue:@"1" forKey:@"pageNum"];
    
    [HttpTool send:urlstring params:params success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        [self.view endLoading];
    
        if (responseobj!=nil) {
            
            NSArray *array=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
            
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:(array.count>0) hasError:0 reloadButtonBlock:^(id sender) {
                
                [self refresh];
                
            }];
            
            
            //字典转模型
            if (array.count!=0) {
                
                NSArray *worldIndexs=[WorldTagIndexResult objectArrayWithKeyValuesArray:array];
                WorldTagIndexResult *lastWorldIndex=[worldIndexs lastObject];
                self.lastIndex=lastWorldIndex.world_tag_id;
                
                WorldTagIndexResult *firstWorldIndex=[worldIndexs firstObject];
                self.firstIndex=firstWorldIndex.world_tag_id;
                
                [self.styles addObjectsFromArray:worldIndexs];
                
                [self.collectionView reloadData];
                
                self.pageNum=2;
                
            }
        }else{
            
            [MBProgressHUD showError:@"似乎断开与互联网的连接"];
            
            [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
                
                [self loadNewStyle];
                
            }];
        }
        
    }];
    
   }

//刷新
- (void)refresh
{
    NSString *string=@"world/list";
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setValue:[NSString stringWithFormat:@"%ld",self.firstIndex] forKey:@"cursorID"];
    [params setValue:@"-1" forKey:@"flushType"];
    [params setValue:@"6" forKey:@"pageSize"];
    [params setValue:@"1" forKey:@"pageNum"];
    
    [HttpTool send:urlString params:params success:^(id responseobj) {
        
        
        
        if (responseobj!=nil) {
            
            NSArray *array =[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
            CLog(@"%@",array);
            
            if (array!=nil && array.count!=0) {
                
                
                NSArray *worldIndexs=[WorldTagIndexResult objectArrayWithKeyValuesArray:array];
                
                WorldTagIndexResult *firstWorldIndex=[worldIndexs firstObject];
                self.firstIndex=firstWorldIndex.world_tag_id;
                
                
                NSRange range=NSMakeRange(0, worldIndexs.count);
                NSIndexSet *indexSet=[NSIndexSet indexSetWithIndexesInRange:range];
                
                [self.styles insertObjects:worldIndexs atIndexes:indexSet];
                
                [self.collectionView reloadData];
                
                [self.view configBlankPage:BlankPagetypeEmpty hasData:array.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                    
                    
                }];
                
                
            }else{
                
                [MBProgressHUD showError:@"没有最新数据"];
            }
            
            
        }
        
        [self.collectionView headerEndRefreshing];
        
    }];
    
}

- (void)setupFooterRefresh
{
    
    __unsafe_unretained typeof(self) vc = self;
    [self.collectionView addFooterWithCallback:^{
        
        [vc loadMoreStyles];
        
    }];
    
    
}

//获取更多
- (void)loadMoreStyles
{
    NSString *string=@"world/list";
    
    NSString *urlstring=[kSeverPrefix stringByAppendingString:string];
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    [params setValue:[NSString stringWithFormat:@"%ld",self.lastIndex] forKey:@"cursorID"];
    [params setValue:@"1" forKey:@"flushType"];
    [params setValue:@"6" forKey:@"pageSize"];
    [params setValue:[NSString stringWithFormat:@"%d",self.pageNum] forKey:@"pageNum"];
    
    [HttpTool send:urlstring params:params success:^(id responseobj) {
        
        
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
        
        CLog(@"%@",array);
        
        if (array.count!=0)
        {
            NSArray *worldIndexs=[WorldTagIndexResult objectArrayWithKeyValuesArray:array];
            
            [ self.styles addObjectsFromArray:worldIndexs];
            
            [self.collectionView reloadData];
            WorldTagIndexResult *lastWorldIndex= [worldIndexs lastObject];
            self.lastIndex=lastWorldIndex.world_tag_id;
            
            self.pageNum++;
            
        }else
        {
            //提示用户没有更多数据
            [MBProgressHUD showError:@"没有更多格调"];
        }
        
     
        [self.collectionView footerEndRefreshing];
        
    }];
    
}

#pragma mark UITableViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.styles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StyleCell  *styleCell=[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewIdentifier forIndexPath:indexPath];
    
    if (styleCell==nil) {
        styleCell=[[StyleCell alloc]init];
    }
    
    styleCell.style=self.styles[indexPath.row];
    
    
    styleCell.tag=indexPath.row;
    
    return styleCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //取出点击的cell
    WorldTagIndexResult *worldIndex=self.styles[indexPath.row];
    
    
    //为了删除标记tag值
    self.itemTag=indexPath.row;
    
    
    switch (worldIndex.tag_type) {
        case 3:
        {
            CLog(@"这个是日记");
            TalkDetailViewController *talkDetailVC=[[TalkDetailViewController alloc]init];
            talkDetailVC.type=1;
            talkDetailVC.talkid=worldIndex.world_tag_id;
            [self.navigationController pushViewController:talkDetailVC animated:YES];
        }
            break;
        case 5:
        {
            CLog(@"这个是格调");
            GediaoDetailViewController *gediaoDetailVC=[[GediaoDetailViewController alloc]init];
            gediaoDetailVC.gediaoType=1;
            gediaoDetailVC.gediaoid=worldIndex.world_tag_id;
            
            [self.navigationController pushViewController:gediaoDetailVC animated:YES];
            
        }
            break;
    }

}

- (void)meetBtnClicked
{

   
        MeetViewCotroller *meetVC=[[MeetViewCotroller alloc]init];
        [self.navigationController pushViewController:meetVC animated:YES];
    
}

//格调删除的刷新
- (void)gediaoDeleteRefrsh {
    
    [self.styles removeObjectAtIndex:self.itemTag];
    
    [self.collectionView reloadData];
    
}



@end
