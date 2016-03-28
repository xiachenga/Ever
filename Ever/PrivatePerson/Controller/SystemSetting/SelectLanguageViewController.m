//
//  SelectLanguageViewController.m
//  Ever
//
//  Created by Mac on 15-3-12.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#define kSelectedLanguageIndex  @"kSaveLanguageDefaultKey"

#import "SelectLanguageViewController.h"
#import "Localisator.h"

@interface SelectLanguageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , weak) UITableView *tableView;
@property (nonatomic , assign) NSInteger index;
@end

@implementation SelectLanguageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    self.title=LOCALIZATION(@"SystemLanguageChoose");
    
    //创建UITableView
    [self setupTableView];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
}


//创建TableView
- (void)setupTableView
{
    
    UITableView *tableView=[[UITableView alloc]init];
    tableView.frame=self.view.bounds;
    tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
}



#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell  *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"中文";
           
            break;
            
        default:
            
            cell.textLabel.text=@"English";
            
            break;
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   
    NSString *language=[defaults objectForKey:kSaveLanguageDefaultKey];
    
    if ([language isEqualToString:@"Chinese"]) {
        
        if (indexPath.row==0) {
            
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
    }else
    {
        if (indexPath.row==1) {
            
            self.index=1;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
    }
    
    //默认为0行
    
    [cell addLineUp:NO andDown:YES];
    cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
    
}


//取消选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *lastIndex=[NSIndexPath indexPathForRow:_index inSection:0];
    UITableViewCell *lastCell=[tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryType=UITableViewCellAccessoryNone;
    
    //选中操作
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    //保存选中的
    _index=indexPath.row;
    
    [defaults setObject:[NSString stringWithFormat:@"%d",self.index] forKey:kSelectedLanguageIndex];
    
    switch (indexPath.row) {
            
        case 0:
        {
            [[Localisator sharedInstance]setLanguage:@"Chinese"];
            
            [defaults setObject:@"Chinese" forKey:kSaveLanguageDefaultKey];
        }
            break;
            
        default:
            
        {
             [[Localisator sharedInstance]setLanguage:@"English"];
             [defaults setObject:@"English" forKey:kSaveLanguageDefaultKey];
        }
            
            [defaults synchronize];
            
            
            break;
    }
    
}


- (void)languageChange
{
    CLog(@"收到通知");
    
    self.title=LOCALIZATION(@"SystemLanguageChoose");
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}

@end
