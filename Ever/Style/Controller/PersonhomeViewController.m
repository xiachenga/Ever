//
//  PersonhomeViewController.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


static CGFloat ImageHeight  = 300;

#import "LifeRoadViewController.h"
#import "HisHomeResult.h"
#import "ImageResult.h"
#import "BigImageViewController.h"
#import "GuanzhuResult.h"
#import "ChatViewController.h"
#import <RCIM.h>
@interface PersonhomeViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) HisHomeResult *hisHomeResult;
@property (nonatomic , strong) GuanzhuResult *guanzhuResult;

@property (nonatomic , weak)  UILabel *nickNameLabel,*meiliLabel;


@property (nonatomic , weak)  UIImageView *sexSymbol,*avatarView,*backgroundView;


@property (nonatomic , weak) UILabel *city,*cityLabel,*word ,*workLabel,*everAccount,*ever;


@property (nonatomic , weak)  UIScrollView *scrollView,*figureScroll ;

@property (nonatomic , weak) UIButton *guanzhu,*zanBtn;

@property (nonatomic , copy) NSString *token;
@end

@implementation PersonhomeViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor=[UIColor whiteColor];
        self.title=LOCALIZATION(@"PersonDetailInfo");
        
        
        //背景
        UIImageView *backgroundView=[[UIImageView alloc]init];
        backgroundView.image=[UIImage imageNamed:@"personDetailData"];
        backgroundView.frame=CGRectMake(0, 0, kScreen_Width, 300);
        self.backgroundView=backgroundView;
        [self.view addSubview:backgroundView];
        
        
        
        //添加uiscrollview
        UIScrollView *scrollView=[[UIScrollView alloc]init];
        self.scrollView=scrollView;
        scrollView.frame=self.view.bounds;
        scrollView.delegate=self;
        scrollView.showsVerticalScrollIndicator=NO;
      //  scrollView.contentSize=CGSizeMake(0, kScreen_Height+200);
        [self.view addSubview:scrollView];
        
        
        [self addBottomView];
        
        
        
        //头像
        
        UIImageView *avatarView=[[UIImageView alloc]init];
        [avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:40];
        self.avatarView=avatarView ;
        [self.scrollView addSubview:avatarView];
        
        
        
        //昵称
        UILabel *nickNameLabel=[[UILabel alloc]init];
        self.nickNameLabel=nickNameLabel;
        nickNameLabel.font=[UIFont systemFontOfSize:18];
        [self.scrollView addSubview:nickNameLabel];
       
        //性别
        
        UIImageView *sexSymbol=[[UIImageView alloc]init];
        [self.scrollView addSubview:sexSymbol];
        self.sexSymbol=sexSymbol;
        
        
        //魅力值
        
        UILabel *meiliLabel=[[UILabel alloc]init];
        self.meiliLabel=meiliLabel;
        meiliLabel.font=[UIFont systemFontOfSize:15];
        meiliLabel.textColor=[UIColor whiteColor];
        
       [self.scrollView addSubview:meiliLabel];
        
        
        
        //形象
        UIView *figureView=[[UIView alloc]initWithFrame:CGRectMake(0, 300, kScreen_Width, 40)];
        figureView.backgroundColor=kThemeColor;
        [self.scrollView addSubview:figureView];
        
        UILabel *figure=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 20)];
        [figureView addSubview:figure];
        figure.text=LOCALIZATION(@"PersonDetailFigure");
        
        
        //资料
        UIView *dataView=[[UIView alloc]initWithFrame:CGRectMake(0, 420, kScreen_Width, 40)];
        dataView.backgroundColor=kThemeColor;
        [self.scrollView addSubview:dataView];
        
        UILabel *data=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 20)];
        [dataView addSubview:data];
        data.text=LOCALIZATION(@"PersonDetailData");
        
        //ever值
        UILabel *ever=[[UILabel alloc]init];
        ever.font=[UIFont systemFontOfSize:15];
       
        [self.scrollView addSubview:ever];
        self.ever=ever;
        
        UILabel *everAccount=[[UILabel alloc]init];
        everAccount.font=[UIFont systemFontOfSize:15];
        [self.scrollView addSubview:everAccount];
        everAccount.textColor=[UIColor grayColor];
        self.everAccount=everAccount;
        
        
        //城市
        UILabel *cityLabel=[[UILabel alloc]init];
        cityLabel.font=[UIFont systemFontOfSize:15];
        [self.scrollView addSubview:cityLabel];
        self.cityLabel=cityLabel;

       
        UILabel *city=[[UILabel alloc]init];
        city.font=[UIFont systemFontOfSize:15];
        city.textColor=[UIColor grayColor];
        [self.scrollView addSubview:city];
        self.city=city;
        
        
        UILabel *wordLabel=[[UILabel alloc]init];
        wordLabel.font=[UIFont systemFontOfSize:15];
        [self.scrollView addSubview:wordLabel];
        self.workLabel=wordLabel;
        
        
        UILabel *word=[[UILabel alloc]init];
        word.textColor=[UIColor grayColor];
        word.font=[UIFont systemFontOfSize:15];
        [self.scrollView addSubview:word];
        self.word=word;
        
    }
    
    return self;
    
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    UIButton *zanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:[UIImage imageNamed:@"gerendang_shou"] forState:UIControlStateNormal];
    self.zanBtn=zanBtn;
    zanBtn.size=CGSizeMake(24, 24);
    [zanBtn addTarget:self action:@selector(zanClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:zanBtn];
    
    

}

