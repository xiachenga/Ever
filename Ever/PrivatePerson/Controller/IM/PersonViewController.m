//
//  PersonViewController.m
//  Ever
//
//  Created by Mac on 15-3-11.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

NSString *const ContactViewIdentifier = @"Cell";

#import "PersonViewController.h"
#import "ContactViewController.h"
#import "ChatViewController.h"
#import <RCIM.h>
#import "pinyin.h"
#import "Contactcell.h"
#import "CollectionHeaderView.h"
#import "UserRelationResult.h"
#import "ChineseString.h"
#import "FocusOnMeViewController.h"
#import "ChatorHomeView.h"

@interface PersonViewController ()<ChatorHomeViewDelegate>

@property (nonatomic , strong) NSMutableArray *sectionHeadsKeys,*firstNumArray,*tempttArray,*contactArray;
@property (nonatomic , weak) UIButton *addBtn,*followerBtn;
@property (nonatomic , weak) UIImageView *badgeView;
@property (nonatomic , weak) Contactcell *contactCell;

@end

@implementation PersonViewController

-(NSMutableArray *)tempttArray
{
    if (_tempttArray==nil) {
        _tempttArray=[NSMutableArray array];
    }
    return _tempttArray;
    
}

-(NSMutableArray *)contactArray
{
    
    if(_contactArray==nil)
    {
        _contactArray=[NSMutableArray array];
        
    }
    return _contactArray;
}



-(NSMutableArray *)firstNumArray
{
    
    if(_firstNumArray==nil)
    {
        _firstNumArray=[NSMutableArray array];
        
    }
    return _firstNumArray;
}


