//
//  MyFigureViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

NSString *const MyFigureCollectionViewIdentifier = @"FigureCell";
#import "MyFigureViewController.h"
#import "ImageResult.h"
#import "BigImageViewController.h"
#import "ReleaseaViewController.h"
#import "KindItem.h"
@interface MyFigureViewController ()<UIAlertViewDelegate>

//@property (nonatomic,weak)UIScrollView *scrollView;

@property (nonatomic , strong) NSMutableArray *imageArray;


@end

@implementation MyFigureViewController


//懒加载
-(NSMutableArray *)imageArray{
    
    if (_imageArray==nil) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}

- (id)init
{
    //uiCollectionViewFlowLayout的初始化，
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //设置每个UICollectionView的大小
    layout.itemSize=CGSizeMake(kScreen_Width-20,kScreen_Width-20);
    layout.sectionInset=UIEdgeInsetsMake(5, 10, 10, 10);
    
    //上下间的间距
    layout.minimumLineSpacing=5;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    self.title=LOCALIZATION(@"MyDataFigure");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fabu_xiangji"] style:UIBarButtonItemStylePlain target:self action:@selector(upLoadFigure)];
    
    [self setupCollectionView];
    
    [self loadData];

}

- (void)setupCollectionView
{
    
    self.collectionView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.collectionView.alwaysBounceVertical=YES;
    
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MyFigureCollectionViewIdentifier];
}

//加载数据
- (void)loadData
{
    [self.view beginLoading];
    

     NSString *string=[kSeverPrefix stringByAppendingString:@"user/xingxiang"];
    
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        [self.view endLoading];
        
        if (responseobj!=nil) {
            
            
             NSArray *images=[ImageResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.imageArray addObjectsFromArray:images];
            
            [self.collectionView reloadData];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:images.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageResult *image=self.imageArray[indexPath.row];
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:MyFigureCollectionViewIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UICollectionViewCell alloc]init];
        
    }
    
    CGFloat imageW=kScreen_Width-20;
    
    UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageW)];
    NSURL *url=[NSURL URLWithString:image.image_url];
    
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
    
     ImageResult *image=self.imageArray[indexPath.row];
     [self gotoBigImageWithUrl:image.image_id];
    
}

- (void)gotoBigImageWithUrl:(long )imageID
{
    BigImageViewController *bigImageVC=[[BigImageViewController alloc]init];
    bigImageVC.imageID=imageID;
    [self.navigationController pushViewController:bigImageVC animated:YES];
    
}


#pragma UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
     ImageResult *image=self.imageArray[alertView.tag];
    
    if (buttonIndex==0) {
        CLog(@"取消");
    }else if(buttonIndex==1) {
        
        NSString *string=[NSString stringWithFormat:@"%@user/xingxiang/del/%ld",kSeverPrefix,image.image_id];
        
        [HttpTool get:string params:nil success:^(id responseobj) {
            
            NormalResult *result=[NormalResult objectWithKeyValues:responseobj];
            
            [MBProgressHUD showError:result.prompt];
            
            [self.imageArray removeObjectAtIndex:alertView.tag];
            [self.collectionView reloadData];
            
        } failure:^(NSError *erronr) {
            
        }];
        
        
    }
    
}


//上传形象
- (void)upLoadFigure
{
    ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
    
    KindItem *kind=[[KindItem alloc]init];
    kind.kind=1;
    releaseVC.kind=kind;

    [self.navigationController pushViewController:releaseVC animated:YES];

}



- (void)languageChange
{
    CLog(@"收到通知");
    
    self.title=LOCALIZATION(@"MyDataFigure");
        
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}




@end
