//
//  GediaoSegmentController.m
//  Ever
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "GediaoSegmentController.h"
#import "GediaoZanListViewController.h"
#import "CommentViewController.h"
@interface GediaoSegmentController ()

@property(nonatomic,weak) UISegmentedControl *segmentedControl;

@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

@property (nonatomic , strong) GediaoZanListViewController *gediaoZanVC;

@property (nonatomic , strong) CommentViewController *commentVC;

@end

@implementation GediaoSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSegmentControl];

}

-(void)setKindItem:(KindItem *)kindItem
{
    _kindItem=kindItem;
}

- (void)setupSegmentControl
{
    NSArray *array=@[LOCALIZATION(@"GediaoZan"),LOCALIZATION(@"GediaoComment")];
    
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    
    NSMutableDictionary *textAttrsNormal=[NSMutableDictionary dictionary];
    textAttrsNormal[NSForegroundColorAttributeName]=[UIColor colorWithRed:251/255 green:183/255 blue:65/255 alpha:0.5];
    [segmentControl setTitleTextAttributes:textAttrsNormal forState:UIControlStateNormal];
    
    NSMutableDictionary *textAttrsHight=[NSMutableDictionary dictionary];
    textAttrsHight[NSForegroundColorAttributeName]=[UIColor whiteColor ];
    [segmentControl setTitleTextAttributes:textAttrsHight forState:UIControlStateSelected];
    
    segmentControl.tintColor=[UIColor colorWithRed:254/255 green:178/255 blue:34/255 alpha:0.1];
    segmentControl.size=CGSizeMake(150, 30);
    
    [segmentControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
    
    //默认选中点赞我的

    self.segmentedControl=segmentControl;
    
    self.navigationItem.titleView = segmentControl;
    
    
    CommentViewController *commentVC=[[CommentViewController alloc]init];
    commentVC.kindItem=self.kindItem;
    commentVC.view.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Height);
    self.commentVC=commentVC;
    
    
    
    GediaoZanListViewController *gediaoZanVC=[[GediaoZanListViewController alloc]init];
    gediaoZanVC.kindItem=self.kindItem;
    gediaoZanVC.view.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Height);
    self.gediaoZanVC=gediaoZanVC;
   

    if (self.type==TypeComment) {
        segmentControl.selectedSegmentIndex=1;
     //   [self addChildViewController:commentVC];
        [self.view addSubview:[commentVC view]];
    }else{
        segmentControl.selectedSegmentIndex=0;
      //  [self addChildViewController:gediaoZanVC];
        [self.view addSubview:[gediaoZanVC view]];
        
    }
   
}

- (void)segmentedControlSelected:(UISegmentedControl *)segmentControl
{
    
    if (segmentControl.selectedSegmentIndex==0) {
        
        
        [self.commentVC.view removeFromSuperview];
        
        
        [self.view addSubview:[self.gediaoZanVC view]];
        
    }else{
        
        [self.gediaoZanVC.view removeFromSuperview];
        
        
        [self.view addSubview:[self.commentVC view]];
        
        
    }
    
    
}


@end
