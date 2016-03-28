//
//  TalkDetailViewController.m
//  Ever
//
//  Created by Mac on 15-3-22.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "TalkDetailViewController.h"
#import "ImageResult.h"
#import "BigImageViewController.h"
#import "WorldTagDetailResult.h"
#import "CommentViewController.h"
#import "KindItem.h"
#import "CustomAnimationView.h"
#import "NewStyleViewController.h"
#import "BigSocietyViewController.h"
#import "RootViewController.h"

@interface TalkDetailViewController ()<UIScrollViewDelegate,UMSocialUIDelegate>

@property (nonatomic,weak)UIScrollView *scrollView;

@property (nonatomic , weak) UITapImageView *imageView;

@property (nonatomic , weak) UILabel *usernameLabel,*titleLabel,*timeLabel,*contextLabel;
//水平滑动的ScrollView
@property (nonatomic , weak) UIScrollView *horiScrollView ;

@property (nonatomic , strong) WorldTagDetailResult *worldTagDetail;

@property (nonatomic , weak) UIButton *zanBtn;

@end

@implementation TalkDetailViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        
        //设置导航栏上面的头像
        
        UIView *view=[[UIView alloc]init];
        view.size=CGSizeMake(40, 40);
        [self.view addSubview:view];
        
        //头像
        UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [imageView doCircleFrame];
        self.imageView=imageView;
        
        [imageView addTapBlock:^(id obj) {
            [self imageClicked];
        }];
        [view addSubview:imageView];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
}
    return self;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //添加ScrollView
    [self addScrollView];

    //添加下面的toolBar
    
}

- (void)addScrollView

{
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    self.scrollView=scrollView;
    scrollView.delegate=self;
    scrollView.frame=self.view.bounds;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    
    //添加title
    UILabel *titleLabel=[[UILabel alloc]init];
    [scrollView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    
    UILabel *timeLabel=[[UILabel alloc]init];
    self.timeLabel=timeLabel;
    [scrollView addSubview:timeLabel];
    
    
    //文字
    UILabel *contextLabel=[[UILabel alloc]init];
    self.contextLabel=contextLabel;
    contextLabel.numberOfLines=0;
    [scrollView addSubview:contextLabel];
    
    //左右的scrollview
    UIScrollView *horiScrollView=[[UIScrollView alloc]init];
    self.horiScrollView=horiScrollView;
  //  horiScrollView.pagingEnabled=YES;
    horiScrollView.hidden=YES;
    horiScrollView.bounces=NO;
    horiScrollView.showsHorizontalScrollIndicator=NO;
    horiScrollView.showsVerticalScrollIndicator=NO;
    [scrollView addSubview:horiScrollView];
    
}


-(void)setTalkid:(long)talkid
{
    _talkid=talkid;
    [self loadWorldDetailData];

}

//加载数据
-(void)loadWorldDetailData
{

    [self.view beginLoading];
    NSString *urlString,*string;
    
    if (self.type==1) {
        
        string=[NSString stringWithFormat:@"world/detail_by_tagid/%ld",self.talkid];
    }else{
        
        string=[NSString stringWithFormat:@"world/detail_by_cid/3/%ld",self.talkid];
        
    }
    
    urlString=[kSeverPrefix stringByAppendingString:string];
    
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
   
        CLog(@"%@",responseobj);
        
        [self.view endLoading];
        
        if (responseobj!=nil) {
            
        
            WorldTagDetailResult *worldTagDetail=[WorldTagDetailResult objectWithKeyValues:responseobj];
            
            //判断是否被删除
            if (worldTagDetail.cid==-1) {
                
                [MBProgressHUD showError:@"此条已经删除"];
                
                RootViewController  *controller=(RootViewController *)[self.navigationController.viewControllers objectAtIndex:0];
                
                NSArray *childControllers= controller.childViewControllers;
                
                UIViewController *childController=childControllers[0];
                
                if ([childController isKindOfClass:[NewStyleViewController class]]) {
                    
                    NewStyleViewController *newStyleVC=childControllers[0];
                    
                    [newStyleVC gediaoDeleteRefrsh];
                    
                }else if([childController isKindOfClass:[BigSocietyViewController class]]){
                    
                    BigSocietyViewController *bigSocietyVC=childControllers[0];
                    [bigSocietyVC gediaoDeleteRefrsh];
                    
                    
                }
                
                
                [self.navigationController popToViewController:controller animated:YES];
                
                
            }else{
                self.worldTagDetail=worldTagDetail;
                
                //设置题目和头像
                [self setupDetailInfo];
                
                //添加文字和图片
                [self addContentOnScrollView];
                
                //添加下面的view
                [self addBottomView];
                
            }
            
           
            
        }
        
    } failure:^(NSError *erronr) {
        
        [self.view endLoading];
        CLog(@"%@",erronr);
        
    }];
    
}

