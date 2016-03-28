//
//  SystemSettingViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "CharacterViewController.h"
#import "SelectLanguageViewController.h"
#import "CEOViewController.h"
@interface SystemSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , weak) UITableView *tableView;

@property (nonatomic , weak) UILabel *personality,*language,*update,*Aboutus,*clearCache;
@property (nonatomic , weak) UIButton *quitBtn;
@end

@implementation SystemSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        self.title=LOCALIZATION(@"GlobalFoldMenuSetting");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //创建tableView
    [self setupTableView];
    
    //创建退出按钮
    [self setupQuitButton];
    
    //隐藏系统多余的分割线
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    
    
}

/**
 *  创建TableView
 */
- (void)setupTableView
{
    UITableView *tableView=[[UITableView alloc]init];
    tableView.frame=self.view.bounds;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:tableView];
}

/**
 *  创建退出按钮
 */

- (void)setupQuitButton
{
    
    UIButton *quitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [quitButton setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang_selected"] forState:UIControlStateHighlighted];
    quitButton.frame=CGRectMake(10, 300, kScreen_Width-2*10, 40);
    [quitButton setTitle:LOCALIZATION(@"SystemQuitBtn") forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.quitBtn=quitButton;
    [self.tableView addSubview:quitButton];
    
}

#pragma UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row=0;
    switch (section) {
        case 0:
            row=3;
            break;
            
        default:
            row=1;
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
        {
                case 0:
            {
                UILabel *personality=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 40)];
                personality.text=LOCALIZATION(@"SystemCharacter");
                self.personality=personality;
                [cell.contentView addSubview:personality];
            }
                
                    break;
                 case 1:
            {
                UILabel *language=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 40)];
                language.text=LOCALIZATION(@"SystemLanguageChange");
                self.language=language;
                [cell.contentView addSubview:language];
            }
                    break;
                case 2:
            {
                
                
                UILabel *clearCache=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 40)];
                clearCache.text=LOCALIZATION(@"SystemClearCache");
                self.clearCache=clearCache;
                [cell.contentView addSubview:clearCache];

//                UILabel *update=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 40)];
//                update.text=LOCALIZATION(@"SystemUpdate");
//                self.update=update;
//                [cell.contentView addSubview:update];
                
            }
                break;
//                
//                case 3:
//            {
//                UILabel *clearCache=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 40)];
//                clearCache.text=LOCALIZATION(@"SystemClearCache");
//                self.clearCache=clearCache;
//                [cell.contentView addSubview:clearCache];
//            }
//                
//            break;
                
        }
            break;
        default:
            
        {
           
            UILabel *aboutUs=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 40)];
            aboutUs.text=LOCALIZATION(@"SystemAboutUs");
            self.Aboutus=aboutUs;
            [cell.contentView addSubview:aboutUs];
        }
            
            break;
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    [cell addLineUp:YES andDown:YES];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//取消选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    CharacterViewController *characterVC=[[CharacterViewController alloc]init];
                    [self.navigationController pushViewController:characterVC animated:YES];
                }
                    break;
                case 1:
                {
                    SelectLanguageViewController *selectlanguageVC=[[SelectLanguageViewController alloc]init];
                    [self.navigationController pushViewController:selectlanguageVC animated:YES];
                    
                }
                    break;
                    
                 case 2:
                {
                    
                    [[SDImageCache sharedImageCache] clearDisk];
                    [MBProgressHUD showError:@"清除完毕"];
                    
//                  [MBProgressHUD showError:@"没有最新版本"];
                }
                    break;
//                case 3:
//                {
//                   [[SDImageCache sharedImageCache] clearDisk];  
//                   [MBProgressHUD showError:@"清除完毕"];
//                }
//                    break;
            }
            
            
        }
            break;
           
          
            case 1:
        {
            CEOViewController *ceoVC=[[CEOViewController alloc]init];
            [self.navigationController pushViewController:ceoVC animated:YES];
            
        }
            break;
        
    }
}


- (void)quitButtonClicked
{
 

    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:AccountFilepath error:nil];
    
    [GoIntoMainScreen  gotoLogin];
    
}

- (void)languageChange
{
    
    self.title=LOCALIZATION(@"GlobalFoldMenuSetting");
    
    self.personality.text=LOCALIZATION(@"SystemCharacter");
    self.language.text=LOCALIZATION(@"SystemLanguageChange");
    self.update.text=LOCALIZATION(@"SystemUpdate");
    self.clearCache.text=LOCALIZATION(@"SystemClearCache");
    self.Aboutus.text=LOCALIZATION(@"SystemAboutUs");
    [self.quitBtn setTitle:LOCALIZATION(@"SystemQuitBtn") forState:UIControlStateNormal];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}

@end