- (void)setUser_id:(long)user_id
{
    _user_id=user_id;
    
    NSString *string=[NSString stringWithFormat:@"user/home/%ld",self.user_id];
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        
        CLog(@"%@",responseobj);
        
        HisHomeResult *hisHomeResult=[HisHomeResult objectWithKeyValues:responseobj];
        self.hisHomeResult=hisHomeResult;
        
        
        
        [self setupPersonhomeInfo];
        
    } failure:^(NSError *erronr) {
        
        CLog(@"%@",erronr);
        
    }];
    
}


- (void)setupPersonhomeInfo
{
    LoginResult *account=[AccountTool account];
    
    
    //头像
    
    self.avatarView.frame=CGRectMake(kScreen_Width*0.5-40, 84, 80, 80);
    NSURL *imageUrl=[NSURL URLWithString:self.hisHomeResult.user_head_image_url];
    [self.avatarView sd_setImageWithURL:imageUrl  placeholderImage:[UIImage imageNamed:@"avatarholder"]];
   
    
    //昵称
    
    self.nickNameLabel.text=self.hisHomeResult.user_nickname;
    self.nickNameLabel.textColor=[UIColor whiteColor];
    CGSize nickNamelabelSize=[self.nickNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    
    self.nickNameLabel.frame=(CGRect){{(kScreen_Width-nickNamelabelSize.width)*0.5, CGRectGetMaxY(self.avatarView.frame)+5},nickNamelabelSize};
    
    //男女符号
    self.sexSymbol.frame=CGRectMake(CGRectGetMaxX(self.nickNameLabel.frame)+2, CGRectGetMinY(self.nickNameLabel.frame)+2, 18, 18);
    if ([self.hisHomeResult.sex isEqualToString:@"Woman"]) {
        
        self.sexSymbol.image=[UIImage imageNamed:@"ziliao_nv"];
        
    }else
    {
        self.sexSymbol.image=[UIImage imageNamed:@"ziliao_nan"];
    }
    
    //点赞
    [self.zanBtn setImage:self.hisHomeResult.if_dianzan?[UIImage imageNamed:@"gerendang_shou_zan"]:[UIImage imageNamed:@"gerendang_shou"] forState:UIControlStateNormal];
    
    //魅力值
    
    NSString *meiliString=LOCALIZATION(@"Charm");
    
    self.meiliLabel.text=[NSString stringWithFormat:@"%@ %d",meiliString,self.hisHomeResult.meili_num];
 
    CGSize meiliLabelSize=[self.meiliLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    if (self.hisHomeResult.user_id!=account.user_id) {
    
         self.meiliLabel.frame=CGRectMake(kScreen_Width*0.5-meiliLabelSize.width,CGRectGetMaxY(self.nickNameLabel.frame)+5, meiliLabelSize.width, 30);
    }else{
        
         self.meiliLabel.frame=CGRectMake((kScreen_Width-meiliLabelSize.width)*0.5,CGRectGetMaxY(self.nickNameLabel.frame)+5, meiliLabelSize.width, 30);
    }
   
    
    
    //添加关注按钮
    
    if (self.hisHomeResult.user_id!=account.user_id) {
    
    
    
        UIButton *guanzhu=[UIButton buttonWithType:UIButtonTypeCustom];
        [guanzhu setTitle:self.hisHomeResult.if_friend?LOCALIZATION(@"PersonDetailFollowed"):LOCALIZATION(@"PersonDetaiolFollow") forState:UIControlStateNormal];
        self.guanzhu=guanzhu;
        guanzhu.layer.cornerRadius=5;
        guanzhu.frame=CGRectMake(kScreen_Width*0.5+20, CGRectGetMinY(self.meiliLabel.frame), 70, 30);
        guanzhu.alpha=0.7;
        guanzhu.backgroundColor=[UIColor blackColor];
        guanzhu.titleLabel.font=[UIFont systemFontOfSize:15];
        [guanzhu addTarget:self action:@selector(concernBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:guanzhu];
    }
    
   

    //ever值
    self.ever.text=LOCALIZATION(@"PersonDetailEverAccount");
    self.ever.frame=CGRectMake(5, 470, 80, 15);
    
    self.everAccount.text=[NSString stringWithFormat:@"%ld",self.hisHomeResult.user_id];
    
    self.everAccount.frame=CGRectMake(80, CGRectGetMinY(self.ever.frame), kScreen_Width-100, 15);
 
    [self addDownLine:CGRectGetMaxY(self.ever.frame)];
    
    //设置地址
    self.cityLabel.text=LOCALIZATION(@"PersonDetailCity");
    self.cityLabel.frame=CGRectMake(5, CGRectGetMaxY(self.ever.frame)+20, 30, 15);
    self.city.frame=CGRectMake(80, CGRectGetMinY(self.cityLabel.frame), kScreen_Width-80, 15);
    self.city.text=self.hisHomeResult.address;
    [self addDownLine:CGRectGetMaxY(self.cityLabel.frame)];
    
    //设置一句话
    
    self.workLabel.text=LOCALIZATION(@"PersonDetailDesc");
    self.workLabel.frame=CGRectMake(5, CGRectGetMaxY(self.cityLabel.frame)+20, 45, 15);
    self.word.frame=CGRectMake(80, CGRectGetMinY(self.workLabel.frame), kScreen_Width-80, 15);
    self.word.text=self.hisHomeResult.description_content;
    [self addDownLine:CGRectGetMaxY(self.workLabel.frame)];
    
    //设置scrollview大小
    if (kDevice_Is_iPhone4) {
        self.scrollView.contentSize=CGSizeMake(0, kScreen_Height+125);
    }else if (kDevice_Is_iPhone5){
        self.scrollView.contentSize=CGSizeMake(0, kScreen_Height+40);
    }

    //添加形象
    [self addFigure];
    
}

-(void)addDownLine:(CGFloat )y{
    
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, y+10, kScreen_Width, 1)];
    lineView.backgroundColor=[UIColor colorWithHexString:@"0xc8c7cc"];
    [self.scrollView addSubview:lineView];
    
}



- (void)addFigure
{
    if (self.hisHomeResult.images.count<=0) {
        UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-50, 340, 80, 80)];
        bgView.image=[UIImage imageNamed:@"logo_nothing"];
        [self.scrollView addSubview:bgView];
    }
    
   
    UIScrollView *figureScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 340, kScreen_Width, 80)];
    self.figureScroll=figureScroll;
    

    
    [self.scrollView addSubview:_figureScroll];
    
    long count=self.hisHomeResult.images.count;
    
    self.figureScroll.contentSize=CGSizeMake(count*70, 60);
    
    for (int i=0; i<count; i++) {
        
        
        ImageResult *image =self.hisHomeResult.images[i];
        NSURL *url=[NSURL URLWithString:image.image_url];
        UITapImageView *figure=[[UITapImageView alloc]init];
        [figure addTapBlock:^(id obj) {
            [self gotoBigImage:image.image_id];
        }];
        
        figure.frame=CGRectMake(10+i*(60+10)
                                , 10, 60, 60);
        [self.figureScroll addSubview:figure];
        [figure sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pictureholder"]];
        
        
    }

}

