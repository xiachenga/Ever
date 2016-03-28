//
//  ArticleDetailViewController.m
//  Ever
//
//  Created by Mac on 15-4-3.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleDetailResult.h"
#import "ImageResult.h"
#import "BigImageViewController.h"
#import "ArticleCommentController.h"


@interface ArticleDetailViewController ()<UMSocialUIDelegate,UIScrollViewDelegate,ArticleCommentControllerDelegate>

@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic , weak) UIScrollView *pictureScrollView,*totalScrollView ;
@property (nonatomic , weak)  UILabel *timeLabel,*titleLabel,*contextLabel,*EVER,*qiNum,*commentNum;

@property (nonatomic , weak) UIView *bgView;
@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , strong) ArticleDetailResult *articleDetail;

@property (nonatomic , weak) UIButton *commentBtn,*zanBtn;


@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];

    [self setupNavigationItem];
    
    //设置整个scrollview
    [self setuptotalScrollView];
    
    //设置图片的scrollview
    [self setupPictureScrollView];
    
}

//设置NavigationItem
- (void)setupNavigationItem
{
    UIButton *zanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:[UIImage imageNamed:@"coffee_zan"] forState:UIControlStateNormal];
    zanBtn.size=CGSizeMake(40, 40);
    self.zanBtn=zanBtn;
    [zanBtn addTarget:self action:@selector(zanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *zanBtnitem=[[UIBarButtonItem alloc]initWithCustomView:zanBtn];
    
    UIButton *commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"coffee_pinglun"] forState:UIControlStateNormal];
    commentBtn.size=CGSizeMake(40, 40);
    self.commentBtn=commentBtn;
    [commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentBtnitme=[[UIBarButtonItem alloc]initWithCustomView:commentBtn];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"meet_fenxiang"] forState:UIControlStateNormal];
    shareBtn.size=CGSizeMake(40, 40);
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *shareBtnitme=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems=@[shareBtnitme,commentBtnitme,zanBtnitem];
}

- (void)setuptotalScrollView
{
    UIScrollView *totalScrollView=[[UIScrollView alloc]init];
    self.totalScrollView=totalScrollView;
    totalScrollView.frame=self.view.bounds;
    totalScrollView.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:totalScrollView];
    
    //多少期
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=kThemeColor;
    self.bgView=bgView;
    [totalScrollView addSubview:bgView];
    
    UILabel *EVER=[[UILabel alloc]init];
    EVER.font=[UIFont systemFontOfSize:18];
    EVER.text=@"EVER TIME";
    self.EVER=EVER;
    [bgView addSubview:EVER];
   
    //期刊数
    UILabel *qiNum=[[UILabel alloc]init];
    qiNum.font=[UIFont systemFontOfSize:15];
    qiNum.textColor=[UIColor grayColor];
    self.qiNum=qiNum;
    [totalScrollView addSubview:qiNum];
    
    
    //时间
    UILabel *timeLabel=[[UILabel alloc]init];
    [totalScrollView addSubview:timeLabel];
    timeLabel.textColor=[UIColor grayColor];
    self.timeLabel=timeLabel;
    timeLabel.font=[UIFont systemFontOfSize:15];
    
    
    //标题
    UILabel *titleLabel=[[UILabel alloc]init];
    self.titleLabel=titleLabel;
    [totalScrollView addSubview:titleLabel];
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    
    
    //正文
    
    UILabel *contextLabel=[[UILabel alloc]init];
    self.contextLabel=contextLabel;
    [totalScrollView addSubview:contextLabel];
    contextLabel.font=[UIFont systemFontOfSize:15];

}

- (void)setupPictureScrollView
{
    UIScrollView *pictureScrollView=[[UIScrollView alloc]init];
    self.pictureScrollView=pictureScrollView;
   // pictureScrollView.pagingEnabled=YES;
    pictureScrollView.delegate=self;
    pictureScrollView.bounces=NO;
    pictureScrollView.frame=CGRectMake(0, 0, kScreen_Width, kScreen_Width-10);
    [self.totalScrollView addSubview:pictureScrollView];
}


