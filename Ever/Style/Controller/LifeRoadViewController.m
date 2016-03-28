//
//  LifeRoadViewController.m
//  Ever
//
//  Created by Mac on 15-3-21.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//



#import "LifeRoadViewController.h"
#import "LifeListResult.h"
#import "LifeResult.h"
#import "PersonhomeViewController.h"
#import "TalkDetailViewController.h"
#import "GediaoDetailViewController.h"
#import "LifeRoadCell.h"

@interface LifeRoadViewController ()

@property (nonatomic , weak)  UIImageView *bgHeaderView,*avatarView,*clockIcon;

@property (nonatomic , weak)  UILabel *timeLabel,*nicknameLabel ;

@property (nonatomic , strong) LifeListResult *lifeList ;

@end

@implementation LifeRoadViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      //  self.view.backgroundColor=[UIColor whiteColor];
        self.title=@"生活轨迹";        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView=[self customTableHeaderView];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

}

- (UIView *)customTableHeaderView
{
    //背景图片
    UIImageView *bgHeaderView=[[UIImageView alloc]init];
    self.bgHeaderView=bgHeaderView;
    bgHeaderView.image=[UIImage imageNamed:@"personRoad"];
    bgHeaderView.frame=CGRectMake(0, 0, kScreen_Width,kScreen_Width-64);
    
    
    //名字
    UILabel *nicknameLabel=[[UILabel alloc]init];
    self.nicknameLabel=nicknameLabel;
    nicknameLabel.font=[UIFont systemFontOfSize:18];
    [bgHeaderView addSubview:nicknameLabel];
    
    //头像
    UIImageView *avatarView=[[UIImageView alloc]init];
    self.avatarView=avatarView;
    [avatarView doBorderWidth:2 color:[UIColor whiteColor] cornerRadius:30];
    [bgHeaderView addSubview:avatarView];
    
    //时钟头像
    UIImageView *clockIcon=[[UIImageView alloc]init];
    clockIcon.image=[UIImage imageNamed:@"time_clock_icon"];
    self.clockIcon=clockIcon;
    [bgHeaderView addSubview:clockIcon];
    
    //创建时间
    
    UILabel *timeLabel=[[UILabel alloc]init];
    self.timeLabel=timeLabel;
    [bgHeaderView addSubview:timeLabel];
    timeLabel.font=[UIFont systemFontOfSize:12];
    timeLabel.textColor=[UIColor whiteColor];
    return bgHeaderView;
}


-(void)setUserid:(long)userid
{
    NSString *string=[NSString stringWithFormat: @"user/life/%ld",userid];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        LifeListResult *lifeList=[LifeListResult objectWithKeyValues:responseobj];
        
        self.lifeList=lifeList;
        
        [self.tableView reloadData];
        
        [self setupInfo];
        
        
    } failure:^(NSError *erronr) {
        
    }];
    
    
}

- (void)setupInfo
{
    self.nicknameLabel.text=self.lifeList.user_nickname;
    self.nicknameLabel.textColor=[UIColor whiteColor];
    CGSize nickNameLabelSize=[self.nicknameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    
    self.nicknameLabel.frame=CGRectMake((kScreen_Width-nickNameLabelSize.width)*0.5, 20, nickNameLabelSize.width, 18);
    
  
    //头像
    NSString *avatarString=self.lifeList.user_head_image_url;
    NSURL *avatarurlString=[NSURL URLWithString:avatarString];
    [self.avatarView sd_setImageWithURL:avatarurlString placeholderImage:nil];
    self.avatarView.frame=CGRectMake(kScreen_Width*0.5-30, CGRectGetMaxY(self.nicknameLabel.frame)+5, 60, 60);
    
    //时钟
    self.clockIcon.frame=CGRectMake(kScreen_Width*0.5-6, CGRectGetMaxY(self.avatarView.frame)+5, 15, 15);
    
    //时间
    
    NSString *timestring=[NSString stringWithFormat:@"创建于:%@",self.lifeList.user_create_time];
    self.timeLabel.text=timestring;
    self.timeLabel.frame=CGRectMake(CGRectGetMaxX(self.clockIcon.frame)+4, CGRectGetMinY(self.clockIcon.frame), kScreen_Width*0.5-self.timeLabel.x, 12);
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return   self.lifeList.lifes.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"Roadcell";
    
    
    LifeResult *lifeResult=self.lifeList.lifes[indexPath.row];
   
    
    LifeRoadCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[LifeRoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.lifeResult=lifeResult;
    
   

    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LifeResult *lifeResult=self.lifeList.lifes[indexPath.row];
//    if (lifeResult.do_type==4||lifeResult.do_type==5) {
//        return 95;
//    }else
//    {
        return 135;
//    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LifeResult *lifeResult=self.lifeList.lifes[indexPath.row];
    
    switch (lifeResult.do_type) {
        case 1:
        {
            TalkDetailViewController *talkDetailVC=[[TalkDetailViewController alloc]init];
            talkDetailVC.talkid=lifeResult.cid;
            [self.navigationController pushViewController:talkDetailVC animated:YES];
            
        }
            break;
            
        case 2:
        {
           
            
        }
            break;
            
        case 3:
        {
            GediaoDetailViewController *gediaoDetailVC=[[GediaoDetailViewController alloc]init];
            gediaoDetailVC.gediaoid=lifeResult.cid;
            [self.navigationController pushViewController:gediaoDetailVC animated:YES];
            
        }
            break;
        default:
        {
            PersonhomeViewController *personVC=[[PersonhomeViewController alloc]init];
            personVC.user_id= lifeResult.cid;
            [self.navigationController pushViewController:personVC animated:YES];
            
        }
            
            break;
    }
   
   
}

@end
