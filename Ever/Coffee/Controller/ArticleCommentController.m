//
//  ArticleCommentController.m
//  Ever
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ArticleCommentController.h"
#import "ArticleCommentResult.h"
#import "AllAroundPullView.h"
#import "BigImageViewController.h"

#import "JubaoViewController.h"
#import "ReleaseaViewController.h"
#import "CustomAnimationView.h"

#import "KindItem.h"

#import "YCXMenu.h"
@interface ArticleCommentController ()

@property (nonatomic,weak)UIScrollView *scrollView,*verticalScrollView;

@property (nonatomic , strong) NSMutableArray *articleArray;
@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , assign) long firstID,lastID;
@property (nonatomic , assign) int pageNum;

@property (nonatomic , weak) UILabel *numLabel;

@end


@implementation ArticleCommentController

- (NSMutableArray *)items {
    if (!_items) {
        
        _items = [@[
                    [YCXMenuItem menuItem:LOCALIZATION(@"ArticleComment")
                                    image:[UIImage imageNamed:@"coffee_pinglun"]
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    
                    [YCXMenuItem menuItem:LOCALIZATION(@"ArticleReport")
                                    image:[UIImage imageNamed:@"meet_jubao"]
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    
                    ] mutableCopy];
    }
    return _items;
}
-(NSMutableArray *)articleArray
{
    if (_articleArray==nil) {
        _articleArray=[NSMutableArray array];
    }
    return _articleArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=LOCALIZATION(@"CoffeeComment");
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pointBtn_Nav"]  style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    
    
    UIScrollView *verticalScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.verticalScrollView=verticalScrollView;
    verticalScrollView.contentSize=CGSizeMake(0, kScreen_Height+50);
    [self.view addSubview:verticalScrollView];
    
    //创建scrollview
    [self setupScrollview];
    

    AllAroundPullView *rightPullView = [[AllAroundPullView alloc] initWithScrollView:self.scrollView position:AllAroundPullViewPositionRight action:^(AllAroundPullView *view){
        
        [self loadMoreData:view];
        
    }];
    [self.scrollView addSubview:rightPullView];
    
}
- (void)setupScrollview
{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.pagingEnabled=YES;
    scrollView.contentSize=self.view.bounds.size;
    [self.verticalScrollView addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView=scrollView;
    
}

-(void)setArticleID:(long)articleID
{
    _articleID=articleID;
    
    [self loadData];
    
}

//加载数据
- (void)loadData
{

    [self.view beginLoading];
    
    NSString *string=[NSString stringWithFormat:@"coffee/comment/list/%ld/1/5/1/0",self.articleID];
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
   
        [self.view endLoading];
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            
            NSArray *articles=[ArticleCommentResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:articles.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            if (articles.count>0) {
                
                ArticleCommentResult *firstArticle=[articles firstObject];
                self.firstID=firstArticle.comment_id;
                
                ArticleCommentResult *lastArticle=[articles lastObject];
                self.lastID=lastArticle.comment_id;
                
                
                [self.articleArray addObjectsFromArray:articles];
                [self reloadData];
                
                self.pageNum=2;
            }
        }else{
            
            [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
        }
        
    } failure:^(NSError *erronr) {
        
        
        
    }];
}



- (void)loadMoreData:(AllAroundPullView *)view
{
    NSString *string=[NSString stringWithFormat:@"coffee/comment/list/%ld/1/5/%d/%ld",self.articleID,self.pageNum,self.lastID];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
     
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        
        
        CLog(@"%@",responseobj);
        if (responseobj!=nil) {
            
            NSArray *articles=[ArticleCommentResult objectArrayWithKeyValuesArray:responseobj];
            
            if (articles.count>0) {
                
                ArticleCommentResult *lastArticle=[articles lastObject];
                self.lastID=lastArticle.comment_id;
                 [self.articleArray addObjectsFromArray:articles];
                [self reloadData];
                self.pageNum++;
                
            }else
            {
                [MBProgressHUD showError:@"没有更多数据"];
            }
            
        }
        
    } failure:^(NSError *erronr) {
        
    }];
    
    
}

//刷新
-(void)refresh{
    
    NSString *string=[NSString stringWithFormat:@"coffee/comment/list/%ld/-1/5/0/%ld",self.articleID,self.firstID];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            
            NSArray *articleComments=[ArticleCommentResult objectArrayWithKeyValuesArray:responseobj];
            
            if (articleComments.count>0) {
            
              [self.view configBlankPage:BlankPagetypeEmpty hasData:1 hasError:0 reloadButtonBlock:^(id sender) {
                  
              }];
                
                [self.articleArray insertObject:articleComments[0] atIndex:0];
                
                //通知代理，评论成功
                if ([self.delegate respondsToSelector:@selector(articleCommentSuccess)]) {
                    
                    [self.delegate articleCommentSuccess];
                }
                
                
                [self reloadData];
                
            }else
            {
                [MBProgressHUD showError:@"没有更多数据"];
            }
            
        }
        
    } failure:^(NSError *erronr) {
        
    }];
    
    
    
}


