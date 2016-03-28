//
//  NewStatusSegViewController.m
//  Ever
//
//  Created by Mac on 15-3-15.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "NewStatusSegViewController.h"
#import "FavourYouViewController.h"
#import "CommentYouViewController.h"

@interface NewStatusSegViewController ()

@property(nonatomic,weak) UISegmentedControl *segmentedControl;

@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

@property (nonatomic , strong) FavourYouViewController *favourYouVC;

@property (nonatomic , strong) CommentYouViewController *commentYouVC;

@end

@implementation NewStatusSegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建SegmentControl
    [self setupSegmentControl];
    
}

//创建uiControlSegment
- (void)setupSegmentControl
{
    NSArray *array=@[LOCALIZATION(@"FavouredMe"),LOCALIZATION(@"CommentedMe")];
    
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    
    NSMutableDictionary *textAttrsNormal=[NSMutableDictionary dictionary];
    textAttrsNormal[NSForegroundColorAttributeName]=[UIColor colorWithRed:251/255 green:183/255 blue:65/255 alpha:0.5];
    [segmentControl setTitleTextAttributes:textAttrsNormal forState:UIControlStateNormal];
    
    NSMutableDictionary *textAttrsHight=[NSMutableDictionary dictionary];
    textAttrsHight[NSForegroundColorAttributeName]=[UIColor whiteColor ];
    [segmentControl setTitleTextAttributes:textAttrsHight forState:UIControlStateSelected];
    
    segmentControl.tintColor=[UIColor colorWithRed:254/255 green:178/255 blue:34/255 alpha:0.1];
    
    [segmentControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
    
    //默认选中点赞我的
    
    segmentControl.selectedSegmentIndex=0;
    
    self.segmentedControl=segmentControl;
    
    self.navigationItem.titleView = segmentControl;
    
    
    
    FavourYouViewController *favoYouVC=[[FavourYouViewController alloc]init];
    favoYouVC.view.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Height);
    self.favourYouVC=favoYouVC;
  
    [self.view addSubview:[favoYouVC view]];
    
}


- (void)segmentedControlSelected:(UISegmentedControl *)segmentControl
{
    
        
    if (segmentControl.selectedSegmentIndex==0) {
        
        
        
        [self.commentYouVC.view removeFromSuperview];
        
        
        
        
        [self.view addSubview:[self.favourYouVC view]];
        
    }else{
        
        if (!_commentYouVC) {
            
            CommentYouViewController *commentVC=[[CommentYouViewController alloc]init];
            commentVC.view.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Height);
            self.commentYouVC=commentVC;
            
        }
        
        [self.favourYouVC.view removeFromSuperview];
        
        [self.view addSubview:[self.commentYouVC view]];
        
    }
    
    
}





@end
