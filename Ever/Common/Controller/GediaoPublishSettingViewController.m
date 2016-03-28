//
//  GediaoPublishSettingViewController.m
//  Ever
//
//  Created by Mac on 15/7/9.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "GediaoPublishSettingViewController.h"
#import "DatePickerView.h"

@interface GediaoPublishSettingViewController ()<DatePickerViewDelegate>

@property (nonatomic , weak) UILabel *disappearDate,*time;

@property (nonatomic , weak) UISwitch *showCommentSwitch,*allowCommentSwitch,*annoymitySwitch;

@end

@implementation GediaoPublishSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=LOCALIZATION(@"PublishGediaoTitle");
    

    //没有选中效果
    self.tableView.allowsSelection=NO;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:LOCALIZATION(@"PublishGediao") style: UIBarButtonItemStylePlain  target:self action:@selector(sureBtnClicked)];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
       
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

   
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"gediaoSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CGFloat leftMargin=10;
    CGFloat topMargin=13;
    
    switch (indexPath.section) {
        case 0:
        {
            UILabel *disappearLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin,150, 20)];
            disappearLabel.text=LOCALIZATION(@"DisappearDate");
            [cell.contentView addSubview:disappearLabel];
            
            
            UILabel *disappearDate=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(disappearLabel.frame), CGRectGetMinY(disappearLabel.frame), 100, 20)];
            disappearDate.textColor=[UIColor grayColor];
            self.disappearDate=disappearDate;
            [cell.contentView addSubview:disappearDate];
            
           
            
            
            UIButton *dateBtn=[[UIButton alloc]init];
            dateBtn.size=CGSizeMake(20, 20);
            [dateBtn setImage:[UIImage imageNamed:@"yuehoujifen_date"] forState:UIControlStateNormal];
            [dateBtn addTarget:self action:@selector(dataBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=dateBtn;
            
        }
            break;
        case 1:
        {
            UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(  leftMargin, topMargin, 150, 20)];
            timeLabel.text=LOCALIZATION(@"DisappearTime");
            [cell.contentView addSubview:timeLabel];
            
            UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame), CGRectGetMinY(timeLabel.frame), 100, 20)];
            time.textColor=[UIColor grayColor];
            self.time=time;
            [cell.contentView addSubview:time];
            
            
            UIButton *timeBtn=[[UIButton alloc]init];
            timeBtn.size=CGSizeMake(20, 20);
            [timeBtn addTarget:self action:@selector(timeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [timeBtn setImage:[UIImage imageNamed:@"yuehoujifen_time"] forState:UIControlStateNormal];
            cell.accessoryView=timeBtn;
            
            
        }
            break;
        case 2:
        {
            UILabel *annoymityLabel=[[UILabel alloc]initWithFrame:CGRectMake(  leftMargin, topMargin, 150, 20)];
            annoymityLabel.text=LOCALIZATION(@"OpenAnnoymity");
            [cell.contentView addSubview:annoymityLabel];
            
            UISwitch *annoymitySwitch=[[UISwitch alloc]init];
            annoymitySwitch.onTintColor=kThemeColor;
            self.annoymitySwitch=annoymitySwitch;
        
            cell.accessoryView=annoymitySwitch;
            
            
        }
        
            break;
        
         case 3:
        {
            UILabel *allowCommentLabel=[[UILabel alloc]initWithFrame:CGRectMake(  leftMargin, topMargin, 150, 20)];
            allowCommentLabel.text=LOCALIZATION(@"AllowComment");
            [cell.contentView addSubview:allowCommentLabel];
            
            UISwitch *allowCommentSwitch=[[UISwitch alloc]init];
            allowCommentSwitch.onTintColor=kThemeColor;
            [allowCommentSwitch setOn:YES];
            self.allowCommentSwitch=allowCommentSwitch;
            cell.accessoryView=allowCommentSwitch;
            
            
        }
            break;
            
         case 4:
        {
            UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(  leftMargin, topMargin, 150, 20)];
            showLabel.text=LOCALIZATION(@"ShowOnMap");
            [cell.contentView addSubview:showLabel];
            
            
            UISwitch *showCommentSwitch=[[UISwitch alloc]init];
            showCommentSwitch.onTintColor=kThemeColor;
            [showCommentSwitch setOn:YES];
            self.showCommentSwitch=showCommentSwitch;
            cell.accessoryView=showCommentSwitch;
        }
        default:
            break;
    }
   
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat leftMargin=10;
    CGFloat topMargin=7;
    CGFloat width=kScreen_Width-10;
    CGFloat height=15;
    
    switch (section) {
        case 0:
        {
            UILabel *detailDisLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
            detailDisLabel.font=[UIFont systemFontOfSize:15];
            detailDisLabel.textColor=[UIColor grayColor];
            detailDisLabel.text=LOCALIZATION(@"hint_disapper_date");
            return detailDisLabel;
            
        }
            break;
         case 1:
        {
            UILabel *detailTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
            detailTimeLabel.font=[UIFont systemFontOfSize:15];
            detailTimeLabel.textColor=[UIColor grayColor];
            detailTimeLabel.text=LOCALIZATION(@"hint_disapper_time");
            return detailTimeLabel;
        }
            break;
            
          case 2:
        {
            UILabel *detailAnnoymityLabel=[[UILabel alloc]init];
            detailAnnoymityLabel.font=[UIFont systemFontOfSize:15];
            detailAnnoymityLabel.textColor=[UIColor grayColor];
            detailAnnoymityLabel.text=LOCALIZATION(@"hint_open_niming");
//            CGSize detailAnnoymityLabelSize=[detailAnnoymityLabel.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            detailAnnoymityLabel.numberOfLines=0;
//            detailAnnoymityLabel.frame=CGRectMake(0, 0, detailAnnoymityLabelSize.width, detailAnnoymityLabelSize.height);
            return detailAnnoymityLabel;
            
        }
            break;
            case 3:
        {
            UILabel *detailAllowCommentLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
            detailAllowCommentLabel.font=[UIFont systemFontOfSize:15];
            detailAllowCommentLabel.text=LOCALIZATION(@"hint_allow_comment");
            detailAllowCommentLabel.numberOfLines=0;
            detailAllowCommentLabel.textColor=[UIColor grayColor];
            return detailAllowCommentLabel;
            
        }
            break;
           case 4:
        {
            UILabel *detailshowOnMapLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
            detailshowOnMapLabel.font=[UIFont systemFontOfSize:15];
            detailshowOnMapLabel.textColor=[UIColor grayColor];
            detailshowOnMapLabel.numberOfLines=0;
            detailshowOnMapLabel.text=LOCALIZATION(@"hint_show_at_map");
            return detailshowOnMapLabel;
            
        }
        default:
            break;
    }
    
    return nil;
}


