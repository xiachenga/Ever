//
//  RootViewController.m
//  Ever
//
//  Created by Mac on 15-5-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "RootViewController.h"
#import "NewStyleViewController.h"
#import "BigSocietyViewController.h"

#import <BaiduMapAPI/BMapKit.h>
@interface RootViewController ()



@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

@property (nonatomic , strong) NewStyleViewController *StyleVC;

@property (nonatomic , strong) BigSocietyViewController *bigSocietyVC;

@property (nonatomic , assign) BOOL mapViewRefresh;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
}

- (void)setupSegmentControl
{
    NSArray *array=@[LOCALIZATION(@"GediaoNew"),LOCALIZATION(@"GediaoMap")];
    
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.size=CGSizeMake(150, 30);
    
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
    
    self.selectedViewControllerIndex=0;
    
    self.navigationItem.titleView = segmentControl;
    
    NewStyleViewController *newStyleVC=[[NewStyleViewController alloc]init];
    newStyleVC.view.frame=CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    self.StyleVC=newStyleVC;
    [self addChildViewController:newStyleVC];
    [self.view addSubview:[newStyleVC view]];
    
    //大社会
    BigSocietyViewController *bigSocietyVC=[[BigSocietyViewController alloc]init];
    bigSocietyVC.view.frame=CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    self.bigSocietyVC=bigSocietyVC;
    
}

- (void)bigSocityRefresh {
    
//    [self.bigSocietyVC refresh];
    
    self.mapViewRefresh=YES;
}


- (void)segmentedControlSelected:(UISegmentedControl *)segmentControl {
    
    if (segmentControl.selectedSegmentIndex==self.selectedViewControllerIndex) {
        
    }else{
        
        self.selectedViewControllerIndex=segmentControl.selectedSegmentIndex;
        
        if (segmentControl.selectedSegmentIndex==0) {
            
            NSArray *array= self.childViewControllers;
            
            BigSocietyViewController *bigSocietyVC=array[0];
            [bigSocietyVC removeFromParentViewController];
            [bigSocietyVC.view removeFromSuperview];
            
            [self addChildViewController:self.StyleVC];
            [self.view addSubview:[self.StyleVC view]];
            
            
        }else{
            
            NSArray *array= self.childViewControllers;
            
            NewStyleViewController *newStyleVC=array[0];
            [newStyleVC removeFromParentViewController];
            [newStyleVC.view removeFromSuperview];
        
            [self addChildViewController:self.bigSocietyVC];
            
            [self.view addSubview:[self.bigSocietyVC view]];
            
            if (self.mapViewRefresh) {
                
                [self.bigSocietyVC refresh];
                
                self.mapViewRefresh=NO;
            }
            
        }
    }
}


- (void)languageChange
{
    
    [self.segmentedControl setTitle:LOCALIZATION(@"GediaoNew") forSegmentAtIndex:0];
    [self.segmentedControl setTitle:LOCALIZATION(@"GediaoMap") forSegmentAtIndex:1];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}





@end
