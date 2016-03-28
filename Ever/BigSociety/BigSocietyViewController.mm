
//
//  BigSocietyViewController.m
//  Ever
//
//  Created by Mac on 15-1-24.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "BigSocietyViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "PaoPaoAnnotation.h"
#import "WorldTagIndexResult.h"
#import "CustomAnnotation.h"
#import "CustomReleaseAnnotation.h"
#import "PaoPaoView.h"
#import "CityListViewController.h"
#import "MeetViewCotroller.h"

#import "CustomBMKAvatarView.h"

#import "GediaoDetailViewController.h"
#import "TalkDetailViewController.h"

#import <BaiduMapAPI/BMKLocationService.h>

#import "RNGridMenu.h"

#import "TalkViewController.h"
#import "ReleaseaViewController.h"


@interface BigSocietyViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,CityListViewCotrollerDelegate,BMKGeoCodeSearchDelegate,RNGridMenuDelegate>

@property (nonatomic , strong) BMKMapView *mapView;
@property (nonatomic , strong) PaoPaoAnnotation *paopaoAnnotation;
@property (nonatomic , strong) NSMutableArray *markerArray,*annotationArray;
@property (nonatomic , copy) NSString *cityName;
@property (nonatomic,strong)UIButton *locationBtn,*cameraBtn;


@property (nonatomic , strong) BMKLocationService *locService;

@property (nonatomic , strong) BMKGeoCodeSearch *geoCode;

@property (nonatomic , weak) UIView *tipView;

@property (nonatomic , assign) int itemTag;

@property (nonatomic , strong) BMKPointAnnotation *annotation;

@end
@implementation BigSocietyViewController

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}
//懒加载
- (NSMutableArray *)markerArray
{
    if (!_markerArray) {
        _markerArray=[NSMutableArray array];
    }
    return _markerArray;
}

-(NSMutableArray *)annotationArray{
    
    if (!_annotationArray) {
        _annotationArray=[NSMutableArray array];
    }
    return _annotationArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //添加刷新和定位按钮
        [self addButton];
        
        //添加位置按钮
        [self addTopView];
        
        
        //提示用户可以移动麻点
        
        [self addTipView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    BMKMapView *mapView=[[BMKMapView alloc]initWithFrame:self.view.bounds];
    mapView.delegate=self;
    mapView.zoomLevel=16;
    mapView.showsUserLocation = YES;
    self.mapView=mapView;
    mapView.centerCoordinate = CLLocationCoordinate2DMake(34.802836,113.833865);
    [self.view addSubview:mapView];
    
    
    
    
    _locService = [[BMKLocationService alloc]init];

    _locService.delegate = self;
  
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;
    
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;
    
    
}


//添加定位和刷新按钮
- (void)addButton
{

    //定位按钮
    UIButton *dingweiBtn=[self buttonWithImage:@"dashehui_dingwei" selectedImage:@"dashehui_dingwei_selceted" action:@selector(dingweiBtnClicked)];
    dingweiBtn.frame=CGRectMake(10, 140, 50 , 50);
    
    //刷新按钮
    UIButton *refreshBtn=[self buttonWithImage:@"dashehui_shuaxin" selectedImage:@"dashehui_shuaxin_selceted" action:@selector(refresh)];
    refreshBtn.frame=CGRectMake(10, 194, 50 , 50);
    
    
    UIButton *cameraBtn=[self buttonWithImage:@"dashehui_camera_nor" selectedImage:@"dashehui_camera_sel" action:@selector(cameraBtnClicked)];
    self.cameraBtn=cameraBtn;
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.mas_equalTo(self.view.mas_right).with.offset(-10);
        
    }];
}

//添加用户提示麻点移动view
- (void)addTipView{
    
    UIView *tipView=[[UIView alloc]init];
    tipView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    tipView.layer.cornerRadius=10;
    tipView.userInteractionEnabled=YES;
    self.tipView=tipView;
    [self.view addSubview:tipView];
    
    UIGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipViewClicked)];
    [tipView addGestureRecognizer:tap];
    
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        
      
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.cameraBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-150, 40));
        
    }];
    
    UILabel *tipLabel=[[UILabel alloc]init];
    [tipView addSubview:tipLabel];
    tipLabel.text=@"长按麻点可以移动位置";
    tipLabel.font=[UIFont systemFontOfSize:15];
    tipLabel.textColor=[UIColor whiteColor];
    tipLabel.textAlignment=NSTextAlignmentCenter;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tipView);
        make.size.mas_equalTo(tipView);
        
    }];

}

