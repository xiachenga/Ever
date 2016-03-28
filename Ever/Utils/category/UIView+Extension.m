//
//  UIView+Extension.m
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+Extension.h"

#import "UITapImageView.h"
#define kTagLineView 1007

static char LoadingViewKey,BlankPageViewKey;

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
//    self.width = size.width;
//    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}





- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown{
    
    [self addLineUp:hasUp andDown:hasDown andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
    return [self addLineUp:hasUp andDown:hasDown andColor:color andLeftSpace:0];
}
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color andLeftSpace:leftSpace];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color andLeftSpace:leftSpace];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
}


+ (UIView *)lineViewWithPointYY:(CGFloat)pointY{
    return [self lineViewWithPointYY:pointY andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color{
    return [self lineViewWithPointYY:pointY andColor:color andLeftSpace:0];
}

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pointY, kScreen_Width - leftSpace, 0.5)];
    lineView.backgroundColor = color;
    return lineView;
}

- (void)removeViewWithTag:(NSInteger)tag{
    for (UIView *aView in [self subviews]) {
        if (aView.tag == tag) {
            [aView removeFromSuperview];
        }
    }
}



- (void)setLoadingView:(LoadingView *)loadingView{
    [self willChangeValueForKey:@"LoadingViewKey"];
    objc_setAssociatedObject(self, &LoadingViewKey,
                             loadingView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"LoadingViewKey"];
}
- (LoadingView *)loadingView{
    return objc_getAssociatedObject(self, &LoadingViewKey);
}

- (void)beginLoading{

    if (!self.loadingView) {
        
        LoadingView *loadingView=[[LoadingView alloc]initWithFrame:self.bounds];
        self.loadingView=loadingView;
        
    }
    
    [self addSubview:self.loadingView];
    
    [self.loadingView startAnimating];
    
}

-(void)endLoading{
    
    [self.loadingView  stopAnimating];
}


- (void)setBlankPageView:(BlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (BlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

-(void)configBlankPage:(BlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    
    if (self.blankPageView) {
        
        if (hasData && !hasError) {
            
            self.blankPageView.hidden=YES;
            [self.blankPageView removeFromSuperview];
        }
        
    }else{
        
        if (!self.blankPageView) {
            BlankPageView *blankPageView=[[BlankPageView alloc]initWithFrame:self.bounds];
            self.blankPageView=blankPageView;

        }
        self.blankPageView.hidden=NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}


- (UIView *)blankPageContainer{
    
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}


@end


@implementation LoadingView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    
    return self;
}

- (void)startAnimating{
    
    self.hidden=NO;
    
    [self loadingAnimation];

}

- (void)stopAnimating{
    
    self.hidden = YES;
    
    [self removeFromSuperview];
   
}


- (void)loadingAnimation{
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*0.5-75, kScreen_Height*0.5-50, 150, 100)];
    
    UIImage *logo1=[UIImage imageNamed:@"qita_jiazai_1"];
    UIImage *logo2=[UIImage imageNamed:@"qita_jiazai_2"];
    UIImage *logo3=[UIImage imageNamed:@"qita_jiazai_3"];
    UIImage *logo4=[UIImage imageNamed:@"qita_jiazai_4"];
    UIImage *logo5=[UIImage imageNamed:@"qita_jiazai_5"];
    
  
    [self addSubview:imageView];
    
    imageView.animationImages=[NSArray arrayWithObjects:logo1,logo2,logo3,logo4,logo5, nil];
    
    imageView.animationDuration=0.5;
    [imageView startAnimating];
    
    
}

@end


@implementation BlankPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)configWithType:(BlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    self.alpha=1.0;
    
    //图片
    
    if (!_logoView) {

        UITapImageView *logoView=[[UITapImageView alloc]initWithFrame:CGRectZero];
        self.logoView=logoView;
        [self addSubview:_logoView];
    }
    
    //布局
    
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.center.equalTo(self);
       
    }];
    
    //加载失败
    if (hasError) {
        //加载失败
    

        [self.logoView setImage:[UIImage imageNamed:@"logo_refresh"]];
        [self.logoView addTapBlock:block];
        
    }else{
        
        //空白数据
        

        NSString *imageName;
        switch (blankPageType) {
            case BlankPagetypeRefresh:
                imageName=@"logo_refresh";

                break;
                
            case BlankPagetypeEmpty:
                imageName=@"logo_nothing";

                break;
        }
        
        [_logoView setImage:[UIImage imageNamed:imageName]];
        
        [self.logoView addTapBlock:block];
        

    }
    
}

@end
