//
//  AddLabelViewController.m
//  Ever
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//
#import "AddLabelViewController.h"

@interface AddLabelViewController ()<UITextFieldDelegate>

@property (nonatomic,weak)UITextField *textField;

//下面的背景
@property (nonatomic , weak) UIImageView *imageView;

@property (nonatomic , assign) int color_type;

@end
@implementation AddLabelViewController


- (void)viewDidLoad{
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.title=LOCALIZATION(@"marker_title");
    
    
    //创建颜色按钮
    
    NSArray *colorArray=@[@"c9171e", @"ee827c", @"f6ad49", @"fcc800", @"c7dc68", @"69b076", @"83ccd2", @"8491c3", @"867ba9", @"000000"];
    for (int i=0 ; i<colorArray.count; i++) {
        NSString *colorString=colorArray[i];
        [self addColorButton:colorString frame:CGRectMake((kScreen_Width-10*20)*0.5+i*20, 100, 20, 100) buttonTag:i];
    }
    
    
    [self addTextField];
    
    //添加确定按钮
    [self addSureButton];
    
}

- (void)addColorButton:(NSString *)colorString frame:(CGRect)frame buttonTag:(int)i
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundColor:[UIColor colorWithHexString:colorString]];
    button.frame=frame;
    
    button.tag=i;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)addTextField
{
    UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_0"];
    self.color_type=1;
    bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 250, kScreen_Width-2*20, 50)];
    imageView.userInteractionEnabled=YES;
    self.imageView=imageView;
    imageView.image=bgImage;
    [self.view addSubview:imageView];
    
    
    UITextField *field=[[UITextField alloc]initWithFrame:CGRectMake(0, 5, kScreen_Width-2*20, 40)];
    field.placeholder=LOCALIZATION(@"marker_edit_hint");
    self.textField=field;
    field.returnKeyType=UIReturnKeyDone;
    field.delegate=self;
    [imageView addSubview:field];
    
}

- (void)buttonClicked:(UIButton *)button
{
    self.color_type=button.tag;
    switch (button.tag) {
        case 0:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_0"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
            
        }
        
            break;
            
        case 1:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_1"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
            
        }
            break;
            
        case 2:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_2"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
           
        }
            break;
            
        case 3:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_3"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
            
            
        }
            break;
        case 4:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_4"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
            
        }
            break;
        case 5:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_5"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
           
        }
            break;
        case 6:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_6"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
           
        }
            break;
            
        case 7:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_7"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
            
        }
            break;
            
        case 8:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_8"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
           
        }
            break;
        case 9:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.imageView.image=bgImage;
            
        }
            break;
            
    }
    
}

//添加确定按钮
- (void)addSureButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [button setTitle:LOCALIZATION(@"marker_sure") forState:UIControlStateNormal];
    button.frame=CGRectMake(20, kScreen_Height-100, kScreen_Width-2*20, 40);
    [button addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)sureBtnClicked:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(addLabelText:color_type:)]) {
        [self.delegate addLabelText:self.textField.text color_type:self.color_type];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}


#pragma UiTextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}
@end