//初始化
- (id)init
{
    //uiCollectionViewFlowLayout的初始化，
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //设置每个UICollectionView的大小
    layout.itemSize=CGSizeMake(kScreen_Width*0.25-8,kScreen_Width*0.25-8+40);

    //左右间的间距
    layout.minimumInteritemSpacing=2;
    //上下间的间距
    layout.minimumLineSpacing=2;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(guanzhuClicked:) name:kNotificationGuanzhu  object:nil];
    
    
    //添加按钮
    [self addButton];
    [self setupCollectionView];
    //加载关注聊表
    [self loadGuanzhuList];

}
//创建CollectionView
- (void)setupCollectionView
{
    self.collectionView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.collectionView.alwaysBounceVertical=YES;
    
    self.collectionView.showsVerticalScrollIndicator=NO;
    
    [self.collectionView registerClass:[Contactcell class] forCellWithReuseIdentifier:ContactViewIdentifier];
    
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

//加载关注列表
- (void)loadGuanzhuList{
    
    
    if ([AccountTool isLogin]) {
        [self.view beginLoading];
        
        NSString *urlstring=[kSeverPrefix stringByAppendingString:@"user/list/1/1/200/1/0"];
        
        //取得关注列表
        [HttpTool get:urlstring params:nil success:^(id responseobj) {
            
            CLog(@"%@",responseobj);
            
            [self.view endLoading];
            
            NSArray *contacts=[UserRelationResult objectArrayWithKeyValuesArray:responseobj];
//            if (contacts.count==0) {
//                return ;
//            }
            
            [self.view configBlankPage:BlankPagetypeEmpty hasData:contacts.count>0 hasError:0 reloadButtonBlock:^(id sender) {
                

            }];

            [self.tempttArray addObjectsFromArray:contacts];
            
            self.contactArray=[self getChineseStringArr:self.tempttArray];
            
            
            [self.collectionView reloadData];
            
        } failure:^(NSError *erronr) {
            
            [self.view endLoading];
            
            [MBProgressHUD showError:@"似乎已断开与互联网的连接"];
            
            [self.view configBlankPage:BlankPagetypeRefresh hasData:0 hasError:1 reloadButtonBlock:^(id sender) {
               
                [self loadGuanzhuList];
                
            }];
            
        }];
    }
    
    
}


- (void)addButton
{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, kScreen_Width, 175);
    [self.view addSubview:view];
    view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
   
    UIButton *addBtn=[self buttonWithTitle:LOCALIZATION(@"PersonContactsAddFriend") image:@"addFriendsBtn" action:@selector(addBtnClicked)];
    addBtn.frame=CGRectMake(0, 70, kScreen_Width, 50);
    
    [addBtn setBackgroundImage:[UIImage imageNamed:@"tongxunluanniubg"] forState:UIControlStateHighlighted];
    
    self.addBtn=addBtn;
    [view addSubview:addBtn];
    
    UIImageView *addArrowR=[self arrowWithImage:@"tongxunlu_jiantou"];
    addArrowR.frame=CGRectMake(kScreen_Width-30, CGRectGetMinY(addBtn.frame)+13, 24, 24);
    
    [addBtn addLineUp:NO andDown:YES andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];


    UIButton *newBtn=[self buttonWithTitle:LOCALIZATION(@"PersonDocumentguanzhu") image:@"newFriendsBtn" action:@selector(newBtnClicked)];
    newBtn.frame=CGRectMake(0, CGRectGetMaxY(addBtn.frame)+5, kScreen_Width, 50);
    
    [newBtn setBackgroundImage:[UIImage imageNamed:@"tongxunluanniubg"] forState:UIControlStateHighlighted];
    self.followerBtn=newBtn;
    [view addSubview:newBtn];
    
    UIImageView *newArrowR=[self arrowWithImage:@"tongxunlu_jiantou"];
    newArrowR.frame=CGRectMake(kScreen_Width-30, CGRectGetMinY(newBtn.frame)+13, 24, 24);
    
    //新增加的粉丝的红点
    UIImageView *badgeView=[[UIImageView alloc]init];
    badgeView.layer.cornerRadius=5;
    badgeView.layer.masksToBounds=YES;
    self.badgeView=badgeView;
    badgeView.hidden=YES;
    badgeView.backgroundColor=[UIColor redColor];
    [view addSubview:badgeView];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newArrowR.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(newArrowR.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [newBtn addLineUp:NO andDown:YES andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

//向右的箭头
- (UIImageView *)arrowWithImage:(NSString *)image
{
    UIImageView *arrow=[[UIImageView alloc]init];
    arrow.image=[UIImage imageNamed:image];
    [self.view addSubview:arrow];
    return arrow;
}
- (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)image action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
  
    [button setContentMode:UIViewContentModeScaleAspectFit];
    
    UIImage *finalImage=[UIImage imageNamed:image];
   
    [button setImage:finalImage forState:UIControlStateNormal];
    //设置内容垂直或水平显示位置
    
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setTitle:title forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted=NO;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark Target

-(void)addBtnClicked
{
    
    [self getPush:nil];

    if ([AccountTool isLogin]) {
        ContactViewController *contactVC=[[ContactViewController alloc]init];
        [self.navigationController pushViewController:contactVC animated:YES];
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
    
}

#pragma mark Target
- (void)newBtnClicked
{
   
    if ([AccountTool isLogin]) {
        
        //让红点消失
        
        self.badgeView.hidden=YES;
        
        FocusOnMeViewController *focusMeVC=[[FocusOnMeViewController alloc]init];
        [self.navigationController pushViewController:focusMeVC animated:YES];
        
        
    }else
    {
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
    }
}

#pragma mark UICollectionViewDatasource 

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *array=self.contactArray[section];
    return array.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.contactArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Contactcell *contactCell=[collectionView dequeueReusableCellWithReuseIdentifier:ContactViewIdentifier forIndexPath:indexPath];
  
    
    if (contactCell==nil) {
        contactCell=[[Contactcell alloc]init];
    }
  
    
    ChineseString *string=self.contactArray[indexPath.section][indexPath.row];
    
    UserRelationResult *guanzhu=string.usesrRelation;
    contactCell.guanzhu=guanzhu;
    contactCell.showRedDotView=string.showRedDotView;
    
    return contactCell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChineseString *string=self.contactArray[indexPath.section][indexPath.row];
    UserRelationResult *guanzhu=string.usesrRelation;
    
    
    Contactcell *cell=(Contactcell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.contactCell=cell;
    
    
    
    ChatorHomeView *chatorhomeView=[[ChatorHomeView alloc]initWithFrame:self.view.bounds];
    chatorhomeView.delegate=self;
    chatorhomeView.user=guanzhu;
    [chatorhomeView show];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGSizeMake(kScreen_Width, 130);
    }
    else{
        return CGSizeMake(kScreen_Width, 30);
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *string=self.firstNumArray[indexPath.section];
    CollectionHeaderView *headerView;
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
         headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    }
    
    headerView.first_letter=string;
    
    if (indexPath.section==0) {
         headerView.letterFrame=CGRectMake(kScreen_Width-30, 120, 50, 30);
        
    }else{
         headerView.letterFrame=CGRectMake(kScreen_Width-30, 5, 50, 30);
        
    }
   
    return headerView;
    
}

- (void)chatOrHomeBtnClicked:(UIButton *)button withUser:(UserRelationResult *)user
{
    //聊天
    if (button.tag==10) {
        
          //如果有红点让红点消失
        
            self.contactCell.showRedDotView=NO;
        
        
       
             LoginResult *account=[AccountTool account];
        
             [RCIM connectWithToken:account.rong_token completion:^(NSString *userId) {
        
                ChatViewController *chatVC=[[ChatViewController alloc]init];
            
                chatVC.conversationType=ConversationType_PRIVATE;
                chatVC.currentTarget=[NSString stringWithFormat:@"u%ld",user.user_id];
                chatVC.enablePOI=NO;
                chatVC.enableVoIP=NO;
                chatVC.currentTargetName=user.user_nickname;
                chatVC.enableSettings=NO;
                [chatVC setNavigationTitle:user.user_nickname textColor:[UIColor blackColor]];
                chatVC.portraitStyle=RCUserAvatarCycle;
              
                 chatVC.user=user;
                
                [self.navigationController pushViewController:chatVC animated:YES];
                
        
            } error:^(RCConnectErrorCode status) {
                CLog(@"连接融云失败");
        
            }];
    
    }else
    {
        PersonhomeViewController *personVC=[[PersonhomeViewController alloc]init];
        personVC.user_id=user.user_id;
        
        [self.navigationController pushViewController:personVC animated:YES];
        
    }
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    
    _sectionHeadsKeys=[NSMutableArray array];
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    
    
    for(int i = 0; i < [arrToSort count]; i++) {
        
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        UserRelationResult *user=[arrToSort objectAtIndex:i];
        
        chineseString.usesrRelation=user;
        
        chineseString.string=[NSString stringWithString:user.user_nickname];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
        
}
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        
        chineseStr.firstNum=sr;
        
        NSLog(@"%@",sr);
        
    
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            
            
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                
                ChineseString *string=[TempArrForGrouping firstObject];
                
                
                [self.firstNumArray addObject:string.firstNum];
                
                
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

- (void)guanzhuClicked:(NSNotification *)notification{
    
    [self.tempttArray removeAllObjects];
    [self.contactArray removeAllObjects];
    [self.firstNumArray removeAllObjects];
    
    [self loadGuanzhuList];
    
}



//接收推送
- (void)getPush:(NSDictionary *)userInfo {
    
    NSInteger count=self.contactArray.count;
    
    for (int i=0; i<count; i++) {
        
        NSArray *array=self.contactArray[i];
        
        
        for (int j=0; j<array.count; j++) {
            
            ChineseString *string=array[j];
            
            if (string.usesrRelation.user_id==1896) {
                
                ChineseString *string1=self.contactArray[i][j];
                
                string1.showRedDotView=YES;
                
                [self.collectionView reloadData];
                
                return;
                
            }
            
        }
    }
    
    
    
}


//语言切换
- (void)languageChange {

    CLog(@"收到通知");
    
    [self.addBtn setTitle:LOCALIZATION(@"PersonContactsAddFriend") forState:UIControlStateNormal];
    [self.followerBtn setTitle:LOCALIZATION(@"PersonDocumentguanzhu")  forState:UIControlStateNormal];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationGuanzhu object:nil];
}





@end