//重新加载数据
- (void)reloadData
{
    long count=self.articleArray.count;
    self.scrollView.contentSize=CGSizeMake(kScreen_Width*count, 0);
    
    for (int i=0; i<count; i++) {
        
        ArticleCommentResult *articleResult=self.articleArray[i];
        ImageResult *image=articleResult.image;
        
        UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake(i*kScreen_Width, 0, kScreen_Width, kScreen_Width)];
        [self.scrollView addSubview:imageView];
        [imageView addTapBlock:^(id obj) {
           
            [self gotoBigImage:image.image_id];
        }];
        [imageView sd_setImageWithURL: [NSURL URLWithString:image.image_url]  placeholderImage:[UIImage imageNamed:@"pictureholder"]];
        
        [self addLabels:articleResult.image.labels andsuperView:imageView];
        
        
    //头像
        
        UIImageView *avatarView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)-150, CGRectGetMaxY(imageView.frame)+10, 50, 50)];
        [avatarView doCircleFrame];
        [self.scrollView addSubview:avatarView];
        [avatarView sd_setImageWithURL:[NSURL URLWithString:articleResult.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
        
    //昵称
        
        UILabel *nickName=[[UILabel alloc]init];
        nickName.font=[UIFont systemFontOfSize:15];
        nickName.numberOfLines=0;
        nickName.text=articleResult.user_nickname;
        CGSize nickNameSize=[articleResult.user_nickname boundingRectWithSize:CGSizeMake(80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 ]} context:nil].size;
        nickName.frame=(CGRect){{CGRectGetMaxX(avatarView.frame)+5,CGRectGetMinY(avatarView.frame)+5},nickNameSize};
        [self.scrollView addSubview:nickName];
        
        
    //时间
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nickName.frame), CGRectGetMaxY(nickName.frame)+5, 80, 15)];
        timeLabel.font=[UIFont systemFontOfSize:12];
        timeLabel.text=articleResult.create_time;
        timeLabel.textColor=[UIColor grayColor];
        [self.scrollView addSubview:timeLabel];
        
        UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+30, CGRectGetMaxY(avatarView.frame)+10, 60, 60)];
        numLabel.text=[NSString stringWithFormat:@"%d",i+1];
        self.numLabel=numLabel;
        numLabel.font=[UIFont boldSystemFontOfSize:40];
        numLabel.textColor=kThemeColor;
        [self.scrollView addSubview:numLabel];
       
        
        //内容
        UILabel *contentLabel=[[UILabel alloc]init];
        contentLabel.text=articleResult.content;
        contentLabel.numberOfLines=0;
        contentLabel.font=[UIFont systemFontOfSize:15];
        CGSize contentSize=[contentLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width*0.5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        contentLabel.frame=(CGRect){{20,15},contentSize};
        
        //内容背景
        UIImageView *bgImageView=[[UIImageView alloc]init];
         bgImageView.frame=CGRectMake(CGRectGetMinX(imageView.frame)+100, CGRectGetMinY(numLabel.frame), kScreen_Width*0.6, contentSize.height+30);
        bgImageView.image=[UIImage resizedImageWithName:@"coffee_pinglun_bubble"];
        [self.scrollView addSubview:bgImageView];

        [bgImageView addSubview:contentLabel];

    }

}

- (void)gotoBigImage:(long)imageID
{
    BigImageViewController *bigImageVC=[[BigImageViewController alloc]init];

    bigImageVC.imageID=imageID;
    
    [self.navigationController pushViewController:bigImageVC animated:YES];
    
}
//弹出菜单
-(void)showMenu
{
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setHasShadow:YES];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        
        if (item.tag==100) {
            
            if ([AccountTool isLogin]) {
                KindItem *kind=[[KindItem alloc]init];
                kind.itemID=self.articleID;
                kind.kind=5;
                
                ReleaseaViewController *albumVC=[[ReleaseaViewController alloc]init];
                
                albumVC.kind=kind;
                
                
                
                [self.navigationController pushViewController:albumVC animated:YES];
            }else{
                DoAlertView *alertView=[[DoAlertView alloc]init];
                [alertView show];
                                        
            }
            
        }else if(item.tag==101)
        {
            JubaoViewController *jubaoVC=[[JubaoViewController alloc]init];
            [self.navigationController pushViewController:jubaoVC animated:YES];
            
        }
    }];

    
}


- (void)addLabels:(NSArray *)labels andsuperView:(UIImageView *)imageView
{
    for (int i=0; i<labels.count; i++) {
        
        LabelResult *labelResult=labels[i];
        CustomAnimationView *animationView=[[CustomAnimationView alloc ]init];
        animationView.label=labelResult;
        [imageView addSubview:animationView];
        
    }
              
}


@end
