//
//  CommentViewController.m
//  Ever
//
//  Created by Mac on 15-4-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "CommentViewController.h"
#import "GediaoDetailResult.h"
#import "CommentFrames.h"
#import "CommentResult.h"
#import "CommentCell.h"
#import "LoginResult.h"
#import "WorldTagDetailResult.h"
#import "KindItem.h"


@interface CommentViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *commentFrames;

@property (nonatomic , assign) long lastIndex,firstIndex;

@property (nonatomic , assign) int pageNum;

@property (nonatomic , assign) UIView *bottomView ;

@property (nonatomic , weak) UITextField *contentView;

@property (nonatomic , strong) LoginResult *account;

@property (nonatomic , assign) long replay_user_id;

@property (nonatomic , weak) UITableView *tableView;

@end


@implementation CommentViewController

-(NSMutableArray *)commentFrames
{
    if (_commentFrames==nil) {
        _commentFrames=[NSMutableArray array];
    }
    return _commentFrames;
    
}


- (void)viewDidLoad
{
    self.title=LOCALIZATION(@"Comment");
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.backgroundColor=[UIColor whiteColor];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    [self.view addSubview:tableView];
    
    
    LoginResult *account=[AccountTool account];
    self.account=account;
    
    [self addBottomView];

//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self refresh];
//    }];
//    
//    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self loadMoreComment];
//    }];
    
    [self.tableView addHeaderWithCallback:^{
        
        [self refresh];
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        
        [self loadMoreComment];
        
    }];
}

- (void)addBottomView
{
    UIView *bottomView=[[UIView alloc]init];
    

    if (self.kindItem.kind==1) {
        
      bottomView.frame=CGRectMake(0,kScreen_Height-64-50, kScreen_Width, 50);
        
    }else{
        bottomView.frame=CGRectMake(0,kScreen_Height-50, kScreen_Width, 50);
    }
   
    self.bottomView=bottomView;
    bottomView.backgroundColor=[UIColor grayColor];
    bottomView.userInteractionEnabled=YES;
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
    
    //头像

    UITapImageView *imageView=[[UITapImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    [imageView doCircleFrame];
    NSString *string=self.account.user_head_image_url;
    NSURL *urlstring=[NSURL URLWithString:string];
    [imageView sd_setImageWithURL:urlstring placeholderImage:[UIImage imageNamed:@"avatarholder"]];
    [bottomView addSubview:imageView];

    //定义一个通知，来调整view高度
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    UITextField *contentView=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, CGRectGetMinY(imageView.frame), kScreen_Width-60-55, 40)];
    self.contentView=contentView;
    contentView.layer.borderWidth=1;
    contentView.delegate=self;
    contentView.layer.cornerRadius=4;
    contentView.layer.masksToBounds=YES;
    contentView.layer.borderColor=[UIColor whiteColor].CGColor;
    contentView.backgroundColor=[UIColor whiteColor];
    contentView.placeholder=LOCALIZATION(@"CommentPlaceHolder");
    contentView.clearButtonMode=UITextFieldViewModeAlways;
    contentView.font=[UIFont systemFontOfSize:14];
    [bottomView addSubview:contentView];
    
    //发送按钮
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(CGRectGetMaxX(contentView.frame)+5, 5, 55, 40);
    [sendBtn setTitle:LOCALIZATION(@"Send") forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendBtn];
}


-(void)setKindItem:(KindItem *)kindItem
{
    _kindItem=kindItem;
    
    [self loadNewComment];
    
}