//设置详细信息
- (void)setupDetailInfo
{
    //标题
    self.title=self.worldTagDetail.journal.user_nickname;
    
    NSURL *urlString=[NSURL URLWithString:self.worldTagDetail.journal. user_head_image_url];
    [self.imageView sd_setImageWithURL:urlString placeholderImage:[UIImage imageNamed:@"avatarholder"]];
}

//添加文字和图片
- (void)addContentOnScrollView
{
    
    //添加title
    self.titleLabel.numberOfLines=0;
    self.titleLabel.text=self.worldTagDetail.journal.title_text_content;
    self.titleLabel.font=[UIFont systemFontOfSize:18];
    CGSize titleLabelSize=[self.titleLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    
    self.titleLabel.frame=CGRectMake(10, 20, kScreen_Width-20, titleLabelSize.height);
    
    
    //添加下面的时间
    self.timeLabel.text=self.worldTagDetail.journal.create_time;
    
    CGSize timeLabelSize=[self.timeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    self.timeLabel.font=[UIFont systemFontOfSize:13];
    self.timeLabel.textColor=[UIColor grayColor];
    
    self.timeLabel.frame=CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame)+5, timeLabelSize.width, 13);
    
    //文章内容
    self.contextLabel.text=self.worldTagDetail.journal.text_content;
    
    self.contextLabel.font=[UIFont systemFontOfSize:14];
    CGSize contextLabelSize=[self.contextLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size ;
    
    //如果有插图添加UIimageView
    if (self.worldTagDetail.journal.if_has_image) {
        
        self.horiScrollView.hidden=NO;
        
        self.horiScrollView.frame=CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame)+5, kScreen_Width, kScreen_Width-20);
        
        long count=self.worldTagDetail.journal.images.count;
        
        if (count>1) {
            
            self.horiScrollView.contentSize=CGSizeMake((kScreen_Width-20)*count+10, 0) ;
        }else{
            
            self.horiScrollView.contentSize=CGSizeMake(kScreen_Width*count, kScreen_Width-20);
        }
        
      //  self.horiScrollView.contentSize=CGSizeMake(kScreen_Width*count, kScreen_Width-20);
    
        for (int i=0; i<count; i++)
        {
            
            UITapImageView *imageview=[[UITapImageView alloc]init];
            
            if (count>1) {
                imageview.frame=CGRectMake(10+i*(kScreen_Width-20), 0, kScreen_Width-30, kScreen_Width-20);
            }else{
                
                imageview.frame=CGRectMake(10+i*kScreen_Width, 0, kScreen_Width-20, kScreen_Width-20);
            }
            
            
            ImageResult *imageResult=self.worldTagDetail.journal.images[i];
            NSURL *url=[NSURL URLWithString:imageResult.image_url];
            [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pictureholder"]];
            
            [imageview addTapBlock:^(id obj) {
                
                [self gotoBigImage:imageResult.image_id];
                
                
            }];
            
            
            
            //添加标签
            for (int j=0; j<imageResult.labels.count; j++) {
                
                LabelResult *labelResult=imageResult.labels[j];
                CustomAnimationView *animationView=[[CustomAnimationView alloc ]init];
                animationView.label=labelResult;
                [imageview addSubview:animationView];
            }
            
            
            [self.horiScrollView addSubview:imageview];
            
            
        }
        
        
        self.contextLabel.frame=CGRectMake(10, CGRectGetMaxY(self.horiScrollView.frame)+5, kScreen_Width-20, contextLabelSize.height);
        
        
    }else
    {
        
        self.horiScrollView.hidden=YES;
        
        self.contextLabel.frame=CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame)+4, kScreen_Width-20, contextLabelSize.height);
    }
    self.scrollView.contentSize=CGSizeMake(kScreen_Width, CGRectGetMaxY(self.contextLabel.frame)+34);
    
}

