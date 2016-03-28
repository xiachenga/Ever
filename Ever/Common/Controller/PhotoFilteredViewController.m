//
//  PhotoFilteredViewController.m
//  Ever
//
//  Created by Mac on 15-5-13.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//


#import "PhotoFilteredViewController.h"
#import "AAShareBubbles.h"
#import "CustomLabel.h"
#import "AddLabelViewController.h"
#import "AddSoundViewController.h"
#import <QiniuSDK.h>
#import "UptokenResult.h"
#import "TalkViewController.h"
#import "CustomTextView.h"
#import "YCXMenu.h"
#import "GediaoPublishSettingViewController.h"
#import "MyFigureViewController.h"
#import "MenuViewContoller.h"
#import "RootViewController.h"
#import "NewStyleViewController.h"
#import "ArticleCommentController.h"
@interface PhotoFilteredViewController ()<AAShareBubblesDelegate,AddLabelViewControllerDelegate,AddSoundViewControllerDelegate,UITextViewDelegate,CustomLabelDelegate,GediaoPublishSettingViewControllerDelegatte>

@property (nonatomic,weak)UITapImageView *imageView;

@property (nonatomic , strong) AAShareBubbles  *shareBubbles;

@property (nonatomic , weak) UIButton *shareButton;

@property (nonatomic , assign) BOOL bubbleIsShow;

@property (nonatomic , weak) UIImageView *dian;

@property (nonatomic , assign) CGPoint dianPoint;

@property (nonatomic , strong) NSMutableArray *labelArray,*yuyinArray;

@property (nonatomic , assign) int iconType,labelTag;

@property (nonatomic , copy) NSString *uptoken;


@property (nonatomic , weak) CustomTextView *textView;

@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , weak) UIView *tipView;
@end

@implementation PhotoFilteredViewController

- (NSMutableArray *)items {
    if (!_items) {
        
        _items = [@[
                    [YCXMenuItem menuItem:LOCALIZATION(@"DirectPublish")
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:LOCALIZATION(@"set_read_dead")
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    

                    ] mutableCopy];
    }
    return _items;
}
- (NSMutableArray *)labelArray
{
    if (_labelArray==nil) {
        _labelArray=[NSMutableArray array];
    }
    return _labelArray;
    
}


-(NSMutableArray *)yuyinArray
{
    if (!_yuyinArray) {
        _yuyinArray=[NSMutableArray array];
    }
    return _yuyinArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=LOCALIZATION(@"PhotoPublishImage");
        
        UITapImageView *imageView=[[UITapImageView alloc]init];
        
        imageView.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Width);
    
        imageView.userInteractionEnabled=YES;
        UIGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        
        [self.view addSubview:imageView];
        self.imageView=imageView;
        
        UIView *tipView=[[UIView alloc]init];
        tipView.userInteractionEnabled=NO;
        tipView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        tipView.layer.cornerRadius=10;
        self.tipView=tipView;
        [self.view addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(10);
            make.right.equalTo(self.view).with.offset(-10);
            make.center.equalTo(self.view);
            make.height.mas_equalTo(40);
            
        }];
        
        UILabel *tipLabel=[[UILabel alloc]init];
        [tipView addSubview:tipLabel];
        tipLabel.text=LOCALIZATION(@"click_add_marker");
        tipLabel.textColor=[UIColor whiteColor];
        tipLabel.textAlignment=NSTextAlignmentCenter;
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(tipView);
            make.size.mas_equalTo(tipView);
            
        }];
        
        
        CustomTextView *textView=[[CustomTextView alloc]initWithFrame:CGRectMake(5, 64+kScreen_Width+5, kScreen_Width-10, kScreen_Height-kScreen_Width-64-10)];
        textView.font=[UIFont systemFontOfSize:15];
        textView.layer.borderColor=kThemeColor.CGColor;
        textView.layer.borderWidth=2;
        textView.returnKeyType=UIReturnKeyDone;
        textView.hidden=YES;
        self.textView=textView;
        textView.delegate=self;
        [self.view addSubview:textView];
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:LOCALIZATION(@"ImageClipSucceed") style:UIBarButtonItemStylePlain target:self action:@selector(accomplish)];
    
}

