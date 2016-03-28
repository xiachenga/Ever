//
//  AddSoundViewController.m
//  Ever
//
//  Created by Mac on 15-5-19.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "AddSoundViewController.h"


#import <AVFoundation/AVFoundation.h>

@interface AddSoundViewController ()<AVAudioRecorderDelegate>

@property (nonatomic , strong) AVAudioRecorder *recorder;

@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , strong) AVAudioPlayer *AUPlayer;

//录音存放路径
@property (nonatomic , strong) NSURL *audioPath;

//录音的音量变化
@property (nonatomic , weak) UIImageView *imageView,*bgImageView;

@property (nonatomic , assign) int luyinTime,colorType;



@end

@implementation AddSoundViewController

- (void)viewDidLoad{
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.title=@"添加语音";
    
    
    
    [self prepareAudio];
    
    //创建颜色按钮
    
    NSArray *colorArray=@[@"c9171e", @"ee827c", @"f6ad49", @"fcc800", @"c7dc68", @"69b076", @"83ccd2", @"8491c3", @"867ba9", @"000000"];
    for (int i=0 ; i<colorArray.count; i++) {
        NSString *colorString=colorArray[i];
        [self addColorButton:colorString frame:CGRectMake((kScreen_Width-10*20)*0.5+i*20, 100, 20, 100) buttonTag:i];
    }
    
    //创建录音按钮
    [self addRecordBtn];
    
    //添加播放按钮
    [self addPlayBtn];
    
    //创建确定按钮
    [self addSureBtn];
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

- (void)addRecordBtn
{
    UIButton *recordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame=CGRectMake((kScreen_Width-100)*0.5, kScreen_Height-200, 100, 100);
    [recordBtn setImage:[UIImage imageNamed:@"fabu_biaoqian_yuyin"] forState:UIControlStateNormal];
    recordBtn.adjustsImageWhenHighlighted=NO;
    [recordBtn addTarget:self action:@selector(recordBtnDown:) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(recordBtnDrag:) forControlEvents:UIControlEventTouchDragExit];
    [recordBtn addTarget:self action:@selector(recordBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    
}

- (void)addPlayBtn
{
    UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_0.9"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
    self.colorType=0;
    
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 230, kScreen_Width-2*20, 50)];
    bgImageView.userInteractionEnabled=YES;
    self.bgImageView=bgImageView;
    bgImageView.image=bgImage;
    [self.view addSubview:bgImageView];
    
    
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"laba"] forState:UIControlStateNormal];
    playBtn.frame=CGRectMake(0, 5, 36, 36);
    [playBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:playBtn];
}


- (void)addSureBtn
{
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setFrame:CGRectMake(20, kScreen_Height-60, kScreen_Width-2*20, 40)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"dashehui_anniu_huang_selected"] forState:UIControlStateHighlighted];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}
//录音准备
- (void)prepareAudio
{
    //录音设置
    NSMutableDictionary *recordSetting=[NSMutableDictionary dictionary];
    //设置录音格式
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    
    //录音通道数
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    
    //线性采样位数
    
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    
    
    NSString *strUrl=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/audio.aac",strUrl]];
    
    self.audioPath=url;
    
    NSError *error;
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    //初始化
    
    AVAudioRecorder *recorder=[[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
    self.recorder=recorder;
    //开启音量检测
    recorder.meteringEnabled=YES;
    recorder.delegate=self;

}

- (void)buttonClicked:(UIButton *)button
{
    self.colorType=button.tag;
    switch (button.tag) {
        case 0:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_0.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            
            break;
            
        case 1:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_1.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
            
        case 2:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_2.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
            
        case 3:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_3.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
        case 4:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_4.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
        case 5:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_5.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
        case 6:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_6.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
            
        case 7:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_7.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
            
        case 8:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_8.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
        case 9:
        {
            UIImage *bgImage = [UIImage imageNamed:@"fabu_qipao_9.9"];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
            self.bgImageView.image=bgImage;
        }
            break;
            
    }
    
}

- (void)recordBtnDown:(UIButton *)button
{
    CLog(@"开始录音了");
    
    
    
   // 音量图标
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width-75)*0.5, CGRectGetMinY(self.bgImageView.frame)-50, 75, 111)];
    imageView.image=[UIImage imageNamed:@"record_animate_01"];
    
    UIWindow *widdow=[UIApplication sharedApplication].keyWindow;
    
    
    self.imageView=imageView;
    [widdow addSubview:imageView];
    

    
    
    [self.recorder prepareToRecord];
    
    [self.recorder record];
    
    //设置定时检测
    
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    self.timer=timer;
    
}

- (void)recordBtnDrag:(UIButton *)button
{
    CLog(@"删除录音");
    
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    
    UIImageView *garbageBox=[[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width-75)*0.5, kScreen_Height-280, 75, 75)];
    garbageBox.image=[UIImage imageNamed:@"yuyinshanchu"];
    [self.view addSubview:garbageBox];
    garbageBox.alpha=0;
    [UIView animateWithDuration:1.0 animations:^{
        garbageBox.alpha=1.0;
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:1.0 animations:^{
            garbageBox.alpha=0;
            
        } completion:^(BOOL finished) {
            
            [garbageBox removeFromSuperview];
            
        }];
    
        //删除录制文件
        [self.recorder deleteRecording];
        [self.recorder stop];
        [self.timer invalidate];
        
    }];

}

- (void)recordBtnUp:(UIButton *)button
{
    
    CLog(@"录音结束");
    
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    
    int cTime=self.recorder.currentTime;
    
    self.luyinTime=cTime;
    if (cTime>2) {
        CLog(@"录音成功");
    }else{
    
        CLog(@"录音失败");
        [self.recorder deleteRecording];
    }
    
    [self.recorder stop];
    [self.timer invalidate];
}

- (void)playAudio:(UIButton *)button
{
    CLog(@"要播放录音了");
    
    if (self.AUPlayer.playing) {
        [self.AUPlayer stop];
        return;
    }
    
    AVAudioPlayer *player=[[AVAudioPlayer alloc]initWithContentsOfURL:self.audioPath error:nil];
    self.AUPlayer=player;
    [player play];
}

- (void)detectionVoice
{
    //刷新音量数据
    [self.recorder updateMeters];
    
     double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
     if (0<lowPassResults<=0.06) {
        
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14"]];
    }

}

- (void)sureBtnClicked:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(selectColor_type: pathForAudio: lastTime:)]) {
        [self.delegate selectColor_type:2 pathForAudio:self.audioPath lastTime:self.luyinTime];
    }
}

@end
