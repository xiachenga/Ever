//
//  TalkViewController.m
//  Ever
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "TalkViewController.h"
#import "CustomTextView.h"
#import "ReleaseaViewController.h"
#import "WorldTagIndexResult.h"
#import "PhotoFilteredViewController.h"
#import <QiniuSDK.h>
#import "UptokenResult.h"
#import "GediaoPublishSettingViewController.h"
#import "YCXMenu.h"
#import "RootViewController.h"
#import "MenuViewContoller.h"
#import "NewStyleViewController.h"


@interface TalkViewController ()<UITextFieldDelegate,UITextViewDelegate,GediaoPublishSettingViewControllerDelegatte>

@property(nonatomic,weak)UITextField *titleField;
@property (nonatomic , weak) UITextView *contentView;
@property (nonatomic , weak) UITapImageView *jiaohaoView;
@property (nonatomic , strong) NSMutableArray *imageArray,*labelArray,*yuyinArray;
@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation TalkViewController

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

- (NSMutableArray *)imageArray
{
    if (_imageArray==nil) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
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
    if (_yuyinArray==nil) {
        _yuyinArray=[NSMutableArray array];
    }
    return _yuyinArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        
        self.title=LOCALIZATION(@"PublishJournalTitle");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:LOCALIZATION(@"PublishJournalSure") style:UIBarButtonItemStyleBordered target:self action:@selector(sureButtonClicked)];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    //标题UITextField
    
    [self setupTitleField];
    
    //内容TextField
    [self setupContentField];
    
    //
    [self addCameraButton];
    
   
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
   
}

//设置标题textField
- (void)setupTitleField
{
    UITextField *titleField=[[UITextField alloc]init];
    titleField.backgroundColor=[UIColor whiteColor];
    titleField.layer.borderWidth=2;
    titleField.layer.borderColor=kThemeColor.CGColor;
    titleField.clearButtonMode=UITextFieldViewModeAlways;
    titleField.frame=CGRectMake(5, 70, kScreen_Width-2*5, 30);
    titleField.placeholder=LOCALIZATION(@"JournalWriteTitle");
    titleField.delegate=self;
    titleField.returnKeyType=UIReturnKeyDone;
    titleField.textColor=[UIColor blackColor];
    self.titleField=titleField;
    titleField.font=[UIFont systemFontOfSize:16];
    [titleField becomeFirstResponder];
    [self.view addSubview:titleField];
}


////设置内容textField
- (void)setupContentField
{
    CustomTextView *contentView=[[CustomTextView alloc]init];
    contentView.backgroundColor=[UIColor whiteColor];
    contentView.frame=CGRectMake(5, CGRectGetMaxY(self.titleField.frame)+5, kScreen_Width-2*5, 150);
    contentView.placeholder=LOCALIZATION(@"JournalEnterContent");
    contentView.layer.borderWidth=2;
    contentView.layer.borderColor=kThemeColor.CGColor;
    contentView.textColor=[UIColor blackColor];
    self.contentView=contentView;
    contentView.delegate=self;
    contentView.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:contentView];
}


- (void)addCameraButton
{
    UITapImageView *jiahaoView=[[UITapImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.contentView.frame)+5, 80, 80)];
    
    jiahaoView.image=[UIImage imageNamed:@"openAlbumjia"];
    
    [self.imageArray addObject:jiahaoView];
    [jiahaoView addTapBlock:^(id obj) {
        [self gotoAlbum];
        
    }];
    self.jiaohaoView=jiahaoView;
    [self.view addSubview:jiahaoView];
}


- (void)sureButtonClicked
{

    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setHasShadow:YES];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        
        if (item.tag==100) {
            
            
            
            if (self.contentView.text.length>=300    ) {
                
                if (self.yuyinArray.count>0) {
                    [self upLoadyuyin:self.yuyinArray];
                }
                
                if (self.imageArray.count>1) {
                    [self upLoadpicture:nil];
                }else{
                    [self upLoadServer:nil];
                }
                
                
            }else{
                [MBProgressHUD showError:@"字数要大于300字"];
            }
            
            
        }else if(item.tag==101)
        {
            
            
            GediaoPublishSettingViewController *gediaoSettingVC=[[GediaoPublishSettingViewController alloc]init];
            gediaoSettingVC.delegate=self;
            [self.navigationController pushViewController:gediaoSettingVC animated:YES];
            
        }
        
    }];

}

//上传语音
- (void)upLoadyuyin:(NSArray *)array
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

//上传照片到七牛服务器

- (void)upLoadpicture:(NSDictionary *)dic
{
    QNUploadManager *upManager=[[QNUploadManager alloc]init];
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/uptoken/1"];
    [HttpTool get:string params:nil success:^(id responseobj) {
        
    UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
        

        for (int i=0; i<self.imageArray.count-1; i++)
        {
            UIImageView *imageView=self.imageArray[i];
            NSData *imageData=UIImagePNGRepresentation(imageView.image);
            
            [upManager  putData:imageData key:imageView.accessibilityValue token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                
                if (i==self.imageArray.count-2) {
                    
                    [self upLoadServer:dic];
                }
               
                
                //上传到自己的服务器
            } option:nil];
            
            
        }
        
    } failure:^(NSError *erronr) {
        
    }];
    
}

