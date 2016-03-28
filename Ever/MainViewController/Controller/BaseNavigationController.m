//
//  BaseNavigationController.m
//  Ever
//
//  Created by Mac on 15-1-1.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)loadView
{
    
    [super loadView];
}



+(void)initialize
{
    [self setupNavBarTheme];
}

+ (void)setupNavBarTheme
{
    UINavigationBar *navBar=[UINavigationBar appearance];
    [navBar setBarTintColor:kThemeColor];
    [navBar setTintColor:[UIColor blackColor]];
    
    NSDictionary *textAttributes=@{NSFontAttributeName: [UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]};
    [navBar setTitleTextAttributes:textAttributes];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    
    if (self.viewControllers.count>=2) {
        [self.mm_drawerController  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    }
    else
    {
        [self.mm_drawerController  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
        
    }
    
}



@end
