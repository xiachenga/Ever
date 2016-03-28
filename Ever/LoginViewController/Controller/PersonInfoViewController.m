//
//  PersonInfoViewController.m
//  Ever
//
//  Created by Mac on 15-4-8.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UserInfo.h"
#import "PhoneNumRes.h"
#import "CustomSearchBar.h"
#import "CityListViewController.h"
#import "RecommendViewController.h"
#import "ReleaseaViewController.h"
#import <QiniuSDK.h>
#import "UptokenResult.h"

@interface PersonInfoViewController ()<UITextFieldDelegate,CityListViewCotrollerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//头像
@property(nonatomic,weak)UITapImageView *imageView;
@property (nonatomic , weak) UISegmentedControl *segment ;
@property (nonatomic , weak) CustomSearchBar *nickName ;

@property (nonatomic , weak)  CustomSearchBar *phoneNum ;

@property (nonatomic , weak) CustomSearchBar *cityName ;

@property (nonatomic , assign) int loginType;

@property (nonatomic , copy) NSString *avatarName;

@property (nonatomic , assign) BOOL avatarIsChanged;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
     [self addSubView];
    
    
    
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

}

/**
 *  添加子控件
 */
- (void)addSubView
{
    //头像
    UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake((kScreen_Width-60)*0.5, 70, 60, 60)];
    imageView.image=[UIImage imageNamed:@"avatarholder"];
    
    [imageView doCircleFrame];
    [imageView addTapBlock:^(id obj) {
        [self avatarClicked];
        
    }];
   
    self.imageView=imageView;
    [self.view addSubview:imageView];
    
    //男女
    
    NSArray *array=[[NSArray alloc]initWithObjects:@"男",@"女", nil];
    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:array];
    
    NSMutableDictionary *textAttrsHight=[NSMutableDictionary dictionary];
    textAttrsHight[NSForegroundColorAttributeName]=[UIColor whiteColor];
    textAttrsHight[NSFontAttributeName]=[UIFont systemFontOfSize:18];
    [segment setTitleTextAttributes:textAttrsHight forState:UIControlStateNormal];
    segment.tintColor=[UIColor blackColor];
    segment.backgroundColor=[UIColor grayColor];
    segment.layer.borderWidth=1;
    segment.layer.cornerRadius=5;
    segment.layer.masksToBounds=YES;
    segment.layer.borderColor=[UIColor grayColor].CGColor;
    
    segment.frame=CGRectMake((kScreen_Width-200)*0.5, CGRectGetMaxY(self.imageView.frame)+20, 200, 35);
    [self.view addSubview:segment];
    segment.selectedSegmentIndex=0;
    self.segment=segment;
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"进入ever后性别不能再更改";
    CGSize labelSize=[label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize:16];
    label.frame=CGRectMake((kScreen_Width-labelSize.width)*0.5, CGRectGetMaxY(segment.frame), kScreen_Width-40, 50);
    [self.view addSubview:label];
    
    
    CustomSearchBar *nickName=[CustomSearchBar searchBar];
    nickName.leftImageName=@"denglu_nicheng";
    nickName.placeholder=@"昵称(必填)";
    nickName.frame=CGRectMake(20, CGRectGetMaxY(label.frame)+10, kScreen_Width-40, 50);
    self.nickName=nickName;
    [self.view addSubview:nickName];
    
    CustomSearchBar *phoneNum=[CustomSearchBar searchBar];
    phoneNum.leftImageName=@"zhuce_qq";
    phoneNum.placeholder=@"QQ";
    self.phoneNum=phoneNum;
    phoneNum.clearButtonMode=UITextFieldViewModeAlways;
    phoneNum.frame=CGRectMake(20, CGRectGetMaxY(nickName.frame)+10, kScreen_Width-40, 50);
    phoneNum.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNum];
    
    
    CustomSearchBar *cityName=[CustomSearchBar searchBar];
    cityName.leftImageName=@"denglu_chengshi";
    cityName.delegate=self;
    cityName.placeholder=@"城市(必填)";
    self.cityName=cityName;
    cityName.frame=CGRectMake(20, CGRectGetMaxY(phoneNum.frame)+10, kScreen_Width-40, 50);
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"menu_right_back"] forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(kScreen_Width-40-36, 7, 36, 36)];
    [cityName addSubview:rightButton];
    [rightButton addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:cityName];
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage resizedImageWithName:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    CGFloat buttonX=kScreen_Width*0.5*0.5;
    CGFloat buttonW=kScreen_Width*0.5;
    CGFloat buttonH=50;
    button.layer.cornerRadius=5;
    button.layer.masksToBounds=YES;
    button.frame=CGRectMake(buttonX, CGRectGetMaxY(cityName.frame)+10, buttonW   , buttonH);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    }

