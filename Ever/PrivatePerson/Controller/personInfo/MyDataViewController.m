//
//  MyDataViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "MyDataViewController.h"
#import "CityListViewController.h"
#import "ReleaseaViewController.h"
#import "UptokenResult.h"
#import "DatePickerView.h"
#import <QiniuSDK.h>

@interface MyDataViewController ()<CityListViewCotrollerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DatePickerViewDelegate>

@property (nonatomic , weak) UILabel *showTimeLabel,*cityLabel,*birthLabel;

@property (nonatomic , weak) UILabel *sign,*birth,*phone,*email,*name,*city,*address;
@property (nonatomic , weak) UIView *backgroundView,*dateView;

@property (nonatomic , weak) UIButton *saveBtn;

@property (nonatomic , weak) UITableView *myTableView;

@property (nonatomic , weak) UIImageView *avatrView;

//判断头像是否改变
@property (nonatomic , strong) NSData *imageData;

@property (nonatomic , copy) NSString *birthDate;


@property (nonatomic , weak) UITextField *signField,*phoneField,*mailField,*nameField,*addressField;

@property (nonatomic , strong) LoginResult *account;

@property (nonatomic , copy) NSString *avatarPath;


@end

@implementation MyDataViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=LOCALIZATION(@"MyDataTitle");
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //创建导航栏上面的右边的item
    
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(0, 0, 40, 30);
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setTitle:LOCALIZATION(@"MyDataSaveBtn") forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn=saveBtn;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    
    //重新加载个人数据
    
  //  [self reloadPersonData];
  
    [self addMytableView];
    
}

//重新刷新数据
//- (void)reloadPersonData {
//    
//    NSString *string=[kSeverPrefix stringByAppendingString:@"user/tmn"];
//    [HttpTool get:string params:nil success:^(id responseobj) {
//        
//        LoginResult *account=[LoginResult objectWithKeyValues:responseobj];
//        
//        [AccountTool save:account];
//    } failure:^(NSError *erronr) {
//        
//    }];
//    
//    
//}

- (void)addMytableView
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
 
    self.myTableView=tableView;
    [self.view addSubview:tableView];
    
    tableView.tableHeaderView=[self addHeaderView];
    
    [tableView reloadData];

}

//添加头部的TableVieWheader
- (UIImageView *)addHeaderView
{
    LoginResult *account=[AccountTool account];
    NSString *string=account.user_head_image_url;
    
    //headView
    UIImageView *headerView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width-64)];
    headerView.image=[UIImage imageNamed:@"myData_bg"];
    headerView.userInteractionEnabled=YES;
    
    //头像
    UITapImageView *avatarView=[[UITapImageView alloc]initWithFrame:CGRectMake((kScreen_Width-60)*0.5, 20, 60, 60)];
    [avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:30];
    self.avatrView=avatarView;
    self.avatarPath=account.user_head_image_url;
    [avatarView addTapBlock:^(id obj) {
        
        [self gotoAlbum];
        
    }];
    
    [avatarView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    
    NSData *imageData=UIImagePNGRepresentation(self.avatrView.image);
    
    self.imageData=imageData;
    
    [headerView addSubview:avatarView];
    
    
    //昵称
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=account.user_nickname;
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(avatarView.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 20));
    
    }];

   
    
    //ever
    UILabel *everLabel=[[UILabel alloc]init];
    everLabel.textColor=[UIColor whiteColor];
    everLabel.font=[UIFont systemFontOfSize:15];
    everLabel.text=[NSString stringWithFormat:@" Ever:%ld",account.user_id];
    everLabel.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:everLabel];
    [everLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 20));
        
    }];
    //魅力
    UILabel *meiliLabel=[[UILabel alloc]init];
    meiliLabel.textColor=[UIColor whiteColor];
    meiliLabel.font=[UIFont systemFontOfSize:15];
    meiliLabel.textAlignment=NSTextAlignmentCenter;
    meiliLabel.text=[NSString stringWithFormat:@"魅力值:%d",account.meili_num];
    [headerView addSubview:meiliLabel];
    [meiliLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(everLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 20));
        
    }];
  
    return headerView;
}

//设置生日
- (void)dateLabelClicked
{
    
    DatePickerView *datePickerView=[[DatePickerView alloc]initDateViewWithFrame:self.view.bounds WithDateType:UIDatePickerModeDate];
    datePickerView.delegate=self;
    [self.view addSubview:datePickerView];

}

#pragma mark CityListViewControllerDelegate

-(void)trsnsmitLocation:(NSString *)cityName
{
   self.cityLabel.text=cityName;
    
}


#pragma mark UITextFieldDelegage


//保存
- (void)saveBtnClicked:(id)sender
{
    
    //上传至七牛服务器
    
     NSData *imageData=UIImagePNGRepresentation(self.avatrView.image);
    
     if ([self.imageData isEqualToData:imageData]) {
        
        CLog(@"两张一样");
         
         [self upLoadPersonData];
        
    }else{
        CLog(@"两个不一样");
        
        [self upLoadAvatarImageToqiniu:(NSData *)imageData];
        [self upLoadPersonData];
    }

}