- (void)imageViewClicked:(UIGestureRecognizer *)gesture
{
    self.tipView.hidden=YES;
    
    
    if (self.bubbleIsShow) {
        [self.dian removeFromSuperview];
        [self.shareBubbles hide];
        self.bubbleIsShow=NO;
    }else{
        
        AAShareBubbles *shareBubbles=[[AAShareBubbles alloc]initWithPoint:CGPointMake(kScreen_Width*0.5, 64+kScreen_Width*0.5) radius:(kScreen_Width-80)*0.5 inView:self.imageView];
        
        self.shareBubbles=shareBubbles;
        shareBubbles.delegate=self;
        shareBubbles.bubbleRadius=30;
        [shareBubbles show];
        self.bubbleIsShow=YES;
    }

}

-(void)setSelectedImage:(UIImage *)selectedImage
{
   
    _selectedImage=selectedImage;
    
    self.imageView.image=selectedImage;
    
    self.imageView.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Width);
}


- (void)setKind:(KindItem *)kind{
    
    _kind=kind;
    if (self.kind.kind==2||self.kind.kind==5) {
        self.textView.hidden=NO;
        
        if (self.kind.kind==2) {
            self.textView.placeholder=LOCALIZATION(@"AddMarker");
        }else{
            self.textView.placeholder=LOCALIZATION(@"CoffeeComment");
        }
    }
}

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType
{
    [self.dian removeFromSuperview];
    self.bubbleIsShow=NO;
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
        {
            CLog(@"爱情");
            self.iconType=3;
            AddLabelViewController *addLabelVC=[[AddLabelViewController alloc]init];
            addLabelVC.delegate=self;
            [self.navigationController pushViewController:addLabelVC animated:YES];
        }
            break;
        case AAShareBubbleTypeTwitter:
        {
            CLog(@"美食");
            self.iconType=4;
            AddLabelViewController *addLabelVC=[[AddLabelViewController alloc]init];
            addLabelVC.delegate=self;
            [self.navigationController pushViewController:addLabelVC animated:YES];
            
        }
            break;
        case AAShareBubbleTypeTumblr:
        {
            CLog(@"普通");
            self.iconType=1;
            AddLabelViewController *addLabelVC=[[AddLabelViewController alloc]init];
             addLabelVC.delegate=self;
            [self.navigationController pushViewController:addLabelVC animated:YES];
        }
            break;
        case AAShareBubbleTypeYoutube:
        {
            CLog(@"人物");
            self.iconType=6;
            AddLabelViewController *addLabelVC=[[AddLabelViewController alloc]init];
             addLabelVC.delegate=self;
            [self.navigationController pushViewController:addLabelVC animated:YES];
        }
            break;
        case AAShareBubbleTypeVimeo:
        {
            CLog(@"猥琐");
            self.iconType=5;
            AddLabelViewController *addLabelVC=[[AddLabelViewController alloc]init];
             addLabelVC.delegate=self;
            [self.navigationController pushViewController:addLabelVC animated:YES];
        }
            break;
        case AAShareBubbleTypeReddit:
        {
            CLog(@"语音");
            self.iconType=2;
            AddSoundViewController *addSoundVC=[[AddSoundViewController alloc]init];
            addSoundVC.delegate=self;
            [self.navigationController pushViewController:addSoundVC animated:YES];
        }
            break;
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (self.bubbleIsShow) {
        
        
    }else{
        
        [self addLabel:touches];
    }
}
- (void)addLabel:(NSSet*)touches
{
    UITouch *touch= [touches anyObject ];
    CGPoint touchPoint=[touch locationInView:self.view];
    
    UIImageView *dian=[[UIImageView alloc]initWithFrame:CGRectMake(touchPoint.x, touchPoint.y, 10, 10)];
    dian.image=[UIImage imageNamed:@"fabu_tab_dian"];
    self.dian=dian;
    self.dianPoint=dian.frame.origin;
    
    [self.view addSubview:dian];
    
    
}