- (UIButton *)buttonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    static NSString *annotationIdentifier = @"customAnnotation";
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        
        BMKPinAnnotationView *annotationview = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationview.image=[UIImage imageNamed:@"dashehui_madian"];
        
        //设置可以拖动
        [annotationview setDraggable:YES];
        
        annotationview.tag=[annotation.title intValue];
        
        annotationview.canShowCallout=NO;
        return annotationview;
        
    }else if ([annotation isKindOfClass:[PaoPaoAnnotation class]])
        
    {
        PaoPaoAnnotation *paoAnnotation=(PaoPaoAnnotation *)annotation;
        
        PaoPaoView *paopaoView=(PaoPaoView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        if (!paopaoView)
        {
            paopaoView=[[PaoPaoView alloc]initWithAnnotation:annotation reuseIdentifier:@"calloutView"];
            
            paopaoView.tag=paoAnnotation.tag;
            
            paopaoView.markerModel=self.markerArray[paoAnnotation.tag];
        }
        return paopaoView;
    }else if ([annotation isKindOfClass:[CustomReleaseAnnotation class]]){
        
        BMKPinAnnotationView *annotationview = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationview.image=[UIImage imageNamed:@"pin"];
        return annotationview;
        
    }else if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        int index=[annotation.title intValue];
        WorldTagIndexResult *worldIndexResult=self.markerArray[index];
        CustomBMKAvatarView  *customAvatarView= [[CustomBMKAvatarView alloc] initWithAnnotation:annotation reuseIdentifier:@"resusede"];
        customAvatarView.image=[UIImage imageWithName:@"avatarholder"];
        customAvatarView.tag=[annotation.title intValue];
        customAvatarView.worldtagIndex=worldIndexResult;
        customAvatarView.draggable=YES;
        return customAvatarView;
    }
    
    return nil;

}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{

    WorldTagIndexResult *worldIndexResult=self.markerArray[view.tag];
    
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]||[view.annotation isKindOfClass:[CustomAnnotation class]])
    {
        _paopaoAnnotation=[[PaoPaoAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude] ;
        
        _paopaoAnnotation.tag=view.tag;
        
        self.annotation=(BMKPointAnnotation *)view.annotation;
        
        [mapView addAnnotation:_paopaoAnnotation];
        
    } else
        
    {
        if (worldIndexResult.tag_type==5) {
            
            
            
            GediaoDetailViewController *gediaoVC=[[GediaoDetailViewController alloc]init];
            gediaoVC.gediaoid=worldIndexResult.cid;
            [self.navigationController pushViewController:gediaoVC animated:YES];
            
        }else if (worldIndexResult.tag_type==3)
        {
            TalkDetailViewController *talkVC=[[TalkDetailViewController alloc]init];
            talkVC.talkid=worldIndexResult.cid;
            [self.navigationController pushViewController:talkVC animated:YES];
            
        }else if (worldIndexResult.tag_type==8)
        {
            PersonhomeViewController *personhomeVC=[[PersonhomeViewController alloc]init];
            personhomeVC.user_id=worldIndexResult.user_id;
            
            [self.navigationController pushViewController:personhomeVC animated:YES];
            
        }
        
    }
    
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if(_paopaoAnnotation&&![view isKindOfClass:[PaoPaoAnnotation class]]) {
        
        if (_paopaoAnnotation.coordinate.latitude==view.annotation.coordinate.latitude&&_paopaoAnnotation.coordinate.longitude==view.annotation.coordinate.longitude) {
            [_mapView removeAnnotation:_paopaoAnnotation];
            _paopaoAnnotation=nil;
        }
    }
}


-(void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    
    self.tipView.hidden=NO;
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (void)dealloc
{
    if (_mapView) {
        _mapView=nil;
    }
}

- (void)addTopView
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 20+44, kScreen_Width, 40)];
    topView.userInteractionEnabled=YES;
    topView.backgroundColor=[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:0.9];
    //添加按钮
    _locationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _locationBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10,0, 0);
    _locationBtn.frame=CGRectMake(0, 5, kScreen_Width, 30);
    [_locationBtn setTitle:@"当前位置:" forState:UIControlStateNormal];
    
    [_locationBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_locationBtn];
    
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-20, 10, 20, 20)];
    arrow.image=[UIImage imageNamed:@"arrow_right"];
    [topView addSubview:arrow];
    
 
    [self.view addSubview:topView];
}

#pragma BtnClicked

- (void)locationBtnClicked:(id)sender
{
    CityListViewController *cityListVC=[[CityListViewController alloc]init];
    cityListVC.delegate=self;
    [self.navigationController pushViewController:cityListVC animated:YES];
}


#pragma CityListDelegate