- (void)setQquser:(UserInfo *)qquser
{
    _user=qquser;
    self.avatarName=qquser.profile_image_url;
    
    NSURL *imageUrl=[NSURL URLWithString:qquser.profile_image_url];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"zhuce_jia"]];
    
    if ([qquser.gender isEqualToString:@"男"]) {
        
    }else
    {
        self.segment.selectedSegmentIndex=1;
    }
    
    self.nickName.text=qquser.screen_name;
    
    self.loginType=2;
    
}


-(void)setWeiboUser:(UserInfo *)WeiboUser
{
    _user=WeiboUser;
    
    self.avatarName=WeiboUser.profile_image_url;
    
    NSURL *imageUrl=[NSURL URLWithString:WeiboUser.profile_image_url];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"zhuce_jia"]];
    
    long long genger=[WeiboUser.gender longLongValue];
    
    if (genger==1) {
        
        }else
    {
        self.segment.selectedSegmentIndex=1;
    }
    
    self.nickName.text=WeiboUser.screen_name;
    
    self.loginType=4;
}

//手机号码注册
-(void)setPhone:(PhoneNumRes *)phone {
    
    _phone=phone;
    self.loginType=1;
    
    
}

//获取城市列表
-(void)cityClicked
{
    
    CityListViewController *cityListVC=[[CityListViewController alloc]init];
    cityListVC.delegate=self;
    [self.navigationController pushViewController:cityListVC animated:YES];
    
}
- (void)trsnsmitLocation:(NSString *)cityName
{
    self.cityName.text=cityName;
}



- (void)nextStep
{

    //判断头像是否更改
    
    if (self.avatarIsChanged) {
        
        [self upLoadAvatarImageToqiniu];
    }

    //进行注册,设备唯一标示符
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    //男女
    int sex;
    if (self.segment.selectedSegmentIndex==0) {
         sex=1;
    }else
    {
         sex=2;
    }
    NSString *sexing=[NSString stringWithFormat:@"%d",sex];
    
    NSString *login_typeing=[NSString stringWithFormat:@"%d",self.loginType];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary ];
    
    [params setValue:self.phone.phoneNum forKey:@"tel"];
    [params setValue:self.phone.password forKey:@"pwd"];
    //设备唯一标示符
    [params setValue:identifierForVendor forKey:@"uuid"];
    [params setValue:self.phoneNum.text forKey:@"qqnum"];
    [params setValue:sexing forKey:@"sex"];
    [params setValue:self.avatarName forKey:@"head_image_name"];
    [params setValue:self.nickName.text forKey:@"nickname"];
    [params setValue:self.cityName.text forKey:@"city_name"];
    [params setValue:login_typeing forKey:@"login_type"];
    [params setValue:self.user.uid forKey:@"uid"];
 
     NSString *urlstring=[kSeverPrefix stringByAppendingString:@"user/reg"];
    if (self.nickName.text.length>10) {
        
        [MBProgressHUD showError:@"名字长度大于10"];
        
    }else if(self.nickName.text.length==0 ){
        [MBProgressHUD showError:@"名字不能为空"];
        
    }else
    {
        [HttpTool send:urlstring params:params success:^(id responseobj) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableLeaves error:nil];
            
            CLog(@"%@",dic);
            
            LoginResult *account=[LoginResult objectWithKeyValues:dic];
            [MBProgressHUD showError:account.prompt];
            
            [AccountTool save:account];
            
            RecommendViewController *recommentVC=[[RecommendViewController alloc]init];
            [self.navigationController pushViewController:recommentVC animated:YES];
            
        }];
    }
}

//设置头像
- (void)setImage:(UIImage *)image {
    
    self.imageView.image=image;
    
    self.avatarIsChanged=YES;
    
}

- (void)upLoadAvatarImageToqiniu
{
    NSString *image_name=[NSString stringWithFormat:@"%@.png",[self createRandomFigure]];
    NSData *imageData=UIImagePNGRepresentation(self.imageView.image);
    
    NSString *qiniuString=[kSeverPrefix stringByAppendingString:@"app/uptoken/2"];
    
    
    [HttpTool get:qiniuString params:nil success:^(id responseobj) {
        
        UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
        QNUploadManager *upManager=[[QNUploadManager alloc]init];
        
        
        [upManager  putData:imageData key:image_name token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            CLog(@"%d",info.isOK);
            
        } option:nil];
    } failure:^(NSError *erronr) {
        
    }];
}

//退出键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nickName resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    
}

//点击头像
- (void)avatarClicked
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    [actionSheet showInView:self.view];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self tokePhoto];
            break;
         case 1:
        {
            ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
            KindItem *kind=[[KindItem alloc]init];
            kind.kind=6;
            releaseVC.kind=kind;
            [self.navigationController pushViewController:releaseVC animated:YES];
        }
        default:
            
            break;
    }
}

//拍照
- (void)tokePhoto {
    
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
       [self presentViewController:picker animated:YES completion:^{
           
       }];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }

}

# pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    [self dismissModalViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        self.imageView.image=image;
        
    }];
    
    
}


- (NSString *)createRandomFigure
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


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    
}




@end