//下面的工具条
- (void)addBottomView
{
    UIView *toolBar=[[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-40, kScreen_Width, 40)];
    toolBar.backgroundColor=[UIColor blackColor];
    toolBar.alpha=0.9;
    [self.view addSubview:toolBar];
    
    //赞
    UIButton *zanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:self.worldTagDetail.journal.if_dianzan?[UIImage imageNamed:@"coffee_zan_selected"]:[UIImage imageNamed:@"coffee_zan"] forState:UIControlStateNormal];
    self.zanBtn=zanBtn;
    zanBtn.frame=CGRectMake(0, kScreen_Height-40, kScreen_Width*0.33, 40);
    [zanBtn addTarget:self action:@selector(zanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zanBtn];
    
    //评论
    
    UIButton *commentBtn=[self buttonWithimage:@"coffee_pinglun"  action:@selector(commentBtnClicked)];
    commentBtn.frame=CGRectMake(kScreen_Width*0.33, kScreen_Height-40, kScreen_Width*0.33, 40);
    [self.view addSubview:commentBtn];
    
    //分享
    UIButton *shareBtn=[self buttonWithimage:@"meet_fenxiang" action:@selector(shareBtnClicked)];
    shareBtn.frame=CGRectMake(kScreen_Width*0.33*2, kScreen_Height-40, kScreen_Width*0.33, 40);
    [self.view addSubview:shareBtn];
    
}

-(UIButton *)buttonWithimage:(NSString *)image action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image ] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//点击头像
- (void)imageClicked
{
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=self.worldTagDetail.journal.user_id;
    [self.navigationController pushViewController:personhomeVC animated:YES];
}

/**
 *  点击出现大图
 */

- (void)gotoBigImage:(long )imageID
{
    BigImageViewController *bigImageVC=[[BigImageViewController alloc]init];
    bigImageVC.imageID=imageID;
    [self.navigationController pushViewController:bigImageVC animated:YES];

}

- (void)zanBtnClicked
{
    CLog(@"点赞");
    
    
    if ([AccountTool isLogin]) {
        
        NSString *string=[NSString stringWithFormat:@"journal/zan/%ld",self.worldTagDetail.journal.journal_id];
        NSString *urlString=[kSeverPrefix stringByAppendingString:string];
        
        [HttpTool get:urlString params:nil success:^(id responseobj) {
            
            ZanResult *zanResult=[ZanResult objectWithKeyValues:responseobj];
            if (zanResult.zan_status==1) {
                [self.zanBtn setImage:[UIImage imageNamed:@"coffee_zan_selected"] forState:UIControlStateNormal];
            }else{
                [self.zanBtn setImage:[UIImage imageNamed:@"coffee_zan"] forState:UIControlStateNormal];
            }
            [MBProgressHUD showError:zanResult.prompt];
            
            
        } failure:^(NSError *erronr) {
            
        }];
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
   
    
}

- (void)commentBtnClicked
{
    if ([AccountTool isLogin]) {
        CommentViewController *commentVC=[[CommentViewController alloc]init];
        KindItem *kindItem=[[KindItem alloc]init];
        kindItem.itemID=self.worldTagDetail.journal.journal_id;
        kindItem.kind=2;
        kindItem.if_can_comment=self.worldTagDetail.if_can_comment;
        commentVC.kindItem=kindItem;
        [self.navigationController pushViewController:commentVC animated:YES];
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
    
    
}
- (void)shareBtnClicked
{
    NSString *imageUrl;
    
    if (self.worldTagDetail.journal.images.count>0) {
        ImageResult *imageResult=self.worldTagDetail.journal.images[0];
        imageUrl=imageResult.image_url;
    }else{
        imageUrl=@"http://ooo.do/logo96.png";
    }
    
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    
    NSString *string=[NSString stringWithFormat:@"https://bserver.ooo.do/web/mobile/journal_detail/%ld",self.worldTagDetail.journal.journal_id];
    
    [UMSocialData defaultData].extConfig.qqData.url = string;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = string;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = string;
    [UMSocialData defaultData].extConfig.qzoneData.url = string;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url=string;
    [UMSocialData defaultData].extConfig.tencentData.urlResource.url=string;
    [UMSocialData defaultData].extConfig.renrenData.urlResource.url=string;
    
    NSString *title=[self.worldTagDetail.journal.title_text_content stringByAppendingString:@"Ever App https:www.ooo.do"];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.qqData.title =title;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.tencentData.title = title;
    
    
    
    
    NSString *textContent=[self.worldTagDetail.journal.text_content substringToIndex:30];
    textContent=[textContent  stringByAppendingString:@"...."];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5545ced367e58ebfc600239e"
                                      shareText:textContent
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina, UMShareToQQ, UMShareToTencent,UMShareToRenren]
                                       delegate:self];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AFSoundManager sharedManager]pause];
}

@end