#pragma mark AddLabelViewControllerDelegate
- (void)addLabelText:(NSString *)labelText color_type:(int)color_type {
    
    //记录标签的下标，为了删除做准备
    
    self.labelTag++;
    
    CGSize textSize=[labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    CustomLabel *bgView= [self customLabelBackgrondViewWithWidth:textSize.width];
    bgView.tag=self.labelTag;
   
    bgView.delegate=self;
    
    NSString *imageName=[NSString stringWithFormat:@"fabu_qipao_%d",color_type];
  
    UIImage *bgImage = [UIImage  imageNamed:imageName];
    
    bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 5, textSize.width+10+15, 20)];
    imageView.image=bgImage;
    [bgView addSubview:imageView];
    
    //小图像
    UIImageView *typeImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 12, 12)];
    NSString *imageString=[NSString stringWithFormat:@"fabu_biaoqian_%d",self.iconType];
    typeImage.image=[UIImage imageWithName:imageString];
    [imageView addSubview:typeImage];
    
    
    
    UILabel *biaoqian=[[UILabel alloc]init];
    biaoqian.text=labelText;
    biaoqian.font=[UIFont systemFontOfSize:15];
    [biaoqian setTextColor:[UIColor whiteColor]];
    biaoqian.frame=CGRectMake(20, 2, textSize.width, 15);
    [imageView addSubview:biaoqian];
    
    
    
    NSMutableDictionary *label=[NSMutableDictionary dictionary];
    

    [label setValue:[NSString stringWithFormat:@"%d",color_type] forKey:@"color_type"];
    [label setValue:labelText forKey:@"text_name"];
    
    [label setValue:[NSString stringWithFormat:@"%f",(self.dianPoint.y-64-10)/kScreen_Width] forKey:@"topMargin"];
    [label setValue:[NSString stringWithFormat:@"%f",(self.dianPoint.x-10)/kScreen_Width] forKey:@"leftMargin"];
    
    [label setValue:[NSString stringWithFormat:@"%d",self.iconType] forKey:@"icon_type"];
    
    [self.labelArray addObject:label];
    
}

//自定义标签的底部view和白点黑点
- (CustomLabel *)customLabelBackgrondViewWithWidth:(CGFloat)width
{
    
    CustomLabel *bgView=[[CustomLabel alloc]initWithFrame:CGRectMake(self.dianPoint.x-10, self.dianPoint.y-10, width+30+30, 40)];

    bgView.userInteractionEnabled=YES;
    
    [self.view addSubview:bgView];
    
    UIImageView *animationdian=[[UIImageView alloc]init];
    animationdian.frame=CGRectMake(10, 10, 10, 10);
    animationdian.image=[UIImage imageNamed:@"fabu_tab_dian"];
    
    [bgView addSubview:animationdian];
    
    
    UIImageView *animationBlackdian=[[UIImageView alloc]init];
    animationBlackdian.frame=CGRectMake(7, 8, 15, 15);
    animationBlackdian.image=[UIImage imageNamed:@"fabu_tab_dianbg"];
    animationBlackdian.alpha=0;
    
    [bgView addSubview:animationBlackdian];
    [self startAnimation:animationdian blackdian:animationBlackdian ];
    
    return bgView;
}

#pragma   AddSoundViewControllerDelegate3

-(void)selectColor_type:(int)color_type pathForAudio:(NSURL *)pathForAudio lastTime:(int)time
{
 
    
    CustomLabel *bgView= [self customLabelBackgrondViewWithWidth:20];
    
    
    NSString *imageName=[NSString stringWithFormat:@"fabu_qipao_%d",color_type];
    UIImage *bgImage = [UIImage imageNamed:imageName];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 25, 20)];
    imageView.image=bgImage;
    [bgView addSubview:imageView];
    
    UIImageView *typeImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 12, 12)];
   
    typeImage.image=[UIImage imageWithName:@"fabu_biaoqian_2"];
    [imageView addSubview:typeImage];
    
    
    NSString *voice_name=[NSString stringWithFormat:@"%@.amr",[self createRandomFigure]];
    
    NSData *data=[NSData dataWithContentsOfURL:pathForAudio];
    data.accessibilityValue=voice_name;
    
    CLog(@"%@",data.accessibilityValue);
    
    
    [self.yuyinArray addObject:data];
    
    NSMutableDictionary *label=[NSMutableDictionary dictionary];
    [label setValue:[NSString stringWithFormat:@"%d",color_type] forKey:@"color_type"];
    
    [label setValue:[NSString stringWithFormat:@"%.2f",(self.dianPoint.y-64-10)/kScreen_Width] forKey:@"topMargin"];
    [label setValue:[NSString stringWithFormat:@"%.2f",(self.dianPoint.x-10)/kScreen_Width] forKey:@"leftMargin"];
    
    [label setValue:[NSString stringWithFormat:@"%d",self.iconType] forKey:@"icon_type"];
    [label setValue:[NSString stringWithFormat:@"%d",time] forKey:@"voice_time"];
    
    [label setValue:voice_name forKey:@"voice_name"];

    [self.labelArray addObject:label];
    
}