//上传到自己的服务器
- (void)upLoadServer:(NSDictionary *)dic
{
    
    [self.view beginLoading];
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"world/tag"];
    
    
    NSMutableArray *imageArray=[NSMutableArray array];

    for (int i=0; i<self.imageArray.count-1; i++) {
        UIImageView *imageView=self.imageArray[i];
        NSArray *labels=self.labelArray[i];
        NSMutableDictionary *imageDic=[NSMutableDictionary dictionary];
        [imageDic setValue:imageView.accessibilityValue forKey:@"image_name"];
        [imageDic setValue:labels forKey:@"labels"];
        [imageArray addObject:imageDic];
    }

    NSMutableDictionary *journal=[NSMutableDictionary dictionary];
    [journal setValue:self.titleField.text forKey:@"title_text_content"];
    [journal setValue:self.contentView.text forKey:@"text_content"];
    [journal setValue:imageArray forKey:@"images"];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:journal forKey:@"journal"];
    
    [params setValue:self.kindItem.position forKey:@"position"];
    
    if (dic!=nil) {
        [params setValue:dic forKey:@"yinsi"];
    }
     
    
    [HttpTool send:string params:params success:^(id responseobj) {
       
        [self.view endLoading];
       
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
        if (dic!=nil) {
            
            CLog(@"%@",dic);
            
            WorldTagIndexResult *worldIndex=[WorldTagIndexResult objectWithKeyValues:dic];
            [MBProgressHUD showError:worldIndex.prompt];
            
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
            }else{
                
                [menuVC buttonClicked:menuVC.styleButton];
                
                BaseNavigationController *styleSegNav = (BaseNavigationController *)(BaseNavigationController *)self.mm_drawerController.centerViewController;
                
                styleVC=[[RootViewController alloc]init];
                menuVC.styleVC=styleVC;
                styleSegNav.viewControllers=@[styleVC];
            }
            
        }else
        {
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        
    }];

}


- (void)textViewDidChange:(NSNotification *)notification
{
    
    self.navigationItem.rightBarButtonItem.enabled=(self.contentView.text.length!=0&&self.titleField.text.length!=0);
    
}

//触摸空白区域键盘退去

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleField resignFirstResponder];
    [self.contentView resignFirstResponder];
}

//监听完成按钮

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];return NO;
    }
    return YES;
}

- (void)gotoAlbum
{
    ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
    
//    KindItem *kind=[[KindItem alloc]init];
//    kind.kind=3;
    releaseVC.kind=self.kindItem;
    [self.navigationController pushViewController:releaseVC animated:YES];
}

//传照片过来

- (void)selectedImage:(UIImage *)image labels:(NSArray *)labels withyuyin:(NSArray *)yuyin
{
     NSString *image_name=[NSString stringWithFormat:@"%@.png",[self createRandomFigure]];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.accessibilityValue=image_name;
    imageView.image=image;
    
    [self.imageArray insertObject:imageView atIndex:0];
    
    [self.labelArray insertObject:labels atIndex:0];
    
    [self.yuyinArray addObjectsFromArray:yuyin];

    //每行最大列数
    int maxColPerRow=4;
    
    //每个图片之间的间距
    CGFloat margin=5;
    
    //每张图片的宽度
    CGFloat imageW=(kScreen_Width-(maxColPerRow+1)*margin)/maxColPerRow;
    //每张图片的高度
    CGFloat imageH=imageW;
    
    
    for (int i=0; i<self.imageArray.count; i++) {
        
        //行号
        int row=i/maxColPerRow;
        
        //列号
        int col=i%maxColPerRow;
        
        
        
        UIImageView *imageView=self.imageArray[i];
        
        imageView.frame=CGRectMake(col*(imageW+margin)+5, CGRectGetMaxY(self.contentView.frame)+5+row*(imageH+margin), imageW, imageH);
        [self.view addSubview:imageView];
    }


}


#pragma mark  GediaoPublishSettingViewControllerDelegate


-(void)Controller:(GediaoPublishSettingViewController *)controller disappear:(NSString *)date time:(NSString *)time isAnnoymity:(BOOL)isAnnoymity allowComment:(BOOL)comment showOnMap:(BOOL)showOnMap{
    
    
    
    NSMutableDictionary *journalDic=[NSMutableDictionary dictionary];
    [journalDic setValue:@1 forKey:@"over_type"];
    [journalDic setValue:date forKey:@"day"];
    [journalDic setValue:time forKey:@"time"];
    [journalDic setValue:[NSString stringWithFormat:@"%d",comment] forKey:@"if_can_comment"];
    [journalDic setValue:[NSString stringWithFormat:@"%d",isAnnoymity] forKey:@"if_anonymity"];
    [journalDic setValue:[NSString stringWithFormat:@"%d",showOnMap] forKey:@"if_see_map"];
    
    if (self.contentView.text.length>=10) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.yuyinArray.count>0) {
            [self upLoadyuyin:self.yuyinArray];
        }
        
        if (self.imageArray.count>1) {
            [self upLoadpicture:journalDic];
        }else{
            [self upLoadServer:journalDic];
        }
        
        
    }else{
        [MBProgressHUD showError:@"字数要大于300字"];
    }
    
 
    
    
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



@end