- (void)addBottomView
{

    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-40, kScreen_Width, 40)];
    bottomView.userInteractionEnabled=YES;
    bottomView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomView];
    
    
    
    UIButton *chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setTitle:LOCALIZATION(@"PersonDetailChat") forState:UIControlStateNormal];
    [chatBtn setFrame:CGRectMake(0, kScreen_Height-30, kScreen_Width*0.5, 20)];
    [chatBtn addTarget:self action:@selector(chatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatBtn];
    
  
    
    UIButton *lifeRoadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [lifeRoadBtn setTitle:LOCALIZATION(@"PersonDetailLifetrack") forState:UIControlStateNormal];
    [lifeRoadBtn setFrame:CGRectMake(kScreen_Width*0.5, kScreen_Height-30, kScreen_Width*0.5, 20)];
    [lifeRoadBtn addTarget:self action:@selector(lifeRoadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lifeRoadBtn];
    
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-1, 0, 1, 40)];
    line.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:line];
    
}

/**关注
 */
- (void)concernBtnClicked
{
    
    if  ([AccountTool isLogin]) {
        
        NSString *string=[NSString stringWithFormat:@"user/guanzhu/%ld",self.hisHomeResult.user_id];
        
        NSString *urlString=[kSeverPrefix stringByAppendingString:string];
        [HttpTool get:urlString params:nil success:^(id responseobj) {
            
            CLog(@"%@",responseobj);
            
            GuanzhuResult *result=[GuanzhuResult objectWithKeyValues:responseobj];
            
            //判断刚开始的时候是否关注
            
            self.hisHomeResult.if_friend=(result.guanzhu_status==1)?1:0;
            
            [MBProgressHUD showError:result.prompt];
            [self.guanzhu setTitle:(result.guanzhu_status==1)?@"已关注":@"关注" forState:UIControlStateNormal];
            
            //关注通知
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationGuanzhu object:result];
            
        } failure:^(NSError *erronr) {
            
        }];
    }else{
        
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
    
}

