//
//  CityListViewController.m
//  Ever
//
//  Created by Mac on 15-1-29.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CityListViewController.h"
#import "City.h"
#import "CityGroup.h"

@interface CityListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *myTableView;

//城市首字母
@property (nonatomic,strong) NSMutableArray *cityKeys;



@property (nonatomic , strong) NSMutableArray *citysArray;

@property (nonatomic , strong) NSArray *cityGroup;


@end

@implementation CityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title=@"城市";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.sectionIndexColor = kThemeColor;
    [self.view addSubview:tableView];
    self.myTableView=tableView;
    
    
    
    if (_cityGroup==nil)
    {
        _cityGroup=[NSArray array];
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"city" ofType:@"txt"];
        
        NSData *data=[NSData dataWithContentsOfFile:path];
        
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        _citysArray=[NSMutableArray array];
        _cityKeys=[NSMutableArray array];
        
        for (NSDictionary *dict in jsonObject)
        {
            CityGroup *cityGroup=[CityGroup cityGroupWithDic:dict];
            [_citysArray addObject:cityGroup];
            
            
            //城市首字母
            
            [_cityKeys addObject:cityGroup.firstWord];
            
        }
        
        
        _cityGroup=[_citysArray copy];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _citysArray.count;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    CityGroup *cityGroup=self.cityGroup[section];
    return cityGroup.citys.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        }
    
    
    CityGroup *cityGroup=self.cityGroup[indexPath.section];
    
    City *city=cityGroup.citys[indexPath.row];
    cell.textLabel.text=city.cityName;
    cell.backgroundColor=[UIColor whiteColor];
    
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return _cityKeys;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"f5f6f0"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kThemeColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key=((CityGroup *)_cityGroup[section]).firstWord;
    
    titleLabel.text=key;
    [bgView addSubview:titleLabel];
    
    return bgView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CityGroup *cityGroup=self.cityGroup[indexPath.section];
    
    City *city=cityGroup.citys[indexPath.row];
    NSString *cityName=city.cityName;
    
    if ([self.delegate respondsToSelector:@selector(trsnsmitLocation: )]) {
        [self.delegate trsnsmitLocation:cityName];
         [self.navigationController popViewControllerAnimated:YES];
        
    }

}


@end