- (void)loadNewComment
{
    //评论获取数据

    NSString *urlstring,*string;
    if (_kindItem.kind==1) {
        
        string=[NSString stringWithFormat:@"gediao/comment/list/%ld/1/8/1/0",self.kindItem.itemID];
        
    }else if (_kindItem.kind==2)
    {
         string=[NSString stringWithFormat:@"journal/comment/list/%ld/1/8/1/0",self.kindItem.itemID];
        
        
    }else{
         string=[NSString stringWithFormat:@"meet/comment/list/%ld/1/8/1/0",self.kindItem.itemID];
    }
    
    urlstring=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        
        
        
        if (responseobj!=nil) {
            
        
            
            NSArray *comments=[CommentResult    objectArrayWithKeyValuesArray:responseobj];
            
             [self.view configBlankPage:BlankPagetypeEmpty hasData:comments.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                 
             }];
            
            
            CommentResult *lastCommentIndex=[comments lastObject];
            self.lastIndex=lastCommentIndex.comment_id;
            
            CommentResult *firstCommentIndex=[comments firstObject];
            self.firstIndex=firstCommentIndex.comment_id;
            
            NSMutableArray *array=[NSMutableArray array];
            
            for (int i=0; i<comments.count; i++) {
                CommentFrames *commentFrame=[[CommentFrames alloc]init];
                commentFrame.comment=comments[i];
                [array addObject:commentFrame];
                
            }
            
            [self.commentFrames addObjectsFromArray:array];
            [self.tableView reloadData];
             self.pageNum=2;
            
        }

    
    } failure:^(NSError *erronr) {
        
        
        [MBProgressHUD showError:@"似乎已断开与互联网的连接"];
        
        [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
            
            [self loadNewComment];
            
        }];
        
    }];
    
}

//下拉加载更多
- (void)refresh
{
    NSString *urlstring,*string;

    if (_kindItem.kind==1) {
        string=[NSString stringWithFormat:@"gediao/comment/list/%ld/-1/8/1/%ld",self.kindItem.itemID, self.firstIndex];
        
    }else if (_kindItem.kind==2)
    {
        string=[NSString stringWithFormat:@"journal/comment/list/%ld/-1/8/1/%ld",self.kindItem.itemID, self.firstIndex];
        
    }else{
        
        string=[NSString stringWithFormat:@"meet/comment/list/%ld/-1/8/1/%ld",self.kindItem.itemID, self.firstIndex];
    }
    
    urlstring=[kSeverPrefix stringByAppendingString:string];
    
    [HttpTool get:urlstring params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        NSArray *comments=[CommentResult    objectArrayWithKeyValuesArray:responseobj];
        if (comments.count>0) {
            
            CommentResult *lastCommentIndex=[comments firstObject];
            self.firstIndex=lastCommentIndex.comment_id;
            
            
            NSMutableArray *array=[NSMutableArray array];
            
            for (int i=0; i<comments.count; i++) {
                CommentFrames *commentFrame=[[CommentFrames alloc]init];
                commentFrame.comment=comments[i];
                [array addObject:commentFrame];
                
            }
            
            NSRange range=NSMakeRange(0, array.count);
            NSIndexSet *indexSet=[NSIndexSet indexSetWithIndexesInRange:range];
            [self.commentFrames insertObjects:array atIndexes:indexSet];
            [self.tableView reloadData];
        
        }
        
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSError *erronr) {
        
        CLog(@"%@",erronr);
        
    }];
    

}

//加载更多数据
- (void)loadMoreComment
{
    
        NSString *string,*urlString;
        if (_kindItem.kind==1) {
            string=[NSString stringWithFormat:@"gediao/comment/list/%ld/1/8/%d/%ld",self.kindItem.itemID,self.pageNum, self.lastIndex];
            
        }else if (_kindItem.kind==2)
        {
            string=[NSString stringWithFormat:@"journal/comment/list/%ld/1/8/%d/%ld",self.kindItem.itemID,self.pageNum, self.lastIndex];
            
        }else{
            string=[NSString stringWithFormat:@"meet/comment/list/%ld/1/8/%d/%ld",self.kindItem.itemID,self.pageNum, self.lastIndex];
        }
        
        urlString=[kSeverPrefix stringByAppendingString:string];
        
        [HttpTool get:urlString params:nil success:^(id responseobj) {
            
            CLog(@"%@",responseobj);
            
            NSArray *comments=[CommentResult objectArrayWithKeyValuesArray:responseobj];
            if (comments!=0) {
                
                NSMutableArray *array=[NSMutableArray array];
                
                for (int i=0; i<comments.count; i++) {
                    CommentFrames *commentFrame=[[CommentFrames alloc]init];
                    commentFrame.comment=comments[i];
                    [array addObject:commentFrame];
                }
                
                [self.commentFrames addObjectsFromArray:array];
                
                [self.tableView reloadData];
                
                [self.tableView footerEndRefreshing];
                
                CommentResult *comment =[comments lastObject];
                self.lastIndex=comment.comment_id;
                
                self.pageNum++;
                
            }else{
                
                [MBProgressHUD showError:@"没有更多评论"];
            }
            
            
        } failure:^(NSError *erronr) {
            
            
            
        }];
        

    
    
}