- (void)startAnimation:(UIImageView *)animationdian blackdian:(UIImageView *)blackdian
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        animationdian.transform=CGAffineTransformMakeScale(0.8, 0.8);
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            animationdian.transform=CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            
            animationdian.transform=CGAffineTransformMakeScale(1, 1);
            
            [UIView animateWithDuration:1 animations:^{
                blackdian.alpha=0.5;
                blackdian.transform=CGAffineTransformMakeScale(2, 2);
                
            } completion:^(BOOL finished) {
                
                blackdian.alpha=0;
                
                blackdian.transform=CGAffineTransformMakeScale(1.0, 1.0);
               
                [self startAnimation:animationdian blackdian:blackdian];
                
                
            }];
            


        }];
        
        
    }];    
}

- (void)accomplish
{
    //让弹出键盘取消第一响应者
    [self.textView resignFirstResponder];
    
    if (self.kind.kind==1) {
        
       [self releaseFigure];
        
    }else if (self.kind.kind==2)
    {
       
        [YCXMenu setTintColor:[UIColor blackColor]];
        [YCXMenu setHasShadow:YES];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            
            if (item.tag==100) {
                
                CLog(@"直接发布");
                
                [self releaseGediao:nil];
                
                
            }else if(item.tag==101)
            {
                CLog(@"阅后即焚");
                
                GediaoPublishSettingViewController *gediaoSettingVC=[[GediaoPublishSettingViewController alloc]init];
                gediaoSettingVC.delegate=self;
                [self.navigationController pushViewController:gediaoSettingVC animated:YES];

            }
            
        }];
        
        
    }else if(self.kind.kind==3)
    {
        
       [self gotoJournalReleaseWithImage:self.imageView.image];
        
    }else if(self.kind.kind==5)
    {
        [self fabuArticleComment];
    }
}


//COFFEE评论
-(void)fabuArticleComment
{
    if (self.yuyinArray.count>0) {
        [self upLoadYuyin];
    }
    
    
    [self.view beginLoading];
    
    NSString *image_name=[NSString stringWithFormat:@"%@.png",[self createRandomFigure]];
    
    QNUploadManager *upManager=[[QNUploadManager alloc]init];
    NSData *imageData=UIImagePNGRepresentation(self.imageView.image);
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/uptoken/1"];
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
        
        [upManager putData:imageData key:image_name token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            
            [dic setValue:image_name forKey:@"image_name"];
            [dic setValue:self.labelArray forKey:@"labels"];
            
            NSMutableDictionary *params=[NSMutableDictionary dictionary];
            
            [params setValue:[NSString stringWithFormat:@"%ld",self.kind.itemID] forKey:@"article_id"];
            [params setValue:self.textView.text forKey:@"text_content"];
            [params setValue:dic forKey:@"image"];
            
            

            NSString *url=[kSeverPrefix stringByAppendingString:@"coffee/replay"];
            
          
            
            [HttpTool send:url params:params success:^(id responseobj) {
                
                
               
                
                [self.view endLoading];
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
                
                if (dic!=nil) {
                    NormalResult *normal=[NormalResult objectWithKeyValues:dic];
                    [MBProgressHUD showError:normal.prompt];
                }else{
                    
                    [MBProgressHUD showError:@"请检查你的网络"];
                }
                
                //返回到评论页
                NSArray *array=self.navigationController.viewControllers;
                ArticleCommentController *articleCommentVC =array[2];
                
                [articleCommentVC refresh];
                [self.navigationController popToViewController:articleCommentVC animated:YES];
                
            
            }];
            
            
        } option:nil];
        
    } failure:^(NSError *erronr) {
        
        [self.view endLoading];
        
        CLog(@"%@",erronr);
        
    }];
    
}

