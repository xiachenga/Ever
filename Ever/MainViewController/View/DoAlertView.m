//
//  DoAlertView.m
//  TestAlert
//
//  Created by Donobono on 2013. 12. 19..
//

#import "DoAlertView.h"
//#import "UIImage+ResizeMagick.h"    //  Created by Vlad Andersen on 1/5/13.

#pragma mark - DoAlertViewController

//@interface DoAlertViewController : UIViewController
//
//@property (nonatomic, strong) DoAlertView *alertView;
//
//@end

//@implementation DoAlertViewController

#pragma mark - View life cycle

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.view = _alertView;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return [UIApplication sharedApplication].statusBarStyle;
//}
//
//@end


#pragma mark - DoAlertViewController

@implementation DoAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}


- (void)doYesNo:(NSString *)strBody
            yes:(DoAlertViewHandler)yes
             no:(DoAlertViewHandler)no
{
    _strAlertTitle  = nil;
    _strAlertBody   = strBody;
    _bNeedNo        = YES;
    
    _doYes  = yes;
    _doNo   = no;
    
    [self showAlertView];
}



- (void)hideAlert
{
    _nTag = DO_YES_TAG;
    [self hideAnimation];
}

- (void)showAlertView
{
    double dHeight = 0;
    
    self.backgroundColor = DO_DIMMED_COLOR;
    
    _vAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DO_VIEW_WIDTH, 0)];
    _vAlert.backgroundColor = DO_RGBA(255, 255, 255, 0.9);

    
    
    [self addSubview:_vAlert];
    
    if (_strAlertTitle != nil && _strAlertTitle.length > 0)
    {
        UIView *vTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vAlert.frame.size.width, 0)];
        if (_bDestructive)
            vTitle.backgroundColor = DO_DESTRUCTIVE_BOX;
        else
            vTitle.backgroundColor = DO_TITLE_BOX;
        
        [_vAlert addSubview:vTitle];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(DO_TITLE_INSET.left, DO_TITLE_INSET.top,
                                                                     _vAlert.frame.size.width - (DO_TITLE_INSET.left + DO_TITLE_INSET.right) , 0)];
        lbTitle.text = _strAlertTitle;
        [self setLabelAttributes:lbTitle];
        lbTitle.frame = CGRectMake(DO_TITLE_INSET.left, DO_TITLE_INSET.top, lbTitle.frame.size.width, [self getTextHeight:lbTitle]);
        [vTitle addSubview:lbTitle];
        
        vTitle.frame = CGRectMake(0, 0, _vAlert.frame.size.width, lbTitle.frame.size.height + (DO_TITLE_INSET.top + DO_TITLE_INSET.bottom));
        dHeight = vTitle.frame.size.height + 1;
    }

    UIView *vBody = [[UIView alloc] initWithFrame:CGRectMake(0, dHeight - 0.5, _vAlert.frame.size.width, 0)];
    [_vAlert addSubview:vBody];
    if (_bDestructive)
        vBody.backgroundColor = kThemeColor;
    else
        vBody.backgroundColor = kThemeColor;

   
    double dContentOffset = [self addContent:vBody];
    
    UILabel *lbBody = [[UILabel alloc] initWithFrame:CGRectMake(DO_LABEL_INSET.left, DO_LABEL_INSET.top + dContentOffset,
                    _vAlert.frame.size.width - (DO_LABEL_INSET.left + DO_LABEL_INSET.right) , 0)];
    lbBody.text = _strAlertBody;
    [self setLabelAttributes:lbBody];
    lbBody.frame = CGRectMake(DO_LABEL_INSET.left, lbBody.frame.origin.y, lbBody.frame.size.width, [self getTextHeight:lbBody]);
    [vBody addSubview:lbBody];
    
    vBody.frame = CGRectMake(0, dHeight - 0.5, _vAlert.frame.size.width,
                             dContentOffset + lbBody.frame.size.height + (DO_LABEL_INSET.top + DO_LABEL_INSET.bottom) + 0.5);
    dHeight += vBody.frame.size.height;
    
    if (_doNo != nil)
    {
        UIButton *btNo = [UIButton buttonWithType:UIButtonTypeCustom];
        btNo.frame = CGRectMake(0, dHeight, _vAlert.frame.size.width / 2.0 - 1, 40);
        btNo.backgroundColor = DO_BUTTON_BOX;
        btNo.tag = DO_NO_TAG;
        [btNo setTitle:@"取消" forState:UIControlStateNormal];
        
        [btNo addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        [_vAlert addSubview:btNo];
    }
    
    if (_doYes != nil)
    {
        UIButton *btYes = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_doNo == nil)
            btYes.frame = CGRectMake(0, dHeight, _vAlert.frame.size.width, 40);
        else
            btYes.frame = CGRectMake(_vAlert.frame.size.width / 2.0 - 0.5, dHeight, _vAlert.frame.size.width / 2.0 + 0.5, 40);

        btYes.backgroundColor = DO_BUTTON_BOX;
        btYes.tag = DO_YES_TAG;

        [btYes setTitle:@"登录" forState:UIControlStateNormal];
        [btYes addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        [_vAlert addSubview:btYes];
        
        dHeight += 40;
    }
    
    _vAlert.frame = CGRectMake(0, 0, DO_VIEW_WIDTH, dHeight);


    if (!_alertWindow)
    {
      
        
        
        UIWindow *window =[UIApplication sharedApplication].keyWindow;
        
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        

       self.frame = window.frame;
        
      _vAlert.center = window.center;
        
        [window addSubview:self];
        
    }
  
    
    if (_dRound > 0)
    {
        CALayer *layer = [_vAlert layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:_dRound];
    }
    
    [self showAnimation];
}

