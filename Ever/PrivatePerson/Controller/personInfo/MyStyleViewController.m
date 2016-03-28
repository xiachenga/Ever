//
//  MyStyleViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


NSString *const MyStyleCollectionViewIdentifier = @"StyleCell";
#import "MyStyleViewController.h"
#import "LoginResult.h"
#import "MyGediaoIndexResult.h"
#import "GediaoDetailViewController.h"
#import "ReleaseaViewController.h"
@interface MyStyleViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong)NSMutableArray *stylesArray;

@property (nonatomic , assign) int indexTag;

@end

@implementation MyStyleViewController


-(NSMutableArray *)stylesArray{
    
    if (_stylesArray==nil) {
        _stylesArray=[NSMutableArray array];
    }
    return _stylesArray;
}

/**
 *  初始化
 *
 *  @return <#return value description#>
 */
- (id)init
{
    //uiCollectionViewFlowLayout的初始化，
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //设置每个UICollectionView的大小
    layout.itemSize=CGSizeMake((kScreen_Width-15)*0.5,(kScreen_Width-15)*0.5);
    layout.sectionInset=UIEdgeInsetsMake(5, 5, 0, 5);
    //左右间的间距
    layout.minimumInteritemSpacing=2;
    //上下间的间距
    layout.minimumLineSpacing=5;
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=LOCALIZATION(@"MyDataStyle");
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fabu_xiangji"] style:UIBarButtonItemStylePlain target:self action:@selector(upLoadStyle)];
    
    [self setupCollectionView];
    
    [self loadData];

}

- (void)setupCollectionView
{
    
    self.collectionView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.collectionView.alwaysBounceVertical=YES;
    
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MyStyleCollectionViewIdentifier];
}

- (void)loadData
{
    [self.view beginLoading];
    
    LoginResult *account=[AccountTool account];
    NSString *string=[NSString stringWithFormat:@"user/gediao/%ld/1/20/1/0",account.user_id];
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        [self.view endLoading];
        
       
        
        if (responseobj!=nil) {
             NSArray *styles=[MyGediaoIndexResult objectArrayWithKeyValuesArray:responseobj];
            
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:styles.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            
            if (styles.count!=0) {
                
            
                self.stylesArray=(NSMutableArray *)styles;
                 
                [self.collectionView reloadData];
                
            }
        }else
        {
            [self.view configBlankPage:BlankPagetypeEmpty hasData:0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
        }
        
    
    } failure:^(NSError *erronr) {
    
        [self.view endLoading];
        
        [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [MBProgressHUD showError:@"似乎断开与互联网的连接"];
            [self loadData];
            
        }];
        
    }];
  
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.stylesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyGediaoIndexResult *gediaoIndex=self.stylesArray[indexPath.row];
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:MyStyleCollectionViewIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UICollectionViewCell alloc]init];
    
    }
    
    CGFloat leftPadding=5;
    CGFloat imageW=(kScreen_Width-3*leftPadding)*0.5;
    
    UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageW)];
    NSURL *url=[NSURL URLWithString:gediaoIndex.image_url];
    
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pictureholder"]];
    
    [imageView addLongTapBlock:^(id obj) {
        
        
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"是否删除" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate=self;
        
        //为了删除让alertView的下标等于每个item的下标
        
        alertView.tag=indexPath.row;
        
        
        [alertView show];
        
    }];
    
    [cell.contentView addSubview:imageView];
    
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyGediaoIndexResult *myGediaoIndex=self.stylesArray[indexPath.row];
    GediaoDetailViewController *gediaoDetailVC=[[GediaoDetailViewController alloc]init];
    gediaoDetailVC.gediaoid=myGediaoIndex.gediao_id;
    
    [self.navigationController pushViewController:gediaoDetailVC animated:YES];
    
}


//上传形象
- (void)upLoadStyle
{
    ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
    
    KindItem *kind=[[KindItem alloc]init];
    kind.kind=2;
    releaseVC.kind=kind;
    [self.navigationController pushViewController:releaseVC animated:YES];
    
}


#pragma  mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (buttonIndex==0) {
        
        
    }else if (buttonIndex==1){
        
         MyGediaoIndexResult *gediaoIndex=self.stylesArray[alertView.tag];
        
        NSString *string=[NSString stringWithFormat:@"%@gediao/del/%ld",kSeverPrefix,gediaoIndex.gediao_id];
        [HttpTool get:string params:nil success:^(id responseobj) {
            
            [self.stylesArray removeObjectAtIndex:alertView.tag];
            
            [self.collectionView reloadData];
            
        } failure:^(NSError *erronr) {
            
        }];
        
    }
}


- (void)languageChange
{
    CLog(@"收到通知");
    
    self.title=LOCALIZATION(@"MyDataStyle");
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}


@end