//返回日记
-(void)gotoJournalReleaseWithImage:(UIImage *)image
{
    TalkViewController *releaseJournalVC;
    UIViewController *VC;
    
    VC=[self.navigationController.viewControllers objectAtIndex:1];
    if ([VC isKindOfClass:[TalkViewController class]]) {
        releaseJournalVC=(TalkViewController *)VC;
    }else{
        
        VC=[self.navigationController.viewControllers objectAtIndex:2];
        releaseJournalVC=(TalkViewController *)VC;
    }

    [releaseJournalVC selectedImage:self.imageView.image labels:self.labelArray withyuyin:self.yuyinArray];
    
    [self.navigationController popToViewController:releaseJournalVC animated:YES];
        
}

/**
 *  发表形象
 
 */

- (void)releaseFigure
{
    
    if (self.yuyinArray.count>0) {
        [self upLoadYuyin];
    }
    
    
    [self.view beginLoading];
    
     NSString *image_name=[NSString stringWithFormat:@"%@.png",[self createRandomFigure]];
    
    QNUploadManager *upManager=[[QNUploadManager alloc]init];
    NSData *imageData=UIImagePNGRepresentation(self.imageView.image);
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/uptoken/1"];
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
        
        [upManager putData:imageData key:image_name token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            CLog(@"%d",info.isOK);
            

            
             NSString *string=[kSeverPrefix stringByAppendingString:@"user/xingxiang"];
            
            
            
            NSMutableDictionary *params=[NSMutableDictionary dictionary];
            
            [params setValue:image_name forKey:@"image_name"];
            [params setValue:self.labelArray forKey:@"labels"];
            
            [HttpTool send:string params:params success:^(id responseobj) {
                
                [self.view endLoading];
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
                
                if (dic!=nil) {
                    
                    NormalResult *normal=[NormalResult objectWithKeyValues:dic];
                    [MBProgressHUD showError:normal.prompt];
                    
                    //返回到发布形象界面
                    
                    MyFigureViewController *myFigureVC=[self.navigationController.viewControllers objectAtIndex:1];
                    [myFigureVC loadData];

                    [self.navigationController popToViewController:myFigureVC animated:YES];
                    
                    
                    
                }else{
                    
                    [MBProgressHUD showError:@"请检查你的网络"];
                }
                
                
                
            }];
            
        
           } option:nil];
        
    } failure:^(NSError *erronr) {
        
        [self.view endLoading];
        
        CLog(@"%@",erronr);
        
    }];

}

/**
 *  发表格调
 */
- (void)releaseGediao:(NSDictionary *)gediaoSetting
{
    if (self.yuyinArray.count>0) {
        [self upLoadYuyin];
    }
    
    [self.view beginLoading];

    NSString *image_name=[NSString stringWithFormat:@"%@.png",[self createRandomFigure]];
    
    QNUploadManager *upManager=[[QNUploadManager alloc]init];
    NSData *imageData=UIImagePNGRepresentation(self.imageView.image);
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/uptoken/1"];
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
        UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
        
        [upManager putData:imageData key:image_name token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            
            
            //图片名字和标签
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            
            [dic setValue:image_name forKey:@"image_name"];
            [dic setValue:self.labelArray forKey:@"labels"];
            [dic setValue:self.textView.text forKey:@"name"];
        
            
            NSString *url=[kSeverPrefix stringByAppendingString:@"world/tag"];
            
            NSMutableDictionary *params=[NSMutableDictionary dictionary];
            
            if (gediaoSetting!=nil) {
                
                [params setValue:gediaoSetting forKey:@"yinsi"];
            }
            
            

            [params setValue:self.kind.position forKey:@"position"];
            [params setValue:dic forKey:@"gediao"];
        
             
            [HttpTool send:url params:params success:^(id responseobj) {
                
                [self.view endLoading];
            
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
                
                if (dic!=nil) {
                    NormalResult *normal=[NormalResult objectWithKeyValues:dic];
                    [MBProgressHUD showError:normal.prompt];
                    
                    //发布完以后返回
                    
                     RootViewController *styleVC;
                 
                    
                     MenuViewContoller *menuVC= (MenuViewContoller *)self.mm_drawerController.leftDrawerViewController;
                     styleVC=menuVC.styleVC;
                    
                    
    
                     if (styleVC!=nil) {
                         
                        [menuVC buttonClicked:menuVC.styleButton];
                         
                        UISegmentedControl *segmentControl=styleVC.segmentedControl;
                        segmentControl.selectedSegmentIndex=0;
                        [styleVC segmentedControlSelected:segmentControl];
                         
                         NewStyleViewController *newStyleVC=styleVC.childViewControllers[0];
                         [newStyleVC refresh];
                         [newStyleVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                          
                         
                         BaseNavigationController *styleSegNav = (BaseNavigationController *)(BaseNavigationController *)self.mm_drawerController.centerViewController;
                         

                         styleSegNav.viewControllers=@[styleVC];
                         
                         //让地图的数据刷新
                          [styleVC bigSocityRefresh];
                         
                     }else{
                         
                          [menuVC buttonClicked:menuVC.styleButton];
                         
                          BaseNavigationController *styleSegNav = (BaseNavigationController *)(BaseNavigationController *)self.mm_drawerController.centerViewController;
                         
                         styleVC=[[RootViewController alloc]init];
                         menuVC.styleVC=styleVC;
                         styleSegNav.viewControllers=@[styleVC];
                     }
                    
            
                }else{
                    
                    [MBProgressHUD showError:@"请检查你的网络"];
                }
                
                
            }];
            
            
        } option:nil];
        
    } failure:^(NSError *erronr) {
        
        [self.view endLoading];
        
    }];    
}