#pragma UITableDatasource
         
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.commentFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    
    CommentCell *commentCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    CommentFrames *commentFrame=self.commentFrames[indexPath.row];
    
    if (commentCell==nil) {
        commentCell=[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    commentCell.commentFrame=commentFrame;
    commentCell.kindItem=self.kindItem;
    
    
    [commentCell.userIconView addTapBlock:^(id obj) {
        
        
        [self goToUserInfo:commentFrame.comment.user_id];
        
    }];
    return commentCell;
    
}

- (void)goToUserInfo:(long)userid
{
    
    
    PersonhomeViewController *personHomeVC=[[PersonhomeViewController alloc]init];
    personHomeVC.user_id=userid;
    
    if (self.kindItem.kind==2||self.kindItem.kind==3) {
        UINavigationController *controler=(UINavigationController *)[self viewController];
        controler=(UINavigationController *)controler;
        [controler pushViewController:personHomeVC animated:YES];
    }else{
        
        UIViewController *controler=[self viewController];
        
        [controler.navigationController pushViewController:personHomeVC animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentFrames *commentFrame=self.commentFrames[indexPath.row];
    
    [self.contentView becomeFirstResponder];
    
    self.contentView.placeholder=[NSString stringWithFormat:@"回复:%@",commentFrame.comment.user_nickname];
    self.replay_user_id=commentFrame.comment.user_id;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentFrames *commentFrame=self.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
    
}


- (void)keyboardShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
    
}

- (void)keyboardHide:(NSNotification *)note
{
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentView resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bottomView.hidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.contentView resignFirstResponder];
    self.bottomView.hidden=YES;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.contentView resignFirstResponder];
}

//发送评论
- (void)sendBtnClicked
{
    //键盘收下,清楚输入内容
    
    [self.contentView resignFirstResponder];
    
    if ([AccountTool isLogin]) {
     
    NSString *urlstring;
    
    if (_kindItem.kind==1&&_kindItem.if_can_comment) {

        urlstring=[kSeverPrefix stringByAppendingString:@"gediao/replay"];
        
    }else if (_kindItem.kind==2&&_kindItem.if_can_comment)
    {

         urlstring=[kSeverPrefix stringByAppendingString:@"journal/replay"];
        
    }else if(_kindItem.kind==3){
       
         urlstring=[kSeverPrefix stringByAppendingString:@"meet/replay"];
    }else{
        
        [MBProgressHUD showError:@"不能评论"];
        
        return;
        
    }
    if (self.contentView.text.length==0) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        return;
    }else
    {
        NSMutableDictionary *params=[NSMutableDictionary dictionary ];
        
        [params setValue:self.contentView.text forKey:@"text_content"];
        [params setValue:[NSString stringWithFormat:@"%ld",self.kindItem.itemID]  forKey:@"cid"];
       [params setValue:[NSString stringWithFormat:@"%ld",self.replay_user_id] forKey:@"replay_user_id"];
        
        [HttpTool send:urlstring params:params success:^(id responseobj) {
            
           NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
            
            //字典转换成模型
           CommentResult *comment=[CommentResult objectWithKeyValues:dic];
            
            self.firstIndex=comment.comment_id;
            
            CommentFrames *commentFrame=[[CommentFrames alloc]init];
            commentFrame.comment=comment;
            [self.commentFrames addObject:commentFrame];
            
            [self.tableView reloadData];
            
            [self.contentView setText:@""];
            
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:1 hasError:0 reloadButtonBlock:^(id sender) {
                
            }];
            
        }];
        
    }
    
    }else{
        
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }

}

- (UIViewController*)viewController {
    
    
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



@end