/**
 *  生活轨迹
 */
- (void)lifeRoadBtnClicked
{
    LoginResult *account=[AccountTool account];
    
    if (account.user_id==self.hisHomeResult.user_id) {
        
        LifeRoadViewController *lifeRoadVC=[[LifeRoadViewController alloc]init];
        lifeRoadVC.userid=self.user_id;
        [self.navigationController pushViewController:lifeRoadVC animated:YES];
        
    }else{
        
        if (self.hisHomeResult.can_see_center) {
            LifeRoadViewController *lifeRoadVC=[[LifeRoadViewController alloc]init];
            lifeRoadVC.userid=self.user_id;
            [self.navigationController pushViewController:lifeRoadVC animated:YES];
            
            
        }else{
            
            [MBProgressHUD showError:@"不能查看生活轨迹"];
        }
        
        
    }
    
}

/**
 *  私聊
 */
- (void)chatBtnClicked
{
    LoginResult *account=[AccountTool account];
    
    if (self.hisHomeResult.if_friend) {
        

        [RCIM connectWithToken:account.rong_token completion:^(NSString *userId) {
            
            ChatViewController *chatVC=[[ChatViewController alloc]init];
            
            chatVC.conversationType=ConversationType_PRIVATE;
            chatVC.currentTarget=[NSString stringWithFormat:@"u%ld",self.hisHomeResult.user_id];
            chatVC.enablePOI=NO;
            chatVC.enableVoIP=NO;
            chatVC.currentTargetName=self.hisHomeResult.user_nickname;
            chatVC.enableSettings=NO;
            [chatVC setNavigationTitle:self.hisHomeResult.user_nickname textColor:[UIColor blackColor]];
            chatVC.portraitStyle=RCUserAvatarCycle;
            chatVC.user=self.hisHomeResult;
            
            [self.navigationController pushViewController:chatVC animated:YES];
            
            
        } error:^(RCConnectErrorCode status) {
            CLog(@"连接融云失败");
            
        }];
    }else{
        
        [MBProgressHUD showError:@"亲,你还没有关注人家呦!"];
    }
    
}

/**
 *  进入形象大图
 */
- (void)gotoBigImage:(long)imageID
{
    BigImageViewController *bigImageVC=[[BigImageViewController alloc]init];
    bigImageVC.imageID=imageID;
    [self.navigationController pushViewController:bigImageVC animated:YES];
}


#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset=scrollView.contentOffset.y;
    
    if (yOffset<0) {
        CGFloat factor = ((ABS(yOffset)+ImageHeight)*kScreen_Width)/ImageHeight;
        
         CGRect f = CGRectMake(-(factor-kScreen_Width)/2, 0, factor, ImageHeight+ABS(yOffset));
        
        self.backgroundView.frame=f;
    }else{
        CGRect f=self.backgroundView.frame;
        f.origin.y=-yOffset;
        self.backgroundView.frame=f;
    }
    
    
}

//赞用户
- (void)zanClicked
{
    CLog(@"赞个人资料了");
    
    if ([AccountTool isLogin]) {
        LoginResult *account=[AccountTool account];
        
        NSString *string=[NSString stringWithFormat:@"user/zan/%ld",account.user_id ];
        
        NSString *urlString=[kSeverPrefix stringByAppendingString:string];
        
        [HttpTool get:urlString params:nil success:^(id responseobj) {
            
            CLog(@"%@",responseobj);
            ZanResult *zanResult=[ZanResult objectWithKeyValues:responseobj];
            [MBProgressHUD showError:zanResult.prompt];
            
            [self.zanBtn setImage:(zanResult.zan_status==1)?[UIImage imageNamed:@"gerendang_shou_zan"]:[UIImage imageNamed:@"gerendang_shou"] forState:UIControlStateNormal];
            
        } failure:^(NSError *erronr) {
            CLog(@"%@",erronr);
            
            
        }];
        
    }else{
        
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];

    }
    
   
}

@end
