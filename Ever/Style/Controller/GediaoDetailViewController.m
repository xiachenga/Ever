//
//  GediaoDetailViewController.m
//  Ever
//
//  Created by Mac on 15-3-18.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#define kCCellIdentifier_LikeUser @"TweetLikeUserCCell"
#define kGediaoDetailCell_LikeUserCCell_Pading 10.0

#import "GediaoDetailViewController.h"
#import "BigImageViewController.h"
#import "JubaoViewController.h"
#import "WorldTagDetailResult.h"
#import "CommentViewController.h"
#import "GediaoSegmentController.h"
#import "LikeUserCell.h"
#import "HeadimageResult.h"
#import "KindItem.h"
#import "CustomAnimationView.h"
#import "NewStyleViewController.h"
#import "MyStyleViewController.h"
#import "RootViewController.h"
#import "BigSocietyViewController.h"

@interface GediaoDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UMSocialUIDelegate>

//大图显示
@property(nonatomic,weak)UITapImageView *bigImageView, *userAvatarView, *leftView;

//用户昵称,时间
@property (nonatomic , weak) UILabel *nickNameLabel,*timeLabel,*zanNumLabel;

@property (nonatomic , strong) WorldTagDetailResult *worldDetail;

//赞的头像
@property (nonatomic , weak) UICollectionView *likeUserView;

@property (nonatomic , weak)  UIButton *zanButton,*commentButton ;

@property (nonatomic , strong) NSMutableArray *headImageArray,*items;

@property (nonatomic , weak) UIScrollView *scrollView;

@end

@implementation GediaoDetailViewController


-(NSMutableArray *)headImageArray
{
    if (!_headImageArray) {
        _headImageArray=[NSMutableArray array];
    }
    return _headImageArray;
}

- (NSMutableArray *)items {
    if (!_items) {
        
            _items = [@[
                        
                     [YCXMenuItem menuItem:LOCALIZATION(@"GeDiaoPersonCenter")
                                     image:[UIImage imageNamed:@"meet_gerenzhuye"]
                                       tag:100
                                  userInfo:@{@"title":@"Menu"}],
                     [YCXMenuItem menuItem:LOCALIZATION(@"GeDiaoShare")
                                     image:[UIImage imageNamed:@"meet_fenxiang"]
                                       tag:101
                                  userInfo:@{@"title":@"Menu"}],
                     
                     [YCXMenuItem menuItem:LOCALIZATION(@"GeDiaoReport")
                                     image:[UIImage imageNamed:@"meet_jubao"]
                                       tag:102
                                  userInfo:@{@"title":@"Menu"}],
                     
                     ] mutableCopy];
    }
    return _items;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        
        //全局的scrollview
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
        scrollView.bounces=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        self.scrollView=scrollView;
        [self.view addSubview:scrollView];
        
        
        //大图显示
        UITapImageView *bigImageView=[[UITapImageView alloc]init];
        self.bigImageView=bigImageView;
        [scrollView addSubview:bigImageView];
        
        //显示点赞的个数
        UITapImageView *leftView=[[UITapImageView alloc]init];
        [leftView setBackgroundColor:kThemeColor];
        self.leftView=leftView;
        [scrollView addSubview:leftView];
        
        
        UILabel *zanNumLabel=[[UILabel alloc]init];
        zanNumLabel.font=[UIFont systemFontOfSize:25];
        zanNumLabel.textColor=[UIColor whiteColor];
        zanNumLabel.textAlignment=NSTextAlignmentCenter;
        [leftView addSubview:zanNumLabel];
        self.zanNumLabel=zanNumLabel;
        
       
       //设置昵称
        UILabel *nickNamelabel=[[UILabel alloc]init];
        self.nickNameLabel=nickNamelabel;
        [scrollView addSubview:nickNamelabel];
        
        
        //设置时间
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.font=[UIFont systemFontOfSize:15];
        self.timeLabel=timeLabel;
        [scrollView addSubview:timeLabel];
        
        //设置导航栏上面的头像
        
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, 40, 40);
        view.userInteractionEnabled=YES;
        self.navigationItem.titleView=view;
        
        UITapImageView *userAvatarView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.userAvatarView=userAvatarView;
        [userAvatarView doCircleFrame];
        [view addSubview:userAvatarView];
    
        //点赞头像
        if (!self.likeUserView) {
             UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
             UICollectionView *likeUserView=[[UICollectionView alloc]initWithFrame:CGRectMake(50, kScreen_Width, kScreen_Width, 50) collectionViewLayout:layout];
              self.likeUserView=likeUserView;
            likeUserView.scrollEnabled=NO;
            likeUserView.delegate=self;
            likeUserView.dataSource=self;
            likeUserView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
            [scrollView addSubview:likeUserView];
            [likeUserView registerClass:[LikeUserCell class]     forCellWithReuseIdentifier:kCCellIdentifier_LikeUser];
            
          }
       }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏右边的按钮
    [self addNavigationItem];
    
}