- (void)trsnsmitLocation:(NSString *)cityName

{
    _cityName=cityName;
    [_locationBtn setTitle:[NSString stringWithFormat:@"当前位置:%@",_cityName] forState:UIControlStateNormal];

    BMKGeoCodeSearchOption *geocodeSearchOption=[[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city=cityName;
    geocodeSearchOption.address=cityName;
    
    BOOL flag = [self.geoCode geoCode:geocodeSearchOption];
    if(flag)
    {
        CLog(@"geo检索发送成功");
    }
    else
    {
        CLog(@"geo检索发送失败");
    }
}

- (void)dingweiBtnClicked
{
   

    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;
    
}


- (void)refresh
{
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint= CLLocationCoordinate2DMake(_locService.userLocation.location.coordinate.latitude,_locService.userLocation.location.coordinate.longitude);
    
        BOOL flag = [self.geoCode reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
   
}

////处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [_mapView updateLocationData:userLocation];
    
    if (userLocation.location.coordinate.latitude != 0) {
        
        [_locService stopUserLocationService];
        
        [self refresh];
        
    }
    
}


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    
    _mapView.centerCoordinate = result.location;
    
           
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    @try {
//        
//        
//  
//
//    [_locationBtn setTitle:[NSString stringWithFormat:@"当前位置:%@",result.addressDetail.city] forState:UIControlStateNormal];
//    
//    
//    
//    NSString *urlstring=[kSeverPrefix stringByAppendingString:@"world/list"];
//        NSLog(@"请求url%@",urlstring);
//        
//    NSMutableDictionary *position=[[NSMutableDictionary alloc]init];
//    [position setValue:result.addressDetail.city forKey:@"city"];
//    [position setValue:result.address forKey:@"address"];
//    [position setValue:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"longitude"];
//    [position setValue:[NSString stringWithFormat:@"%f",result.location.latitude]  forKey:@"latitude"];
//    
//    
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//    
//    [params setValue:result.addressDetail.city forKey:@"cityName"];
//    [params setValue:position forKey:@"position"];
//    
//    [HttpTool send:urlstring params:params success:^(id responseobj) {
//        
//        NSArray *array=[NSJSONSerialization JSONObjectWithData:responseobj options:NSJSONReadingMutableContainers error:nil];
//        NSArray *worldIndexArray=[WorldTagIndexResult objectArrayWithKeyValuesArray:array];
//        
//        [self.markerArray addObjectsFromArray:worldIndexArray];
//        
//        
//        
//        [self.annotationArray removeAllObjects];
//        
//        
//        for (int i=0; i<array.count; i++) {
//            
//            WorldTagIndexResult *worldIndexResult=self.markerArray[i];
//            
//            BMKPointAnnotation* annotation;
//        
//            
//            if (worldIndexResult.tag_type==3||worldIndexResult.tag_type==5) {
//                annotation= [[CustomAnnotation alloc]init];
//            }else
//            {
//                annotation=[[BMKPointAnnotation alloc]init];
//            }
//            
//            
//            CLLocationCoordinate2D coor;
//            coor.latitude =worldIndexResult.position.latitude;
//            coor.longitude = worldIndexResult.position.longitude;
//            annotation.coordinate = coor;
//            
//            annotation.title=[NSString stringWithFormat:@"%d",i];
//            
//            [self.mapView addAnnotation:annotation];
//            
//            [self.annotationArray addObject:annotation];
//            
//            
//        }
//        
//    }];
//        
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }

    
}

#pragma RNGridMenuDelegate M
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {

    
    if ([AccountTool isLogin]){
        
        if (itemIndex==0) {
            ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
            
            KindItem *kind=[[KindItem alloc]init];
            kind.kind=2;
            releaseVC.kind=kind;
            [self.navigationController pushViewController:releaseVC animated:YES];
            
          
        }else{
            TalkViewController *talkVC=[[TalkViewController alloc]init];
            [self.navigationController pushViewController:talkVC animated:YES];
        
        }
        
    }else{
        
        DoAlertView *alertView=[[DoAlertView alloc]init];
        [alertView show];
        
    }
}

//点击发布
- (void)cameraBtnClicked{
    
    NSInteger numberOfOptions = 2;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"fabu_riji"] title:@"日记"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"fabu_zhaopian"] title:@"照片"],
                       
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.animationDuration=0.5;
    av.cornerRadius=0;
    av.highlightColor=nil;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    
}

- (void)tipViewClicked{
    
    self.tipView.hidden=YES;
    
}


//删除麻点
- (void)gediaoDeleteRefrsh{
    
 
    
    [self.mapView removeAnnotation:self.annotation];
    
    
    
}


@end