//上传个人资料
- (void)upLoadPersonData
{
    //判断是否改变
    
    LoginResult *account=[AccountTool account];
    
  
    
    if ([self.signField.text isEqualToString:account.description_content]&&[self.birthDate isEqualToString:self.birthLabel.text]&&[self.phoneField.text  isEqualToString:account.telephone]&&[self.mailField.text isEqualToString:account.email]&&[self.nameField.text isEqualToString:account.real_name ]&&[self.cityLabel.text  isEqualToString:account.city]&&[self.addressField.text  isEqualToString:account.detail_address]) {
        
        
        
        CLog(@"资料没有修改");
        
        
        
    }else
    {
        CLog(@"资料修改");
        
   
        [self.view beginLoading];
        
        NSString *string=[kSeverPrefix stringByAppendingString:@"user/info"];
        
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate* date = [formatter dateFromString:self.birthLabel.text]; //------------将字符串按formatter转成nsdate
        NSString *birth=[NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        
        
        [params setValue:self.signField.text forKey:@"description"];
        [params setValue:birth forKey:@"birthday_time_stamp"];
        [params setValue:self.phoneField.text forKey:@"telephone"];
        [params setValue:self.mailField.text forKey:@"email"];
       
        if (self.nameField.text==nil) {
         [params setValue:account.real_name forKey:@"real_name"];
        }else{
            [params setValue:self.nameField.text forKey:@"real_name"];
        }
        
        if (self.cityLabel.text==nil) {
            [params setValue:account.city forKey:@"city_name"];
        }else{
            [params setValue:self.cityLabel.text forKey:@"city_name"];
        }
        
        if (self.nameField.text==nil) {
            [params setValue:account.real_name forKey:@"detail_address"];
        }else{
            [params setValue:self.addressField.text forKey:@"detail_address"];
        }

        
        [HttpTool send:string params:params success:^(id responseobj) {
            
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
            
            [self.view endLoading];
            
            [MBProgressHUD showError:@"修改成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (dic!=nil) {
                
                LoginResult *account=[LoginResult objectWithKeyValues:dic];
                

                
                [AccountTool save:account];
                
            }
            
        }];
    }
    
        
}

- (void)upLoadAvatarImageToqiniu:(NSData *)imageData
{
      NSString *image_name=[NSString stringWithFormat:@"%@.png",[self createRandomFigure]];
    
      NSString *qiniuString=[kSeverPrefix stringByAppendingString:@"app/uptoken/2"];
    
    
        [HttpTool get:qiniuString params:nil success:^(id responseobj) {
    
            UptokenResult *upTokenResult=[UptokenResult objectWithKeyValues:responseobj];
            QNUploadManager *upManager=[[QNUploadManager alloc]init];
    
    
            [upManager  putData:imageData key:image_name token:upTokenResult.uptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
    
                CLog(@"%d",info.isOK);
                
                [self uploadAvatar:image_name];
    
            } option:nil];
        } failure:^(NSError *erronr) {
            
        }];
}
//上传到自己的服务器
- (void)uploadAvatar:(NSString *)avatarName
{
    [self.view beginLoading];
    
    LoginResult *account=[AccountTool account];
    
    NSString *string=[kSeverPrefix stringByAppendingString:@"user/update_headimage"];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:avatarName forKey:@"email"];
    [HttpTool send:string params:params success:^(id responseobj) {
        
        
        [self.view endLoading];
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *imagePath=[dic objectForKey:@"fileurl"];
        
        [account setValue:imagePath forKey:@"user_head_image_url"];
        
        [AccountTool save:account];
        
        [MBProgressHUD showError:@"修改成功"];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAvatarImageChanged object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}


-(void)dealloc
{
    self.myTableView.delegate=nil;
    self.myTableView.dataSource=nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}


#pragma mark Table M
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (section == 0) {
        row = 4;
    }else {
        row = 3;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LoginResult *account=[AccountTool account];
    
    
    static NSString *identifier=@"kCellIdentifier_UserInfoTextCell";
  
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    CGFloat leftMargin=5;

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    UILabel *sign=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 80, 44)];
                    sign.text=LOCALIZATION(@"MyDataSignature");
                    [cell.contentView addSubview:sign];
                    self.sign=sign;
                    
                    
                    UITextField *signField=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-60, 44)];
                    signField.returnKeyType=UIReturnKeyDone;
                    signField.text=account.description_content;
                    signField.delegate=self;
                    signField.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    self.signField=signField;
                    [cell.contentView addSubview:signField];
                }
                    break;
                    
                case 1:
                {
                    
                    UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 80, 44)];
                    birth.text=LOCALIZATION(@"MyDataBirthday");
                    [cell.contentView addSubview:birth];
                    self.birth=birth;
                    
                    NSDate *date=[NSDate dateWithTimeIntervalSince1970:account.birthday_time_stamp];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *dateString = [dateFormatter stringFromDate:date];
                    self.birthDate=dateString;
                   
                    UILabel *birthLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-60, 44)];
                    birthLabel.text=dateString;
                    self.birthLabel=birthLabel;
                    self.birthLabel.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    [cell.contentView addSubview:birthLabel];
                    
                }
                    break;
                case 2:
                    
                {
                    UILabel *phone=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 80, 44)];
                    phone.text=LOCALIZATION(@"MyDataTel");
                    [cell.contentView addSubview:phone];
                    self.phone=phone;
                    
                    UITextField *phoneField=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-60, 44)];
                    self.phoneField=phoneField;
                    phoneField.text=account.telephone;
                    phoneField.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    phoneField.keyboardType=UIKeyboardTypePhonePad;
                    
                    [cell.contentView addSubview:phoneField];
                }
                    break;
                case 3:
                {
                    
                    UILabel *mail=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 80, 44)];
                    mail.text=LOCALIZATION(@"MyDataEmail");
                    [cell.contentView addSubview:mail];
                    self.email=mail;
                    
                    UITextField *mailField=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-60, 44)];
                    self.mailField=mailField;
                    mailField.text=account.email;
                    mailField.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    mailField.keyboardType=UIKeyboardTypeEmailAddress;
                    mailField.delegate=self;
                    mailField.returnKeyType=UIReturnKeyDone;
                    [cell.contentView addSubview:mailField];
                }
                    break;
            }
            break;
            
        default:
            switch (indexPath.row) {
                case 0:
                {
                    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 100, 44)];
                    name.text=LOCALIZATION(@"MyDataRealName");
                    [cell.contentView addSubview:name];
                    self.name=name;
                    
                    UITextField *nameField=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-90, 44)];
                    nameField.returnKeyType=UIReturnKeyDone;
                    nameField.text=account.real_name;
                    nameField.delegate=self;
                    nameField.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    self.nameField=nameField;
                    
                    [cell.contentView addSubview:nameField];
                }
                    break;
                    
                case 1:
                {
                    UILabel *city=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 80, 44)];
                    city.text=LOCALIZATION(@"MyDataCity");
                    [cell.contentView addSubview:city];
                    self.city=city;
                    
                    UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-90, 44)];
                    self.cityLabel=cityLabel;
                    cityLabel.text=account.city;
                    cityLabel.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    
                    [cell.contentView addSubview:cityLabel];
                    
                }
                    break;
                    
                    case 2:
                {
                    UILabel *addRess=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, 80, 44)];
                    addRess.text=LOCALIZATION(@"MyDataAddress");
                    [cell.contentView addSubview:addRess];
                    
                    self.address=addRess;
                    
                    UITextField *addressField=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-90, 44)];
                    addressField.returnKeyType=UIReturnKeyDone;
                    addressField.text=account.detail_address;
                    addressField.delegate=self;
                    addressField.textColor=[UIColor colorWithHexString:@"aaaaaa"];
                    
                    self.addressField=addressField;
                    [cell.contentView addSubview:addressField];

                }
            }
            break;
            
    }

    [cell addLineUp:YES andDown:YES];
    
    //设置个人信息
    cell.backgroundColor=[UIColor whiteColor];

    return cell;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.5;
    }else{
       
        return 2;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            [self  dateLabelClicked];
        }
    }else{
        if (indexPath.row==1) {
            CityListViewController *cityListVC =[[CityListViewController alloc]init];
            cityListVC.delegate=self;
            [self.navigationController pushViewController:cityListVC animated:YES];
        }
    }
    
}