//添加导航栏右边的按钮
-(void)addNavigationItem
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pointBtn_Nav"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
}

- (void)setGediaoid:(long)gediaoid
{
    _gediaoid=gediaoid;
    
    [self loadWorldIndexData];
}

/**
 *  加载格调详情
 */
- (void)loadWorldIndexData
{
    [self.view beginLoading];
    
    NSString *string,*urlString;
    if (self.gediaoType==1) {
        
      string =[NSString stringWithFormat:@"world/detail_by_tagid/%ld",self.gediaoid];
    }else{
        
      string=[NSString stringWithFormat:@"world/detail_by_cid/5/%ld",self.gediaoid];
    }
    
    urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
    
        CLog(@"%@",responseobj);
        
        [self.view endLoading];
        
        if (responseobj!=nil) {
            //字典转化为模型
            WorldTagDetailResult *worldDetail=[WorldTagDetailResult objectWithKeyValues:responseobj];
            
            //判断是否被删除
            if (worldDetail.cid==-1||worldDetail.gediao.gediao.gediao_id==-1) {
                
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
                
              //  [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }else {
            
             [self.headImageArray addObjectsFromArray:worldDetail.gediao.headimages];
            
             self.worldDetail=worldDetail;
            
            //点赞头像
            [self.likeUserView reloadData];
            
            //设置格调详情
            [self setupStyleInfo];
                
            }
            
        }
        
        [self addZanAndCommentButton];
        
       
    } failure:^(NSError *erronr) {
        
        [self.view endLoading];
        
        
    }];
    
}

//设置格调的信息
- (void)setupStyleInfo
{
    //头像
    NSURL *avatarUrl=[NSURL URLWithString:self.worldDetail.gediao.gediao.user_head_image_url];
    //匿名
    if (self.worldDetail.if_anonymity) {
        self.userAvatarView.image=[UIImage imageNamed:@"touxiang_niming"];
    }else{
        
        [self.userAvatarView sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    }
    
    [self.userAvatarView addTapBlock:^(id obj) {
        
        [self avatarViewClicked];
    }];
    
    //设置大图
    self.bigImageView.frame=CGRectMake(0, 0, kScreen_Width, kScreen_Width);
    
    [self.bigImageView addTapBlock:^(id obj) {
        [self bigImageViewClicked];
    }];
    
    
   if (self.worldDetail.gediao.gediao.image.image_url!=nil && ![self.worldDetail.gediao.gediao.image.image_url isEqualToString:@""]) {
    
         NSURL *imageUrl=[NSURL URLWithString:self.worldDetail.gediao.gediao.image.image_url];
        [self.bigImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"pictureholder"]];
     
    }
    

    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bigImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    [self.leftView addTapBlock:^(id obj) {
        
        [self gotoGediaoZanAndComment:typeZan];
    
    }];
    
    self.zanNumLabel.frame=CGRectMake(0, 0, 50, 40);

    self.zanNumLabel.text=@"...";
    
    [self.likeUserView addLineUp:YES andDown:YES];


//    //昵称和说的话
//    
    NSString *keywords;
    if ([self.worldDetail.gediao.gediao.name isEqual:@""]) {
        keywords=@"暂无文字...";
    }else{
        keywords=self.worldDetail.gediao.gediao.name;
    }
    
    NSMutableAttributedString *string;
   
    if (self.worldDetail.if_anonymity) {
        
         string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"#匿名#:%@",keywords]];
    }else{
     string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"#%@#:%@",self.worldDetail.gediao.gediao.user_nickname,keywords]];
    }
    
    NSRange range=NSMakeRange(0, [[string string]rangeOfString:@":"].location+1);
    [string addAttributes:@{NSForegroundColorAttributeName:kThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:20]} range:range];
    [self.nickNameLabel setAttributedText:string];
   
   
    CGSize nickNamelabelSize=[self.nickNameLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.nickNameLabel.numberOfLines=0;
    self.nickNameLabel.frame=(CGRect){{5, CGRectGetMaxY(self.likeUserView.frame)+10},nickNamelabelSize};
    
    //临时先做一个空的label使关键字有点击事件
   
    if (!self.worldDetail.if_anonymity) {
        
        UIButton *tapBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        tapBtn.frame=CGRectMake(5, CGRectGetMinY(self.nickNameLabel.frame),(self.worldDetail.gediao.gediao.user_nickname.length+2)*20, 20);
        [tapBtn addTarget:self action:@selector(gotouserHome) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:tapBtn];
        
    }
    
    //时间
    self.timeLabel.text=self.worldDetail.gediao.gediao.create_time;
    CGSize timeLabelSize=[self.timeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.timeLabel.frame=CGRectMake(kScreen_Width-10 -timeLabelSize.width , CGRectGetMaxY(self.nickNameLabel.frame), timeLabelSize.width, 15);

    self.scrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.timeLabel.frame)+60);
    
    //添加标签
     NSArray *labelsArray=self.worldDetail.gediao.gediao.image.labels;
    [self addLabels:labelsArray];
    
     
    

}

