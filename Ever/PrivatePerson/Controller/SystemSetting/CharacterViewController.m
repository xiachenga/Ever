//
//  CharacterViewController.m
//  Ever
//
//  Created by Mac on 15-3-12.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CharacterViewController.h"

static NSString *key=@"characterSetting";

@interface CharacterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic , weak) UITableView *tableView;

@property (nonatomic , weak) UISwitch *roadSwitch,*yincangSwitch,*voiceSwitch,*shakeSwitch;

@property (nonatomic , weak) UILabel *road,*search,*voice,*shake,*push,*roadDetail,*searchDetail,*shakeDetail;

@end

@implementation CharacterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=LOCALIZATION(@"SystemCharacter");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //添加tableView
    [self setupTableView];
    
}

/**
 *  添加tableView
 */
- (void)setupTableView
{
    UITableView *tableView=[[UITableView alloc]init];
    tableView.frame=self.view.bounds;
    tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.dataSource=self;
    tableView.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark uitableDatasource uitableDelegte

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row=0;
    switch (section) {
        case 0:
            row=1;
            break;
         case 1:
            row=1;
            break;
         case 2:
            row=2;
            break;
//        case 3:
//            row=1;
//            break;
    }
    return row;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
     NSString *firstInto=[userDefaults objectForKey:key];
    
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

}
    switch (indexPath.section) {
        case 0:
        {
            UISwitch *roadSwitch=[[UISwitch alloc]init];
            roadSwitch.onTintColor=kThemeColor;
            roadSwitch.on=[userDefaults boolForKey:@"roadSwitch"];
            self.roadSwitch=roadSwitch;
            [roadSwitch addTarget:self action:@selector(individualSetting:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=roadSwitch;
            
           
            
            UILabel *roadLabel=[[UILabel alloc]init];
            roadLabel.text=LOCALIZATION(@"SystemPersonalityRoad");
            roadLabel.frame=CGRectMake(10, 0, kScreen_Width, 40);
            [cell.contentView addSubview:roadLabel];
            self.road=roadLabel;
            
        }
            break;
         case 1:
        {
            UISwitch *yincangSwitch=[[UISwitch alloc]init];
            yincangSwitch.onTintColor=kThemeColor;
            self.yincangSwitch=yincangSwitch;
            yincangSwitch.on=[userDefaults boolForKey:@"yincangSwitch"];
        
            
            cell.accessoryView=yincangSwitch;
            [yincangSwitch addTarget:self action:@selector(individualSetting:) forControlEvents:UIControlEventValueChanged];
            UILabel *search=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width, 40)];
            search.text=LOCALIZATION(@"SystemPersonalitySearch");
            [cell.contentView addSubview:search];
            self.search=search;
        }
            
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    UISwitch *voiceSwitch=[[UISwitch alloc]init];
                    voiceSwitch.onTintColor=kThemeColor;
                    self.voiceSwitch=voiceSwitch;
                    
                    //判断是否第一次进入
                  
                    if ([firstInto isEqualToString:@"1"]) {
                       voiceSwitch.on=[userDefaults boolForKey:@"voiceSwitch"];
                        
                    }else{
                         voiceSwitch.on=YES;
                        
                    }
                    cell.accessoryView=voiceSwitch;
                    
                    UILabel *voice=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width, 40)];
                    voice.text=LOCALIZATION(@"SystemPersonalityVoice");
                    [cell.contentView addSubview:voice];
                    self.voice=voice;
                }
                   
                    break;
                    
                default:
                {
                    UISwitch *shakeSwitch=[[UISwitch alloc]init];
                    shakeSwitch.onTintColor=kThemeColor;
                    self.shakeSwitch=shakeSwitch;
                    
                    if ([firstInto isEqualToString:@"1"]) {
                         shakeSwitch.on=[userDefaults boolForKey:@"shakeSwitch"];
                        
                        
                    }else{
                        shakeSwitch.on=YES;
                        
                    }
                   
                    cell.accessoryView=shakeSwitch;
                    
                    
                    UILabel *shake=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width, 40)];
                    shake.text=LOCALIZATION(@"SystemPersonalityShake");
                    [cell.contentView addSubview:shake];
                    self.shake=shake;
                    
                }
                    
                    break;
            }
            break;

    }
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell addLineUp:YES andDown:YES];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
   
    switch (section) {
        case 0:
            
        {
            UILabel *roadDetail=[[UILabel alloc]init];
            roadDetail.text=LOCALIZATION(@"SystemPersonalityRoadDetail");
          
            roadDetail.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
            roadDetail.numberOfLines=0;
            roadDetail.textColor=[UIColor grayColor];
            roadDetail.font=[UIFont systemFontOfSize:15];
          
            self.roadDetail=roadDetail;
            return roadDetail;
        }
            
            break;
        case 1:
        {
            UILabel *searchDetail=[[UILabel alloc]init];
            searchDetail.text=LOCALIZATION(@"SystemPersonalityRoadSearchDetail");
            
            searchDetail.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
            searchDetail.numberOfLines=0;
            searchDetail.font=[UIFont systemFontOfSize:15];
            searchDetail.textColor=[UIColor grayColor];
            
            self.searchDetail=searchDetail;
            return searchDetail;
            
        }
            
            break;
        case 2:
        {
            UILabel *shakeDetail=[[UILabel alloc]init];
           shakeDetail.text=LOCALIZATION(@"SystemPersonalityRoadShakeDetail");
      
            shakeDetail.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
            shakeDetail.numberOfLines=0;
            shakeDetail.textColor=[UIColor grayColor];
            shakeDetail.font=[UIFont systemFontOfSize:15];
       
            self.shakeDetail=shakeDetail;
            return shakeDetail;
            
        }
           
            break;
         case 3:
    
            return NO;
    }
    return nil;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:self.roadSwitch.isOn forKey:@"roadSwitch"];
    [userDefaults setBool:self.yincangSwitch.isOn forKey:@"yincangSwitch"];
    [userDefaults setBool:self.voiceSwitch.isOn forKey:@"voiceSwitch"];
    [userDefaults setBool:self.shakeSwitch.isOn forKey:@"shakeSwitch"];
    
    //判断是否第一次进入这个界面1代表进入过
    [userDefaults setObject:[NSString stringWithFormat:@"1"] forKey:key];
    
    [userDefaults synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

//个性化设置
- (void)individualSetting:(UISwitch *) sender
{
    

    if ([AccountTool isLogin]) {
        
        NSString *string=[kSeverPrefix stringByAppendingString:@"user/setting"];
        
        
        
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        
        [params setValue:[NSString stringWithFormat:@"%d",!self.roadSwitch.isOn] forKey:@"can_see_center"];
        [params setValue:[NSString stringWithFormat:@"%d",!self.yincangSwitch.isOn] forKey:@"can_search"];
        
        
        [HttpTool send:string params:params success:^(id responseobj) {
            CLog(@"%@",responseobj);
            
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
            NormalResult *result=[NormalResult objectWithKeyValues:dic];
            [MBProgressHUD showError:result.prompt];
           
            
        }];
        
    }else{
        
        [sender setOn:NO];
        
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
    
    
    
    
}

- (void)languageChange
{
    CLog(@"收到通知");
    
    self.title=LOCALIZATION(@"SystemCharacter");
    self.road.text=LOCALIZATION(@"SystemPersonalityRoad");
    self.search.text=LOCALIZATION(@"SystemPersonalitySearch");

    self.voice.text=LOCALIZATION(@"SystemPersonalityVoice");

    self.shake.text=LOCALIZATION(@"SystemPersonalityShake");

    self.push.text=LOCALIZATION(@"SystemPersonalityPush");
    
    self.roadDetail.text=LOCALIZATION(@"SystemPersonalityRoadDetail");
    self.searchDetail.text=LOCALIZATION(@"SystemPersonalityRoadSearchDetail");
    self.shakeDetail.text=LOCALIZATION(@"SystemPersonalityRoadShakeDetail");
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}



@end
