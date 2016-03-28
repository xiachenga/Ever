//
//  SegmentControlViewController.m
//  Ever
//
//  Created by Mac on 15-3-12.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "SegmentControlViewController.h"
#import "PersonViewController.h"
#import "PersonDocumentViewController.h"
#import "CEOViewController.h"

@interface SegmentControlViewController ()

@end

@implementation SegmentControlViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    //创建一个uiSegmentControl
    [self setupSegmentControl];
    

    
}

//创建uiControlSegment
- (void)setupSegmentControl
{
    _segmentedControl = [[UISegmentedControl alloc] init];
    _segmentedControl.size=CGSizeMake(150, 40);
    NSMutableDictionary *textAttrsNormal=[NSMutableDictionary dictionary];
    textAttrsNormal[NSForegroundColorAttributeName]=[UIColor colorWithRed:251/255 green:183/255 blue:65/255 alpha:1.0];
    [_segmentedControl setTitleTextAttributes:textAttrsNormal forState:UIControlStateNormal];
    
    NSMutableDictionary *textAttrsHight=[NSMutableDictionary dictionary];
    textAttrsHight[NSForegroundColorAttributeName]=[UIColor whiteColor ];
    [_segmentedControl setTitleTextAttributes:textAttrsHight forState:UIControlStateSelected];
    
    _segmentedControl.tintColor=[UIColor colorWithRed:254/255 green:178/255 blue:34/255 alpha:0.1];
    
    [_segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
    
    PersonViewController *personVC=[[PersonViewController alloc]init];
    PersonDocumentViewController *personDocVC=[[PersonDocumentViewController alloc]init];
    
    [self setViewControllers:@[personVC,personDocVC]];
    
}



- (void)setViewControllers:(NSArray *)viewControllers
{
    
    for (int i = 0; i < viewControllers.count; i++) {
        if (i==0) {
            [self pushViewController:viewControllers[i] title:LOCALIZATION(@"PersonDocumentContacts")];
        }else
        {
            [self pushViewController:viewControllers[i] title:LOCALIZATION(@"PersonDocument")];
        }
        
        
    }
    
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}


- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    [_segmentedControl insertSegmentWithTitle:title atIndex:_segmentedControl.numberOfSegments animated:NO];
    [self addChildViewController:viewController];
    [_segmentedControl sizeToFit];
}


- (void)segmentedControlSelected:(id)sender
{
    self.selectedViewControllerIndex = _segmentedControl.selectedSegmentIndex;
    
}

- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if (!_selectedViewController) {
        _selectedViewController = self.childViewControllers[index];
        
        [_selectedViewController view].frame = self.view.bounds;
        
        [self.view addSubview:[_selectedViewController view]];
        [_selectedViewController didMoveToParentViewController:self];
    } else {
        
        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:  UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            _selectedViewController = self.childViewControllers[index];
            _selectedViewControllerIndex = index;
        }];
    }
}




//语言改变
- (void)languageChange
{
    CLog(@"收到通知");
    
    [self.segmentedControl setTitle:LOCALIZATION(@"PersonDocumentContacts") forSegmentAtIndex:0];
    [self.segmentedControl setTitle:LOCALIZATION(@"PersonDocument") forSegmentAtIndex:1];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}


@end