//添加标签

-(void)addLabels:(NSArray *)labelsArray
{
   
    for (int i=0; i<labelsArray.count; i++) {
        
        LabelResult *labelResult=labelsArray[i];
        CustomAnimationView *animationView=[[CustomAnimationView alloc ]init];
        animationView.label=labelResult;
        [self.bigImageView addSubview:animationView];
        
    }

}

//赞和评论的按钮
 - (void)addZanAndCommentButton
{
    //背景
    UIView *bottomBgView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-40, kScreen_Width, 40)];
    bottomBgView.backgroundColor=[UIColor blackColor];
    bottomBgView.alpha=0.9;
    [self.view addSubview:bottomBgView];
    
    //赞的按钮
    UIButton *zanButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [zanButton setImage:self.worldDetail.gediao.gediao.if_dianzan?[UIImage imageNamed:@"coffee_zan_selected"]:[UIImage imageNamed:@"coffee_zan"] forState:UIControlStateNormal];
    zanButton.frame=CGRectMake(0,kScreen_Height-40, kScreen_Width*0.5, 40);
    [zanButton addTarget:self action:@selector(zanButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zanButton];
    self.zanButton=zanButton;
    
    
    //评论按钮
    UIButton *commentButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setImage:[UIImage imageNamed:@"coffee_pinglun"] forState:UIControlStateNormal];
    commentButton.frame=CGRectMake(kScreen_Width*0.5,kScreen_Height-40  ,kScreen_Width*0.5,40);
    [commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentButton];
    
    //中间的线
    
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-1, kScreen_Height-40, 1, 40)];
    lineView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lineView];
   
}

/**
 *  点击导航栏右边的按钮
 */
- (void)rightBarButtonItemClicked
{
    
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setHasShadow:YES];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        
        if (item.tag==100) {
            
            if (self.worldDetail.if_anonymity) {
                
                [MBProgressHUD showError:@"不能查看用户主页"];
                
            }else{
                
                PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
                personhomeVC.user_id=self.worldDetail.gediao.gediao.user_id;
                [self.navigationController pushViewController:personhomeVC animated:YES];
                
            }
            
           
            
        }else if(item.tag==101)
        {
            
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.worldDetail.gediao.gediao.image.image_url];
            
            NSString *string=[NSString stringWithFormat:@"https://bserver.ooo.do/web/mobile/gediao_detail/%ld",self.worldDetail.gediao.gediao.gediao_id];
            
            [UMSocialData defaultData].extConfig.qqData.url = string;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = string;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = string;
            [UMSocialData defaultData].extConfig.qzoneData.url = string;
            [UMSocialData defaultData].extConfig.sinaData.urlResource.url=string;
            [UMSocialData defaultData].extConfig.tencentData.urlResource.url=string;
            [UMSocialData defaultData].extConfig.renrenData.url=string;
            
            
            NSString *title=@"EVER是一种生活格调 Ever App https://www.ooo.do";
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [UMSocialData defaultData].extConfig.qqData.title =title;
            [UMSocialData defaultData].extConfig.qzoneData.title = title;
            [UMSocialData defaultData].extConfig.tencentData.title = title;
            
    
             [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5545ced367e58ebfc600239e"
                                              shareText:@"Ever 给你最高品质的生活体验"
                                             shareImage:nil
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina, UMShareToQQ, UMShareToTencent,UMShareToRenren]
                                               delegate:self];
        }else{
            JubaoViewController *jubaoVC=[[JubaoViewController alloc]init];
            [self.navigationController pushViewController:jubaoVC animated:YES];
        }
    
    }];
    
}


