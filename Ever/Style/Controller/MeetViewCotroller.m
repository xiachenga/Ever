//
//  MeetViewCotrollerViewController.m
//  Ever
//
//  Created by Mac on 15-1-30.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "MeetViewCotroller.h"
#import "MeetDetailResult.h"
#import "BigImageViewController.h"
#import "CommentViewController.h"
#import "JubaoViewController.h"
#import "KindItem.h"
#import "ZLSwipeableView.h"
#import "YCXMenu.h"

@interface MeetViewCotroller ()<UMSocialUIDelegate,ZLSwipeableViewDataSource,ZLSwipeableViewDelegate>

@property (nonatomic,weak)UITapImageView *avatarView,*bigImage,*meetyindaoView;

@property (nonatomic , strong)  MeetDetailResult *meetDetail;

@property (nonatomic , weak) UILabel *nickNameLabel,*timeLabel;

@property (nonatomic , assign) int i ,index,meetID;

@property (nonatomic , weak) UIScrollView *scrollView;

@property (nonatomic , weak) ZLSwipeableView *swipView;

@property (nonatomic , strong) NSMutableArray *meetArray,*items;



@end

@implementation MeetViewCotroller

-(NSMutableArray *)meetArray
{
    if (_meetArray==nil) {
        _meetArray=[NSMutableArray array];
    }
    return _meetArray;
}

- (NSMutableArray *)items {
    if (!_items) {
        
        _items = [@[
                    [YCXMenuItem menuItem:LOCALIZATION(@"MeetPersonCenter")
                                    image:[UIImage imageNamed:@"meet_gerenzhuye"]
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:LOCALIZATION(@"MeetShare")
                                    image:[UIImage imageNamed:@"meet_fenxiang"]
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    
                    [YCXMenuItem menuItem:LOCALIZATION(@"MeetReport")
                                    image:[UIImage imageNamed:@"meet_jubao"]
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}],
                    
                    ] mutableCopy];
    }
    return _items;
}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        UITapImageView *avatarView=[[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [view addSubview:avatarView];
        self.avatarView=avatarView;
        [avatarView doCircleFrame];
        self.navigationItem.titleView=view;
}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pointBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(showFoldMenu)];
    
    [self loadData];
    
    [self setupBottomBtn];

}

- (void)loadData
{
    
     NSString *string=[kSeverPrefix stringByAppendingString:@"meet/detail"];
    
    
    [HttpTool get:string params:nil success:^(id responseobj)
     
       {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil)
          {
            
            NSArray *meets=[MeetDetailResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.meetArray addObjectsFromArray:meets];
            

            }
        
            if (self.i==0)
            {
                ZLSwipeableView *swipView=[[ZLSwipeableView alloc]initWithFrame:CGRectMake(20, 84, kScreen_Width-40, kScreen_Width-40+40)];
                [self.view addSubview:swipView];
                swipView.delegate=self;
                swipView.dataSource=self;
                self.swipView=swipView;
            }
            
            
            self.i++;
    
    } failure:^(NSError *erronr) {
        
    }];
    
}

//添加下面的按钮
- (void)setupBottomBtn
{
    
    UIButton *zanBtn=[self buttonWithimage:@"meet_xihuan" action:@selector(zanBtnClicked)];
    if (kDevice_Is_iPhone4) {
        zanBtn.frame=CGRectMake(kScreen_Width*0.25-40, kScreen_Width+60+20+20, 60, 60);
    }else{
        zanBtn.frame=CGRectMake(kScreen_Width*0.25-40, kScreen_Width+60+20+20, 80, 80);
        
    }
    
    
    UIButton *commentBtn=[self buttonWithimage:@"meet_pinglun" action:@selector(commentBtnClicked)];
    if (kDevice_Is_iPhone4) {
         commentBtn.frame=CGRectMake(kScreen_Width*0.5-30, kScreen_Width+60+25+20, 40, 40);
    }else{
         commentBtn.frame=CGRectMake(kScreen_Width*0.5-30, kScreen_Width+60+25+20, 60, 60);
        
    }
    
    UIButton *caiBtn=[self buttonWithimage:@"meet_cai" action:@selector(caiBtnClicked)];
    if (kDevice_Is_iPhone4) {
       caiBtn.frame=CGRectMake(kScreen_Width*0.75-40,kScreen_Width+60+20+20, 60, 60);
    }else{
        caiBtn.frame=CGRectMake(kScreen_Width*0.75-40,kScreen_Width+60+20+20, 80, 80);
    }
}

