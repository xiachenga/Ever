//
//  MyTalkViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "MyTalkViewController.h"
#import "LoginResult.h"
#import "MyJournalIndexResult.h"
#import "MyjournalCell.h"
#import "TalkDetailViewController.h"
#import "TalkViewController.h"
@interface MyTalkViewController ()

@property (nonatomic,strong)NSMutableArray *journalArray;



@end

@implementation MyTalkViewController


-(NSMutableArray *)journalArray
{
    if (_journalArray==nil) {
        _journalArray=[NSMutableArray array];
    }
    return _journalArray;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=LOCALIZATION(@"MyDataDairy");
//        self.view.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fabu_xiangji"] style:UIBarButtonItemStylePlain target:self action:@selector(upLoadDairy)];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    

    
    [self loadData];
    
}

- (void)loadData
{
    
    [self.view beginLoading];
    
    LoginResult *account=[AccountTool account];
    NSString *string=[NSString stringWithFormat:@"user/journal/%ld/1/10/1/0",account.user_id];
    
    NSString *urlString=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        [self.view endLoading];
        
        CLog(@"%@",responseobj);
        
        if (responseobj!=nil) {
             NSArray *journals=[MyJournalIndexResult objectArrayWithKeyValuesArray:responseobj];
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:journals.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            
            if (journals.count!=0) {
                [self.journalArray addObjectsFromArray:journals];
                [self.tableView reloadData];
                
            }
        }
        
    } failure:^(NSError *erronr) {
        
        CLog(@"%@",erronr);
        
        [self.view endLoading];
        
        [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [MBProgressHUD showError:@"似乎断开与互联网的连接"];
            [self loadData];
            
        }];
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.journalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyJournalIndexResult *myJournalIndex=self.journalArray[indexPath.row];
    NSString *identifier=@"journanCell";
    MyjournalCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[MyjournalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.journalIndex=myJournalIndex;
    
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    [tableView.tableFooterView addLineUp:NO andDown:YES];
    
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyJournalIndexResult *myJournalIndex=self.journalArray[indexPath.row];
    TalkDetailViewController *talkDetailVC=[[TalkDetailViewController alloc]init];
    talkDetailVC.talkid=myJournalIndex.journal_id;
    [self.navigationController pushViewController:talkDetailVC animated:YES];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    MyJournalIndexResult *myJournalIndex=self.journalArray[indexPath.row];
    
    NSString *string=[NSString stringWithFormat:@"%@journal/del/%ld",kSeverPrefix,myJournalIndex.journal_id];
    [HttpTool get:string params: nil success:^(id responseobj) {
        
   
        
    } failure:^(NSError *erronr) {
        
    }];
    
    [self.journalArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    
}

- (void)languageChange
{
    CLog(@"收到通知");
    
    self.title=LOCALIZATION(@"MyDataDairy");
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}


- (void)upLoadDairy
{
    TalkViewController *talkVC=[[TalkViewController alloc]init];
    [self.navigationController pushViewController:talkVC animated:YES];
    
    
}

@end