/**
 *  点赞
 */
- (void)zanButtonClicked
{
   
    
    if ([AccountTool isLogin]) {
        
        LoginResult *account=[AccountTool account];
        NSPredicate *finalPredicate=[NSPredicate predicateWithFormat:@"user_id==%ld",account.user_id];
        NSString *string=[NSString stringWithFormat:@"gediao/zan/%ld",self.worldDetail.gediao.gediao.gediao_id];
        NSString *urlString=[kSeverPrefix stringByAppendingString:string];
        
        [HttpTool get:urlString params:nil success:^(id responseobj) {
            
            CLog(@"%@",responseobj);
            
            ZanResult *zanResult=[ZanResult objectWithKeyValues:responseobj];
    
            if (zanResult.zan_status==1) {
                
                [MBProgressHUD showError:@"点赞成功"];
                [self.zanButton setImage:[UIImage imageNamed:@"coffee_zan_selected"] forState:UIControlStateNormal];
            
            }else{
                [MBProgressHUD showError:@"取消点赞"];
                [self.zanButton setImage:[UIImage imageNamed:@"coffee_zan"] forState:UIControlStateNormal];
            }
            HeadimageResult *headImage=[[HeadimageResult alloc]init];
            if (zanResult.zan_status==1) {
                
                headImage.user_head_image_url=account.user_head_image_url;
                headImage.user_id=account.user_id;
                [self.headImageArray insertObject:headImage atIndex:0];
                [self.likeUserView reloadData];
            }else{
                
                NSArray *fliterArray=[self.headImageArray filteredArrayUsingPredicate:finalPredicate];
                [self.headImageArray removeObjectsInArray:fliterArray];
                
                [self.likeUserView reloadData];
                
            }
            
            
        } failure:^(NSError *erronr) {
            
            CLog(@"%@",erronr);
            
        }];
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }

}

//评论
- (void)commentButtonClicked
{
    
  [self gotoGediaoZanAndComment:TypeComment];
    
}

- (void)avatarViewClicked
{
    if (self.worldDetail.if_anonymity) {
        [MBProgressHUD showError:@"不能查看用户主页"] ;
    }else{
        
    [self gotoUserInfo:self.worldDetail.gediao.gediao.user_id];
    }
}


-(void)bigImageViewClicked

{
    BigImageViewController *bigImageVC=[[BigImageViewController alloc]init];
    
    bigImageVC.imageID=self.worldDetail.gediao.gediao.image.image_id;
    
    [self.navigationController pushViewController:bigImageVC animated:YES];
}


#pragma mark collection
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    
    return self.headImageArray.count;
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LikeUserCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_LikeUser forIndexPath:indexPath];
    
    HeadimageResult *header=self.headImageArray[indexPath.row];
    
    cell.headResult=header;
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize;
    itemSize = CGSizeMake(40, 40);
    return itemSize;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insetForSection;
    
    insetForSection = UIEdgeInsetsMake(7,5, 7, 5);
    return insetForSection;
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kGediaoDetailCell_LikeUserCCell_Pading/2;
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kGediaoDetailCell_LikeUserCCell_Pading;
}

- (void)gotoGediaoZanAndComment:(Type)type
{
    GediaoSegmentController *gediaoSegmentVC=[[GediaoSegmentController alloc]init];
    KindItem *kindItem=[[KindItem alloc]init];
    kindItem.itemID=self.worldDetail.gediao.gediao.gediao_id;
    //1是格调评论
    kindItem.kind =1;
    kindItem.if_can_comment=self.worldDetail.if_can_comment;
    gediaoSegmentVC.kindItem=kindItem;
    gediaoSegmentVC.type=type;
    [self.navigationController pushViewController:gediaoSegmentVC animated:YES];
}


//个人主页
- (void)gotoUserInfo:(long)userid
{
    PersonhomeViewController *personVC=[[PersonhomeViewController alloc]init];
    personVC.user_id=userid;
    [self.navigationController pushViewController:personVC animated:YES];
}

//点击关键字进入个人主页
- (void)gotouserHome
{
    PersonhomeViewController *personVC=[[PersonhomeViewController alloc]init];
    personVC.user_id=self.worldDetail.gediao.gediao.user_id;
    [self.navigationController pushViewController:personVC animated:YES];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HeadimageResult *header=self.headImageArray[indexPath.row];
    [self gotoUserInfo:header.user_id];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    
    [[AFSoundManager sharedManager]pause];
    
}

@end