- (UIButton *)buttonWithimage:(NSString *)image action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
    
}



/**
 *  进入个人主页
 *
 *  @param userid <#userid description#>
 */
- (void)gotoPersonhome:(long)userid
{
    PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
    personhomeVC.user_id=userid;
    [self.navigationController pushViewController:personhomeVC animated:YES];
}


//进入大图
- (void)gotoBigImage:(long)imageID
{
  
    BigImageViewController *bigImageVC=[[BigImageViewController alloc]init];
    bigImageVC.imageID=imageID;
   
    [self.navigationController pushViewController:bigImageVC animated:YES];
}


//点赞meet
- (void)zanBtnClicked
{
    
   [self.swipView swipeTopViewToLeft];
    
    [self beginzan];

}

- (void)beginzan
{
    NSString *string=[NSString stringWithFormat:@"meet/zan/%d",self.meetID];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        if (responseobj!=nil) {
            //    ZanResult *zanResult=[ZanResult objectWithKeyValues:responseobj];
            [MBProgressHUD showzanImage];
            CLog(@"%@",responseobj);
        }
        
        
    } failure:^(NSError *erronr) {
        
        CLog(@"%@",erronr);
        
    }];
    
}



- (void)commentBtnClicked
{
    CLog(@"评论列表");
    
    CommentViewController *commentVC=[[CommentViewController alloc]init];
    KindItem *kindItem=[[KindItem alloc]init];
    kindItem.itemID=self.meetID;
    kindItem.kind=3;
    commentVC.kindItem=kindItem;
    [self.navigationController pushViewController:commentVC animated:YES];
}


- (void)caiBtnClicked
{
    CLog(@"踩meet了");
    
    [self.swipView swipeTopViewToRight];
    [self begincai];
    
   
}

- (void)begincai
{
    NSString *string=[NSString stringWithFormat:@"meet/cai/%d",self.meetID];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
            
         
            
            [MBProgressHUD showcaiImage];
          
            
        }
        
    } failure:^(NSError *erronr) {
        
    }];
    
}


- (void)showFoldMenu
{
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setHasShadow:YES];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        
        if (item.tag==100) {
            
            PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
            personhomeVC.user_id=self.meetDetail.user_id;
            [self.navigationController pushViewController: personhomeVC animated:YES];
            
        }else if(item.tag==101)
        {
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.meetDetail.image.image_url ];
            
            NSString *string=[NSString stringWithFormat:@"https://bserver.ooo.do/web/mobile/meet_detail/%ld",self.meetDetail.meet_id];
            
            [UMSocialData defaultData].extConfig.qqData.url = string;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = string;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = string;
            [UMSocialData defaultData].extConfig.qzoneData.url = string;
            [UMSocialData defaultData].extConfig.sinaData.urlResource.url=string;
            [UMSocialData defaultData].extConfig.tencentData.urlResource.url=string;
            [UMSocialData defaultData].extConfig.renrenData.url=string;
            
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"EVER随机照片";
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"EVER随机照片";
            [UMSocialData defaultData].extConfig.qqData.title =@"EVER随机照片";
            [UMSocialData defaultData].extConfig.qzoneData.title = @"EVER随机照片";
            [UMSocialData defaultData].extConfig.tencentData.title = @"EVER随机照片";
            
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5545ced367e58ebfc600239e"
                                              shareText:@"Ever 给你最高品质的生活体验"
                                             shareImage:nil
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina, UMShareToQQ, UMShareToTencent,]
                                               delegate:self];
        }else{
            JubaoViewController *jubaoVC=[[JubaoViewController alloc]init];
            [self.navigationController pushViewController:jubaoVC animated:YES];
        }
        
    }];

}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    
    NSLog(@"did swipe in direction:------------ %zd", direction);
    
    
    if (direction==1||direction==4) {
        
        CLog(@"向左滑动");
        
        dispatch_queue_t queue = dispatch_queue_create("name", NULL);
        //创建一个子线程
        dispatch_async(queue, ^{
            // 子线程code... ..
           
            
            [self beginzan];
            
            
        });

    }else if(direction==2||direction==8)
    {
        dispatch_queue_t queue = dispatch_queue_create("name", NULL);
        //创建一个子线程
        dispatch_async(queue, ^{
            // 子线程code... ..
            NSLog(@"GCD多线程");
            
            [self begincai];
            
            
        });
}
    
    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
   
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    CLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
 
}