-(void)setArticleID:(long)articleID
{
    _articleID=articleID;
    
    [self.view beginLoading];
   
    NSString *string=[NSString stringWithFormat:@"coffee/detail/%ld",articleID];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        [self.view endLoading];
        
        CLog(@"%@",responseobj);
    
        ArticleDetailResult *articleDetail=[ArticleDetailResult objectWithKeyValues:responseobj];
        self.articleDetail=articleDetail;
        self.pictureScrollView.contentSize=CGSizeMake((kScreen_Width-20)*articleDetail.images.count+10, 0) ;
        
        self.imageArray=articleDetail.images;
        
        
        //设置评论数
        
        if (articleDetail.comment_num>0) {
            
            UIImageView *bgCommentNum=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 25, 25)];
            [bgCommentNum doCircleFrame];
            bgCommentNum.backgroundColor=[UIColor redColor];
            
            UILabel *label=[[UILabel alloc]initWithFrame:bgCommentNum.bounds];
            label.font=[UIFont systemFontOfSize:12];
            [bgCommentNum addSubview:label];
            label.textAlignment=NSTextAlignmentCenter;
            label.text=[NSString stringWithFormat:@"%d",articleDetail.comment_num];
            self.commentNum=label;
            label.textColor=[UIColor whiteColor];
            [self.commentBtn addSubview:bgCommentNum];
        }
        
        //设置点赞红白点
        if (articleDetail.if_dianzan) {
            [self.zanBtn setImage:[UIImage imageNamed:@"coffee_zan_selected"] forState:UIControlStateNormal];
        }
       
        
        for (int i=0; i<articleDetail.images.count; i++) {
            
            
            
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.userInteractionEnabled=YES;
        
            imageView.layer.cornerRadius=5;
            imageView.layer.masksToBounds=YES;
            imageView.frame=CGRectMake(10+i*(kScreen_Width-20), 10, kScreen_Width-30, kScreen_Width-20);
            ImageResult *imageResult =articleDetail.images[i];
            NSURL *imageurl=[NSURL URLWithString:imageResult.image_url];
            [imageView sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"pictureholder"]];
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pictureClicked:)];
            imageView.tag=i;
            [imageView addGestureRecognizer:tap];
            
            [self.pictureScrollView addSubview:imageView];
        
        }
        
        
        self.bgView.frame=CGRectMake(20, CGRectGetMaxY(self.pictureScrollView.frame)+10, 100, 20);
        
        self.EVER.frame=CGRectMake(2, 0, 100, 18);
        
        //期刊数
        self.qiNum.text=[NSString stringWithFormat:@"第%ld期",articleDetail.article_id];
        self.qiNum.frame=CGRectMake(CGRectGetMaxX(self.bgView.frame)+5, CGRectGetMinY(self.bgView.frame)+2, 100, 15);
      
        
        //题目
        
        self.titleLabel.text=articleDetail.title;
        self.titleLabel.frame=CGRectMake(20, CGRectGetMaxY(self.bgView.frame)+10, kScreen_Width-20, 20);
        
        self.timeLabel.text=articleDetail.create_time;
        
        self.timeLabel.frame=CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+10, kScreen_Width, 15);
        
        
        //正文
        self.contextLabel.text=articleDetail.content;
        self.contextLabel.font=[UIFont systemFontOfSize:15];
        CGSize contextSize=[self.contextLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        self.contextLabel.numberOfLines=0;
       
        self.contextLabel.frame=(CGRect){{20,CGRectGetMaxY(self.timeLabel.frame)+5},contextSize};
        self.totalScrollView.contentSize=CGSizeMake(kScreen_Width, CGRectGetMaxY(self.contextLabel.frame));
        
    } failure:^(NSError *erronr) {
        
        [self.view endLoading];
        
    }];
}

- (void)pictureClicked:(UIGestureRecognizer*)tap
{
   
    BigImageViewController *bigImage=[[BigImageViewController alloc]init];
    int i=(int)tap.view.tag;
    ImageResult *imageResult=self.imageArray[i];
    bigImage.imageID=imageResult.image_id;
    
    [self.navigationController pushViewController:bigImage animated:YES];
}


//赞
-(void)zanBtnClicked
{

    if ([AccountTool isLogin]) {
        
        NSString *string=[NSString stringWithFormat:@"coffee/zan/%ld",self.articleDetail.article_id];
        
        NSString *urlString=[kSeverPrefix stringByAppendingString:string];
        [HttpTool get:urlString params:nil success:^(id responseobj) {
            
            CLog(@"%@",responseobj);
              ZanResult *result=[ZanResult objectWithKeyValues:responseobj];
            
            [self.zanBtn setImage:(result.zan_status==1)?[UIImage imageNamed:@"coffee_zan_selected"]:[UIImage imageNamed:@"coffee_zan"] forState:UIControlStateNormal];
            
            [MBProgressHUD showError:result.prompt];
            
            
        } failure:^(NSError *erronr) {
           
            
        }];
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }

}

//评论
- (void)commentBtnClicked
{

    ArticleCommentController *articleCommentVC=[[ArticleCommentController alloc]init];
    articleCommentVC.articleID=self.articleID;
    articleCommentVC.delegate=self;
    [self.navigationController pushViewController:articleCommentVC animated:YES];
}

//分享
- (void)shareBtnClicked
{
    ImageResult *imageResult=self.imageArray[0];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageResult.image_url];
    

    
    NSString *string=[NSString stringWithFormat:@"https://bserver.ooo.do/web/mobile/coffee_detail/%ld",self.articleDetail.article_id];
    
    [UMSocialData defaultData].extConfig.qqData.url = string;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = string;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = string;
    [UMSocialData defaultData].extConfig.qzoneData.url = string;
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url=string;
    [UMSocialData defaultData].extConfig.renrenData.urlResource.url=string;
    [UMSocialData defaultData].extConfig.tencentData.urlResource.url=string;
    
    
    NSString *title=[self.articleDetail.title stringByAppendingString:@"Ever App https//:www.ooo.do"];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.qqData.title =title;
    [UMSocialData defaultData].extConfig.qzoneData.title =title;
    [UMSocialData defaultData].extConfig.tencentData.title = title;
    
    
    
    NSString *content=[self.articleDetail.content substringToIndex:30];
    content=[content stringByAppendingString:@"...."];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5545ced367e58ebfc600239e"
                                      shareText:content
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina, UMShareToQQ, UMShareToTencent,UMShareToRenren]
                                       delegate:self];
}

#pragma mark ArticleCommentSuccessDelegate

- (void)articleCommentSuccess {
    
    self.commentNum.text=[NSString stringWithFormat:@"%d",self.articleDetail.comment_num+1];
    
}


@end