- (void)buttonTarget:(id)sender
{
    _nTag = (int)[sender tag];
    [self hideAnimation];
}

- (double)addContent:(UIView *)vBody
{
    double dContentOffset = 0;

    switch (_nContentMode) {
        case DoContentImage:
        {

        }
            break;
    

        default:
            break;
    }
    
    return dContentOffset;
}

- (double)getTextHeight:(UILabel *)lbText
{
    NSDictionary *attributes = @{NSFontAttributeName:lbText.font};
    CGRect rect = [lbText.text boundingRectWithSize:CGSizeMake(lbText.frame.size.width, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    
    return ceil(rect.size.height);
}

- (void)setLabelAttributes:(UILabel *)lb
{
    lb.backgroundColor = [UIColor clearColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 0;
    
    if (_bDestructive)
    {
        lb.font = DO_BOLD_FONT;
        lb.textColor = DO_DESTRUCTIVE_TEXT_COLOR;
    }
    else
    {
        lb.font = DO_TEXT_FONT;
        lb.textColor = DO_TEXT_COLOR;
    }
}

- (void)hideAlertView
{
    if (_doDone != nil)
        _doDone(self);
    else
    {
        if (_nTag == DO_YES_TAG)
            _doYes(self);
        else
            _doNo(self);
    }
    
    [self removeFromSuperview];
    [_alertWindow removeFromSuperview];
    _alertWindow = nil;
}

- (void)showAnimation
{
    CGRect r = _vAlert.frame;
    CGPoint ptCenter = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.alpha = 0.0;
    
    switch (_nAnimationType) {
        case DoTransitionStyleTopDown:
            _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, -self.bounds.size.height / 2.0);
            break;
        
        case DoTransitionStyleBottomUp:
            _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + self.bounds.size.height);
            break;

        case DoTransitionStyleFade:
            _vAlert.center = ptCenter;
            _vAlert.alpha = 0.0;
            break;

        case DoTransitionStylePop:
            _vAlert.alpha = 0.0;
            _vAlert.center = ptCenter;
            _vAlert.transform = CGAffineTransformMakeScale(0.05, 0.05);
            break;

        case DoTransitionStyleLine:
            _vAlert.frame = CGRectMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0, 1, 1);
            _vAlert.clipsToBounds = YES;
            break;
            
        default:
            break;
    }
    
    double dDuration = 0.2;
    
    switch (_nAnimationType) {
        case DoTransitionStyleTopDown:
        case DoTransitionStyleBottomUp:
            dDuration = 0.3;
            break;
            
        default:
            break;
    }

    [UIView animateWithDuration:dDuration animations:^(void) {

        self.alpha = 1.0;

        switch (_nAnimationType) {
            case DoTransitionStyleTopDown:
            case DoTransitionStyleBottomUp:
                _vAlert.center = ptCenter;
                break;
            
            case DoTransitionStyleFade:
                _vAlert.alpha = 1.0;
                break;

            case DoTransitionStylePop:
                _vAlert.alpha = 1.0;
                _vAlert.transform = CGAffineTransformMakeScale(1.05, 1.05);
                break;
                
            case DoTransitionStyleLine:
                _vAlert.frame = CGRectMake((self.bounds.size.width - DO_VIEW_WIDTH) / 2, self.bounds.size.height / 2.0, DO_VIEW_WIDTH, 1);
                break;

        }
        
    } completion:^(BOOL finished) {
        
        switch (_nAnimationType) {
            case DoTransitionStylePop:
            {
                [UIView animateWithDuration:0.1 animations:^(void) {
                    _vAlert.alpha = 1.0;
                    _vAlert.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
                break;

            case DoTransitionStyleLine:
            {
                [UIView animateWithDuration:0.2 animations:^(void) {
                    [UIView setAnimationDelay:0.1];
                    _vAlert.center = ptCenter;
                    _vAlert.frame = CGRectMake(_vAlert.frame.origin.x, _vAlert.frame.origin.y - r.size.height / 2.0, r.size.width, r.size.height);
                }];
            }
                break;
        }
    }];
}

- (void)hideAnimation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

    double dDuration = 0.2;
    switch (_nAnimationType) {
        case DoTransitionStyleTopDown:
        case DoTransitionStyleBottomUp:
            dDuration = 0.3;
            break;
        case DoTransitionStylePop:
            dDuration = 0.1;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:dDuration animations:^(void) {

        switch (_nAnimationType) {
            case DoTransitionStyleTopDown:
                if (_nTag == DO_YES_TAG)
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + self.bounds.size.height);
                else
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, -self.bounds.size.height / 2.0);

                [UIView setAnimationDelay:0.1];
                self.alpha = 0.0;
                break;
            
            case DoTransitionStyleBottomUp:
                if (_nTag == DO_YES_TAG)
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, -self.bounds.size.height / 2.0);
                else
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + self.bounds.size.height);

                [UIView setAnimationDelay:0.1];
                self.alpha = 0.0;
                break;

            case DoTransitionStyleFade:
                _vAlert.alpha = 0.0;

                [UIView setAnimationDelay:0.1];
                self.alpha = 0.0;
                break;

            case DoTransitionStylePop:
                _vAlert.transform = CGAffineTransformMakeScale(1.05, 1.05);
                break;

            case DoTransitionStyleLine:
                _vAlert.frame = CGRectMake((self.bounds.size.width - DO_VIEW_WIDTH) / 2, self.bounds.size.height / 2.0, DO_VIEW_WIDTH, 1);
                break;
        }
        
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.2 animations:^(void) {
            
            switch (_nAnimationType) {
                case DoTransitionStylePop:
                    [UIView setAnimationDelay:0.05];
                    self.alpha = 0.0;
                    _vAlert.transform = CGAffineTransformMakeScale(0.05, 0.05);
                    _vAlert.alpha = 0.0;
                    break;

                case DoTransitionStyleLine:
                    [UIView setAnimationDelay:0.1];
                    _vAlert.frame = CGRectMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0, 1, 1);

                    [UIView setAnimationDelay:0.2];
                    self.alpha = 0.0;
                    break;
            }
            
        } completion:^(BOOL finished) {
            [self hideAlertView];
        }];
    }];
}

-(void)receivedRotate: (NSNotification *)notification
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        [UIView animateWithDuration:0.1 animations:^(void) {

            _vAlert.alpha = 0.0;
            
        } completion:^(BOOL finished) {

            [UIView animateWithDuration:0.2 animations:^(void) {
                _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
                _vAlert.alpha = 1.0;
            }];
        }];
    });
}

-(void)show
{
    self.nAnimationType=3;
    self.dRound=2;
    self.bDestructive=YES;
    
    [self doYesNo:@"是否登录账号" yes:^(DoAlertView *alertView) {
        
        NSLog(@"登录");
    
        
        [ GoIntoMainScreen gotoLogin];
        
        
    } no:^(DoAlertView *alertView) {
        
        
    }];
    
}
@end