#pragma mark - ZLSwipeableViewDataSource



- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
 
        MeetDetailResult *meetResult=self.meetArray[self.index];
        self.meetID=(int)meetResult.meet_id;
        
        //导航栏上面的头像
    
        if (self.index>=2) {
        
        //解决头像和图片不同步问题
        MeetDetailResult *avatarResult=self.meetArray[self.index-2];
        
        //为了进入个人中心
        self.meetDetail=avatarResult;
        
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarResult.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
        [self.avatarView addTapBlock:^(id obj) {
            [self gotoPersonhome:avatarResult.user_id];
        }];
    }
    
        UIImageView  *bgview=[[ UIImageView  alloc]init];
        bgview.size=CGSizeMake(kScreen_Width-40,kScreen_Width-40+40);
        bgview.image=[UIImage resizedImageWithName:@"paihangbang_beijing"];
    
        //图片
        UITapImageView *view=[[UITapImageView alloc]init];
        [view sd_setImageWithURL:[NSURL URLWithString:meetResult.image.image_url] placeholderImage:[UIImage imageNamed:@"pictureholderYellow"]];
        view.frame=CGRectMake(5, 5, kScreen_Width-50, kScreen_Width-50);
        [view addTapBlock:^(id obj) {
            
            [self gotoBigImage:meetResult.image.image_id];
            
        }];
        [bgview addSubview:view];
        
    
        //昵称
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(view.frame)+10,kScreen_Width-50, 20)];
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.text=meetResult.user_nickname;
        [bgview addSubview:nameLabel];

       //时间
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-120, CGRectGetMinY(nameLabel.frame), 100, 12)];
        timeLabel.text=meetResult.create_time;
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.font=[UIFont systemFontOfSize:12];
        [bgview addSubview:timeLabel];
    
        
    
        if (self.index>self.meetArray.count-5)
        {
            
            [self loadData];
            
        }
        
        self.index++;
        
        return bgview;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    static NSString *key=@"meet_ifFirstOpen";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *meetyindao=[defaults objectForKey:key];
    
    if ([meetyindao isEqualToString:@"1"]) {
        
    }else{
        
        [defaults setObject:[NSString stringWithFormat:@"1"] forKey:key];
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UITapImageView *meetyindaoView=[[UITapImageView alloc]initWithFrame:window.bounds];
        meetyindaoView.image=[UIImage imageNamed:@"meetyindao"];
        self.meetyindaoView=meetyindaoView;
       [meetyindaoView addTapBlock:^(id obj) {
           
           [self meetyindaoViewClicked];
       }];
        [window addSubview:meetyindaoView];
    }
}

- (void)meetyindaoViewClicked{
    
    CLog(@"点击引导层");
    
    [self.meetyindaoView removeFromSuperview];
    
}

@end
