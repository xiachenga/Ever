//
//  ShopViewController.m
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ShopViewController.h"
#import "BusinessIndexResult.h"
#import "HeadimageResult.h"
#import "PersonhomeViewController.h"
#import "GoodsIndexResult.h"

@interface ShopViewController ()

@property (nonatomic,strong)BusinessIndexResult *shopResult;

@property (nonatomic , weak) UIScrollView *horizonScrollview;

@end

@implementation ShopViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
}

//请求数据
- (void)loadData{
    
    NSString *string=[kSeverPrefix stringByAppendingString:[NSString stringWithFormat:@"business/%ld",_bid]];
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        BusinessIndexResult *result=[BusinessIndexResult objectWithKeyValues:responseobj];
        self.shopResult=result;
        [self addSubViews];
        
    } failure:^(NSError *erronr) {
        
    }];
    
}

- (void)setBid:(long)bid{
    
    _bid=bid;
    
    [self loadData];
    
}

//添加子控件
- (void)addSubViews{
    
    
    UIScrollView *verticalScrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:verticalScrollview];
    verticalScrollview.contentSize=CGSizeMake(kScreen_Width, kScreen_Height+450);
    
    //品牌logo
    UIImageView *shopLogoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, 200)];
    [verticalScrollview addSubview:shopLogoView];
    [shopLogoView sd_setImageWithURL:[NSURL URLWithString:self.shopResult.banner_image_url] placeholderImage:nil];
    
    CGFloat padding=(kScreen_Width-3*60)*0.25;
    UIButton *descBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [descBtn setTitle:@"简介" forState:UIControlStateNormal];
    [descBtn setBackgroundColor:[UIColor whiteColor]];
    [descBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    descBtn.layer.cornerRadius=3;
    [descBtn addTarget:self action:@selector(descBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    descBtn.frame=CGRectMake(padding, 204, 60, 30);
    [verticalScrollview addSubview:descBtn];
    
    UIButton *disPlayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [disPlayBtn setTitle:@"陈列架" forState:UIControlStateNormal];
    [disPlayBtn setBackgroundColor:[UIColor whiteColor]];
    [disPlayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    disPlayBtn.layer.cornerRadius=3;
    [disPlayBtn addTarget:self action:@selector(disPlayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    disPlayBtn.frame=CGRectMake(CGRectGetMaxX(descBtn.frame)+padding, 204, 60, 30);
    [verticalScrollview addSubview:disPlayBtn];
    
    UIButton *cultureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cultureBtn setTitle:@"Culture" forState:UIControlStateNormal];
    [cultureBtn setBackgroundColor:[UIColor whiteColor]];
    [cultureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cultureBtn.layer.cornerRadius=3;
    [cultureBtn addTarget:self action:@selector(cultureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    cultureBtn.frame=CGRectMake(CGRectGetMaxX(disPlayBtn.frame)+padding, 204, 60, 30);
    [verticalScrollview addSubview:cultureBtn];
    
    
    UIScrollView *horizonScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shopLogoView.frame), kScreen_Width, 650)];
    self.horizonScrollview=horizonScrollview;
    horizonScrollview.pagingEnabled=YES;
    horizonScrollview.scrollEnabled=NO;
    horizonScrollview.contentSize=CGSizeMake(kScreen_Width*3, 0);
    [verticalScrollview addSubview:horizonScrollview];
    
    
    UIView *followerView=[self viewWithTitle:@"品牌粉丝"];
    followerView.frame=CGRectMake(0, 0, kScreen_Width, 40);
    [horizonScrollview addSubview:followerView];
    
    CGFloat avatarPadding=10;
    CGFloat width=(kScreen_Width-60)*0.2;
    UIImageView *followerBgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paihangbang_beijing"]];
    followerBgView.userInteractionEnabled=YES;
    followerBgView.frame=CGRectMake(0, CGRectGetMaxY(followerView.frame), kScreen_Width, width+50);
    [horizonScrollview addSubview:followerBgView];
    
    
    for (int i=0; i<5; i++) {
        NSArray *avatarArray=self.shopResult.headimageResults;
        HeadimageResult *result=avatarArray[i];
        UITapImageView *avatarView=[[UITapImageView alloc]initWithFrame:CGRectMake(avatarPadding+(avatarPadding+width)*i, 25, width, width)];
        [avatarView doCircleFrame];
        [followerBgView addSubview:avatarView];
        [avatarView setImageWithUrl:[NSURL URLWithString:result.user_head_image_url] placeholderImage:[UIImage imageNamed:@"avatarholder"] tapBlock:^(id obj) {
            
            PersonhomeViewController *personHomeVC=[[PersonhomeViewController alloc]init];
            personHomeVC.user_id=result.user_id;
            [self.navigationController pushViewController:personHomeVC animated:YES];
        }];
    }
    
    //品牌资料
    UIView *brandView=[self viewWithTitle:@"品牌资料"];
    brandView.frame=CGRectMake(0, CGRectGetMaxY(followerBgView.frame),kScreen_Width , 40);
    [horizonScrollview addSubview:brandView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(brandView.frame), 100, 40)];
    nameLabel.text=@"名称";
    [horizonScrollview addSubview:nameLabel];
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(110, CGRectGetMaxY(brandView.frame), kScreen_Width-110, 40)];
    name.textColor=[UIColor grayColor];
    name.text=self.shopResult.bname;
    
    [horizonScrollview addSubview:name];
    
    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame), kScreen_Width, 40)];
    locationLabel.text=@"所在地";
    [horizonScrollview addSubview:locationLabel];
    
    UILabel *location=[[UILabel alloc]initWithFrame:CGRectMake(110, CGRectGetMaxY(nameLabel.frame), kScreen_Width-110, 40)];
    location.textColor=[UIColor grayColor];
    location.text=self.shopResult.bcity;
    [horizonScrollview addSubview:location];
    
    UILabel *brandTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(locationLabel.frame), 110, 40)];
    brandTypeLabel.text=@"品牌类型";
    [horizonScrollview addSubview:brandTypeLabel];
    
    UILabel *brandType=[[UILabel alloc]initWithFrame:CGRectMake(110, CGRectGetMaxY(locationLabel.frame), kScreen_Width-110, 40)];
    brandType.textColor=[UIColor grayColor];
    brandType.text=self.shopResult.brandTypeName;
    [horizonScrollview addSubview:brandType];
    
    UIView *brandDescView=[self viewWithTitle:@"品牌介绍"];
    brandDescView.frame=CGRectMake(0, CGRectGetMaxY(brandTypeLabel.frame), kScreen_Width, 40);
    [horizonScrollview addSubview:brandDescView];
    
    UILabel *descLabel=[[UILabel alloc]init];
    descLabel.numberOfLines=0;
    CGSize descLabelSize=[self.shopResult.introduce boundingRectWithSize:CGSizeMake(kScreen_Width-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    descLabel.text=self.shopResult.introduce;
    descLabel.frame=CGRectMake(10, CGRectGetMaxY(brandDescView.frame)+5, descLabelSize.width, descLabelSize.height);
    [horizonScrollview addSubview:descLabel];
    
    UIView *brandRecommmendView=[self viewWithTitle:@"品牌推荐"];
    brandRecommmendView.frame=CGRectMake(0, CGRectGetMaxY(descLabel.frame), kScreen_Width, 40);
    [horizonScrollview addSubview:brandRecommmendView];
    
    CGFloat imageWidth=(kScreen_Width-30)*0.5;
   
    
    for (int i=0; i<2; i++) {
        
        GoodsIndexResult *goodResult=self.shopResult.tuijianList[i];
        UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, CGRectGetMaxY(brandRecommmendView.frame)+10, imageWidth, imageWidth)];
        [horizonScrollview addSubview:imageView];
        
        [imageView setImageWithUrl:[NSURL URLWithString:goodResult.image_url] placeholderImage:[UIImage imageNamed:@"pictureholder"] tapBlock:^(id obj) {
            
            CLog(@"点击图片了");
        }];
    }

}


- (UIView *)viewWithTitle:(NSString *)title{
    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=kThemeColor;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    label.text=title;
    [view addSubview:label];
    return view;
    
}

- (void)descBtnClicked{
    
    self.horizonScrollview.contentOffset=CGPointMake(0, 0);
    
}

- (void)disPlayBtnClicked{
    
    self.horizonScrollview.contentOffset=CGPointMake(kScreen_Width, 0);
    
}

- (void)cultureBtnClicked{
    
    self.horizonScrollview.contentOffset=CGPointMake(kScreen_Width*2, 0);
}


@end
