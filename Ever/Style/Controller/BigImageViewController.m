//
//  BigImageViewController.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "BigImageViewController.h"
#import "LabelResult.h"
#import "CustomAnimationView.h"
#import "ImageResult.h"

@interface BigImageViewController ()<UMSocialUIDelegate>

@property (nonatomic,weak) UIImageView *imageView;

@property (nonatomic , strong) ImageResult *imageDetail;

@end



@implementation BigImageViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor=[UIColor blackColor];
       
        self.title=LOCALIZATION(@"BigImageDetail");
        
        
       //添加大图
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.userInteractionEnabled=YES;
        [self.view addSubview:imageView];
        self.imageView=imageView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"meet_fenxiang"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
}

-(void)setImageID:(long)imageID{
    _imageID=imageID;
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"image/detail/"];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%ld",string,imageID];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        ImageResult *imageDetail=[ImageResult objectWithKeyValues:responseobj];
        self.imageDetail=imageDetail;
        
        [self addPicture];
        

    } failure:^(NSError *erronr) {
        
    }];
    
}


//设置图片详细信息
- (void)addPicture {
    
    //图片
    NSURL *urlString=[NSURL URLWithString:self.imageDetail.image_url];
    self.imageView.frame=CGRectMake(0, (kScreen_Height-64-kScreen_Width)*0.5+64, kScreen_Width, kScreen_Width);
    
    [self.imageView sd_setImageWithURL:urlString placeholderImage:[UIImage imageNamed:@"pictureholder"]];
    
    //标签
    
    for (int i=0; i<self.imageDetail.labels.count; i++) {
        
        LabelResult *label=self.imageDetail.labels[i];
        CustomAnimationView *animationView=[[CustomAnimationView alloc]init];
        animationView.label=label;
        [self.imageView addSubview:animationView];
    }
    

}


//分享
- (void)share
{
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.imageDetail.image_url];
    
    
    [UMSocialData defaultData].extConfig.qqData.url = @"https://www.ooo.do";
    [UMSocialData defaultData].extConfig.wechatSessionData.url =  @"https://www.ooo.do";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =  @"https://www.ooo.do";
    [UMSocialData defaultData].extConfig.qzoneData.url =  @"https://www.ooo.do";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url= @"https://www.ooo.do";
    [UMSocialData defaultData].extConfig.tencentData.urlResource.url=@"https://www.ooo.do";
    [UMSocialData defaultData].extConfig.renrenData.url=@"https://www.ooo.do";
    
    NSString *title=@"EVER图片 Ever App https://www.ooo.do";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.tencentData.title = title;
  
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5545ced367e58ebfc600239e"
                                      shareText:@"Ever 给你最高品质的生活体验"
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina, UMShareToQQ, UMShareToTencent,UMShareToRenren]
                                       delegate:self];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[AFSoundManager sharedManager]pause];
}


@end