- (void)gotoAlbum
{
    ReleaseaViewController *pictureAlbum=[[ReleaseaViewController alloc]init];
    
    KindItem *kind=[[KindItem alloc]init];
    kind.kind=4;
    
    pictureAlbum.kind=kind;
    [self.navigationController pushViewController:pictureAlbum animated:YES];
    
}



#pragma mark DatePickerView
-(void)datePickerView:(DatePickerView *)datePickerView didSelectTime:(NSString *)time{
    
   
   self.birthLabel.text=time;
    
}


#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.signField resignFirstResponder];
    [self.mailField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.addressField resignFirstResponder];
    return YES;
}

//改变头像
-(void)setImage:(UIImage *)image
{
    self.avatrView.image=image;
    
}

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


- (void)languageChange
{
    CLog(@"收到通知");
    
//    self.title=@"a;sdjf";
    
    self.title=LOCALIZATION(@"MyDataTitle");
    
    self.sign.text=LOCALIZATION(@"MyDataSignature");
    self.birth.text=LOCALIZATION(@"MyDataBirthday");
    self.phone.text=LOCALIZATION(@"MyDataTel");
    self.email.text=LOCALIZATION(@"MyDataEmail");
    self.name.text=LOCALIZATION(@"MyDataRealName");
    self.city.text=LOCALIZATION(@"MyDataCity");
    self.address.text=LOCALIZATION(@"MyDataAddress");
    [self.saveBtn setTitle:LOCALIZATION(@"MyDataSaveBtn") forState:UIControlStateNormal];
}





@end