#pragma M
-(void)dataBtnClicked{
   
    
    DatePickerView *datePickerView=[[DatePickerView alloc]initDateViewWithFrame:self.view.bounds WithDateType:UIDatePickerModeDate];
    datePickerView.delegate=self;
    [self.view addSubview:datePickerView];
    
}

#pragma  M
- (void)timeBtnClicked{
    
    
    
    DatePickerView *datePickerView=[[DatePickerView alloc]initDateViewWithFrame:self.view.bounds WithDateType:UIDatePickerModeTime];
    datePickerView.delegate=self;

    [self.view addSubview:datePickerView];
    
}

#pragma DatePickerViewDelegate

-(void)datePickerView:(DatePickerView *)datePickerView didSelectTime:(NSString *)time{
    
    if (datePickerView.datePicker.datePickerMode==UIDatePickerModeTime) {
        self.time.text=time;
    }else if (datePickerView.datePicker.datePickerMode==UIDatePickerModeDate){
        self.disappearDate.text=time;
        
    }
    
}

# pragma mark Method
-(void)sureBtnClicked{
    
    

    if (self.disappearDate.text.length>0||self.time.text.length>0) {
        
        if ([self.delegate respondsToSelector:@selector(Controller:disappear:time:isAnnoymity:allowComment:showOnMap:)]) {
            [self.delegate Controller:self disappear:self.disappearDate.text time:self.time.text isAnnoymity:self.annoymitySwitch.isOn allowComment:self.allowCommentSwitch.isOn showOnMap:self.showCommentSwitch.isOn];
        }
        
    }else{
        
        [MBProgressHUD showError:@"请填写时间"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
