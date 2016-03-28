//
//  ArticleIndexResultViewController.m
//  Ever
//
//  Created by Mac on 15-4-2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ArticleIndexResultViewController.h"
#import "ArticleIndexResult.h"
#import "ArticleDetailViewController.h"
#import "AllAroundPullView.h"

@interface ArticleIndexResultViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *articleScrollView;

@property (nonatomic , assign) long lastIndexId,firstIndexId;

@property (nonatomic , assign) int pageNum;

@property (nonatomic , strong) NSMutableArray *articles;

@end

@implementation ArticleIndexResultViewController


-(NSMutableArray *)articles
{
    if (!_articles) {
        _articles=[NSMutableArray array];
    }
    return _articles;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title=LOCALIZATION(@"CoffeeReadTimeTitle");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //初始化scrollview
    [self setupScrollView];
    
    //添加左右滑动控件
    [self addRefreshControl];
    
    [self loadCoffee];
}

- (void)addRefreshControl
{
    AllAroundPullView *rightPullView = [[AllAroundPullView alloc] initWithScrollView:self.articleScrollView position:AllAroundPullViewPositionRight action:^(AllAroundPullView *view){
        
       [self loadMoreCoffee:view];
        
    }];
    [self.articleScrollView addSubview:rightPullView];

}

- (void)setupScrollView
{
    
    UIScrollView *articleScrollView=[[UIScrollView alloc]init];
    articleScrollView.frame=CGRectMake(0,0, kScreen_Width, kScreen_Height);
    articleScrollView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    articleScrollView.showsHorizontalScrollIndicator=NO;
    articleScrollView.pagingEnabled=YES;
    articleScrollView.delegate=self;
    
    articleScrollView.contentSize=self.view.bounds.size;
    
    articleScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.articleScrollView=articleScrollView;
    [self.view addSubview:articleScrollView];
}

//加载数据
- (void)loadCoffee
{

    [self.view beginLoading];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:@"coffee/list/1/3/1/0"];
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        [self.view endLoading];
        
        if (responseobj!=nil) {
            NSArray *articles=[ArticleIndexResult objectArrayWithKeyValuesArray:responseobj];
            
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:articles.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
                
            }];
            ArticleIndexResult *firstArticleIndex=[articles firstObject];
            self.firstIndexId=firstArticleIndex.article_id;
            
            ArticleIndexResult *lastArticleIndex=[articles lastObject];
            self.lastIndexId=lastArticleIndex.article_id;
            
            [self.articles addObjectsFromArray:articles];
            
        
            self.articleScrollView.contentSize=CGSizeMake(kScreen_Width*self.articles.count, 0);
            
            [self reloadData];
            
            
            self.pageNum=2;
            
        }
        
        
    } failure:^(NSError *erronr) {
        
        [MBProgressHUD showError:@"似乎已断开与互联网的连接"];
        
        [self.articleScrollView configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            

            [self loadCoffee];
            
        }];
        
        [self.view endLoading];
        
    }];
}


//加载更多
- (void)loadMoreCoffee:(AllAroundPullView *)view
{

     [self.view beginLoading];
   
    NSString *string=[NSString stringWithFormat:@"coffee/list/1/3/%d/%ld",self.pageNum, self.lastIndexId];
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
       [self.view endLoading];
        
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            
            NSArray *articleArray=[ ArticleIndexResult objectArrayWithKeyValuesArray:responseobj];
            
            if (articleArray.count!=0) {
                
                [self.articles addObjectsFromArray:articleArray];
                
                self.articleScrollView.contentSize=CGSizeMake(kScreen_Width*self.articles.count, 0);
                ArticleIndexResult *articleIndex=[articleArray lastObject];
                
                
                self.lastIndexId=articleIndex.article_id;
                self.pageNum++;
                
                [self reloadData];
                
            }else{
                [MBProgressHUD showError:@"没有更多数据"];
            }
            
        }else{
            
            [MBProgressHUD showError:@"没有网络"];
        }
        
    } failure:^(NSError *erronr) {
        
        CLog(@"%@",erronr);
        
    }];
}


- (void)reloadData
{
    for (int i=0; i<self.articles.count; i++) {
        
        ArticleIndexResult *articleIndex=self.articles[i];
        
        //大图
        UITapImageView *imageView=[[UITapImageView alloc]init];
        
        if (kDevice_Is_iPhone4) {
            
            imageView.frame=CGRectMake(10+i*kScreen_Width,10, kScreen_Width-20, kScreen_Width-30);
        }else{
            
            imageView.frame=CGRectMake(10+i*kScreen_Width,20, kScreen_Width-20, kScreen_Width-20);
        }

        [self.articleScrollView addSubview:imageView];
        NSURL *imageUrl=[NSURL URLWithString:articleIndex.title_image_url];
        [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"pictureholder"]];
        
        //标题
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=articleIndex.title;
        titleLabel.numberOfLines=0;
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        
        CGSize titleLabelSize=[titleLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        
        UIImageView *titleView=[[UIImageView alloc]initWithImage:[UIImage resizedImageWithName:@"paihangbang_beijing"]];
        [titleView addSubview:titleLabel];
        
        titleLabel.frame=CGRectMake(10, 10, kScreen_Width-40, titleLabelSize.height);
        
        titleView.frame=CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame), kScreen_Width-2*10, titleLabelSize.height+20);
        
        [self.articleScrollView addSubview:titleView];
        
        //时间
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=articleIndex.create_time;
        timeLabel.font=[UIFont systemFontOfSize:24];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        UIImageView *timeView=[[UIImageView alloc]initWithImage:[UIImage resizedImageWithName:@"paihangbang_beijing"]];
        
        [timeView addSubview:timeLabel];
        
        timeLabel.frame=CGRectMake(0, 10, kScreen_Width-20, 24);
        timeView.frame=CGRectMake(CGRectGetMinX(imageView.frame),
                                  CGRectGetMaxY(titleView.frame)+1,  kScreen_Width-20, 45);
        
        [self.articleScrollView addSubview:timeView];
        
        [imageView addTapBlock:^(id obj) {
            
            [self gotoCoffeeDetail:articleIndex.article_id];
            
        }];
        
        
    }
  
}


- (void)gotoCoffeeDetail:(long)articleid
{
    ArticleDetailViewController *articleDetail=[[ArticleDetailViewController alloc]init];
    articleDetail.articleID=articleid;
    [self.navigationController pushViewController:articleDetail animated:YES];
    
}

#pragma ScrollViewDelegtate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{

    if (scrollView.contentOffset.x<0) {
        self.articleScrollView.scrollEnabled=NO;
    }else
    {
        self.articleScrollView.scrollEnabled=YES;
    }
        
}

- (void)languageChange
{

    self.title=LOCALIZATION(@"CoffeeReadTimeTitle");
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}


@end