#pragma mark GediaoPublishSettingViewControllerDelegatte

-(void)Controller:(GediaoPublishSettingViewController *)controller disappear:(NSString *)date time:(NSString *)time isAnnoymity:(BOOL)isAnnoymity allowComment:(BOOL)comment showOnMap:(BOOL)showOnMap{
    
    NSMutableDictionary *gediaoDic=[NSMutableDictionary dictionary];
    [gediaoDic setValue:@1 forKey:@"over_type"];
    [gediaoDic setValue:date forKey:@"day"];
    [gediaoDic setValue:time forKey:@"time"];
    [gediaoDic setValue:[NSString stringWithFormat:@"%d",comment] forKey:@"if_can_comment"];
    [gediaoDic setValue:[NSString stringWithFormat:@"%d",isAnnoymity] forKey:@"if_anonymity"];
    [gediaoDic setValue:[NSString stringWithFormat:@"%d",showOnMap] forKey:@"if_see_map"];
    
    [self releaseGediao:gediaoDic];

    
}


//产生随机数
-(NSString *)createRandomFigure
{
    
    char data[10];
    for (int x=0;x<10;data[x++] = (char)('a' + (arc4random_uniform(26))));
    NSString *zimu= [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding];
    
    NSDate *date=[NSDate date];
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"YYYYMMddHHmmss"];
    NSString *FormateDate=[dateformater stringFromDate:date];
    
    NSString *randomFigure=[NSString stringWithFormat:@"%@%@",zimu,FormateDate];
    
    return randomFigure;
    
}

- (void)upLoadYuyin
{
    
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/uptoken/3"];
    
    [HttpTool get:string params:nil success:^(id responseobj) {
        
         UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
         QNUploadManager *upManager=[[QNUploadManager alloc]init];
        for (int i=0; i<self.yuyinArray.count; i++) {
            
            
            NSData *data=self.yuyinArray[i];
            
            [upManager  putData:data key:data.accessibilityValue token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                CLog(@"%d",info.isOK);
                
            } option:nil];
            
        }
        
        
    } failure:^(NSError *erronr) {
        
    }];
}


//UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)keyboardShow:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.view.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
    
}
- (void)keyboardHide:(NSNotification *)notification
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)languageChange
{
    CLog(@"收到通知");
    
    self.title=LOCALIZATION(@"PhotoPublishImage");

}

#pragma CustomLabelDelegate


- (void)labelDelete:(int)sender{
    
    if (self.labelArray!=nil) {
        
        [self.labelArray removeObjectAtIndex:(sender-1)];
        
    }
}

- (void)labelMovedendWithX:(double)X endWithY:(double)Y withViewTag:(int)tag{
    
    NSDictionary *label=self.labelArray[tag-1];
    
    NSString *labelText=[label objectForKey:@"text_name"];
    
     CGSize textSize=[labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    CGFloat width=(textSize.width+60)/2-10;
    
    [label setValue:[NSString stringWithFormat:@"%.2f",(Y-64-20)/kScreen_Width] forKey:@"topMargin"];
    
    [label setValue:[NSString stringWithFormat:@"%.2f",(X-width-10)/kScreen_Width] forKey:@"leftMargin"];
    
   

}

-(void)dealloc
{
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
    
}



@end
