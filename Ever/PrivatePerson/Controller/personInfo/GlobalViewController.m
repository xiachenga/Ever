//
//  GlobalViewController.m
//  Ever
//
//  Created by Mac on 15-3-12.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "GlobalViewController.h"
#import "MeiliUserViewController.h"
#import "DianzanUserViewController.h"
#import "CommentUserViewController.h"
#import "ReleaseUserViewController.h"
@interface GlobalViewController ()

@end

@implementation GlobalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=LOCALIZATION(@"Ranking");
    
    
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.image=[UIImage imageNamed:@"paihang_beijing.jpg"];
    [self.view addSubview:bgView];
    
    //魅力达人
    [self  titleone:@"魅力达人" titletwo:@"Glamour" frame:CGRectMake((kScreen_Width*0.5-100)*0.5,64+((kScreen_Height-64)*0.5-100)*0.5,100,100) tapBlock:^{
        
        [self gotoMeiliUser];
    }];
    
    //点赞达人
    [self  titleone:@"点赞达人" titletwo:@"Support" frame:CGRectMake(kScreen_Width*0.5+((kScreen_Width*0.5-100)*0.5),64+((kScreen_Height-64)*0.5-100)*0.5,100,100) tapBlock:^{
        
        [self gotoDianzanUser];
    }];
    
    
    [self  titleone:@"评论达人" titletwo:@"Comment" frame:CGRectMake((kScreen_Width*0.5-100)*0.5,(kScreen_Height-64)*0.5+64+((kScreen_Height-64)*0.5-100)*0.5,100,100) tapBlock:^{
        
        [self gotoCommentUser];
    }];

    
    [self  titleone:@"发布达人" titletwo:@"Release" frame:CGRectMake(kScreen_Width*0.5+((kScreen_Width*0.5-100)*0.5),(kScreen_Height-64)*0.5+64+((kScreen_Height-64)*0.5-100)*0.5,100,100) tapBlock:^{
        
        [self gotoReleaseUser];
    }];
    
}


- (void) titleone:(NSString *)titleone titletwo:(NSString *)titletwo frame:(CGRect)frame tapBlock:(void(^)(void))tapAction
{

    UITapImageView *tapImage=[[UITapImageView alloc]initWithFrame:frame];
    tapImage.backgroundColor=[UIColor blackColor];
    tapImage.alpha=0.8;
    [tapImage doCircleFrame];
    [tapImage addTapBlock:^(id obj) {
      
        tapAction();
        
    }];
    
    [self.view addSubview:tapImage];
    
    UILabel *labelOne=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(tapImage.frame)+20, CGRectGetMinY(tapImage.frame)+35, 70, 15)];
    labelOne.text=titleone;
    labelOne.textColor=[UIColor whiteColor];
    labelOne.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:labelOne];
    
    UILabel *labelTwo=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(tapImage.frame)+20, CGRectGetMaxY(labelOne.frame)+3, 70, 15)];
    labelTwo.text=titletwo;
    labelTwo.textColor=[UIColor whiteColor];
    labelTwo.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:labelTwo];
    
    
}

//魅力达人
- (void)gotoMeiliUser
{
    MeiliUserViewController *meiliUserVC=[[MeiliUserViewController alloc]init];
    [self.navigationController pushViewController:meiliUserVC animated:YES];
}

//点赞达人
- (void)gotoDianzanUser
{
    DianzanUserViewController *dianzanUserVC=[[DianzanUserViewController alloc]init];
    [self.navigationController pushViewController:dianzanUserVC animated:YES];
}

//评论达人
- (void)gotoCommentUser
{
    CommentUserViewController *commentUserVC=[[CommentUserViewController alloc]init];
    [self.navigationController pushViewController:commentUserVC animated:YES];
}

//发布达人
- (void)gotoReleaseUser
{
    ReleaseUserViewController *releaseUserVC=[[ReleaseUserViewController alloc]init];
    [self.navigationController pushViewController:releaseUserVC animated:YES];
}

@end
