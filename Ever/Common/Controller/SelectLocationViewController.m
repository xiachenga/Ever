//
//  SelectLocationViewController.m
//  Ever
//
//  Created by Mac on 15/8/14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "SelectLocationViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ReleaseaViewController.h"
#import "TalkViewController.h"
#import "CityListViewController.h"

@interface SelectLocationViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,CityListViewCotrollerDelegate>

@property (nonatomic , strong) BMKGeoCodeSearch *geoCode;

@property (nonatomic , weak) BMKMapView *mapView;

@property (nonatomic , strong) BMKPointAnnotation *lastPointAnnotation;

@property (nonatomic , strong) BMKLocationService *locService;

@property (nonatomic , weak) UIButton *cityBtn;

@end

@implementation SelectLocationViewController

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=LOCALIZATION(@"PublishSelectionLocation");
    self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:LOCALIZATION(@"PhotoNextStep") style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    
    //加载地图
    
    BMKMapView *mapView=[[BMKMapView alloc]initWithFrame:self.view.bounds];
    mapView.delegate=self;
    mapView.zoomLevel=12;
    mapView.showsUserLocation = YES;
    self.mapView=mapView;
   // mapView.centerCoordinate = CLLocationCoordinate2DMake(34.802836,113.833865);
    [self.view addSubview:mapView];
    
    //地图顶部的view
    [self addTopView];
    
    
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


- (void)addTopView {
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, 100)];
    topView.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    [self.view addSubview:topView];
    
    //cityBtn
    UIButton *cityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
  //  [cityBtn setTitle:@"郑州市" forState:UIControlStateNormal];
    self.cityBtn=cityBtn;
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    cityBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    cityBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    cityBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    cityBtn.frame=CGRectMake(0, 10, kScreen_Width, 50);
    [cityBtn setBackgroundColor:[UIColor whiteColor]];
    [cityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cityBtn];
    
    //向下的箭头
    UIImageView *downArrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_down"]];
    [topView addSubview:downArrow];
    [downArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(cityBtn);
        make.right.mas_equalTo(cityBtn.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    
    }];
    
    
    //笑脸
    
    UIImageView *smileView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smile"]];
    smileView.frame=CGRectMake(13, 67, 25, 25);
    [topView addSubview:smileView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(smileView.frame)+5, 70, 200, 20)];
    label.text=@"点击选择位置";
    label.font=[UIFont boldSystemFontOfSize:15];
    label.textColor=[UIColor grayColor];
    [topView addSubview:label];
    

}


-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    
    //把上一个annotation删除
    
    if (self.lastPointAnnotation!=nil) {
        [self.mapView removeAnnotation:self.lastPointAnnotation];
    }
    
    
    BMKPointAnnotation *annotation=[[BMKPointAnnotation alloc]init];
    annotation.coordinate=coordinate;

    [self.mapView  addAnnotation:annotation];
    
    self.lastPointAnnotation=annotation;
    
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint= CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
    
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

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    static NSString *identifier = @"Annotation";
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *annotationview = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationview.image=[UIImage imageNamed:@"pin"];
    
        return annotationview;
    }
    
    return nil;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    if (self.cityBtn.titleLabel.text.length==0) {
        [self.cityBtn setTitle:result.addressDetail.city forState:UIControlStateNormal];
        
    }
    
    NSMutableDictionary *position=[[NSMutableDictionary alloc]init];
    [position setValue:result.addressDetail.city forKey:@"city"];
    [position setValue:result.address forKey:@"address"];
    [position setValue:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"longitude"];
    [position setValue:[NSString stringWithFormat:@"%f",result.location.latitude]  forKey:@"latitude"];
    
    //赋值
    
    self.kindItem.position=position;
    
    
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [_mapView updateLocationData:userLocation];
    

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint= CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    BOOL flag = [self.geoCode reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    
    if (userLocation.location.coordinate.latitude != 0) {
        
        [_locService stopUserLocationService];
        
    }
    
}


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    
    _mapView.centerCoordinate = result.location;
    
    
    
    BMKPointAnnotation *annotation=[[BMKPointAnnotation alloc]init];
    annotation.coordinate=result.location;
    self.lastPointAnnotation=annotation;

    [self.mapView  addAnnotation:annotation];
    
   
    
    
    NSMutableDictionary *position=[[NSMutableDictionary alloc]init];
    [position setValue:result.address forKey:@"city"];
    [position setValue:result.address forKey:@"address"];
    [position setValue:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"longitude"];
    [position setValue:[NSString stringWithFormat:@"%f",result.location.latitude]  forKey:@"latitude"];
    

    self.kindItem.position=position;
    
    
}

//下一步
- (void)nextStep {
    
    if (self.kindItem.kind==2) {
        
        ReleaseaViewController *releaseVC=[[ReleaseaViewController alloc]init];
        
        releaseVC.kind=self.kindItem;
        
        [self.navigationController pushViewController:releaseVC animated:YES];
    }else if (self.kindItem.kind==3){
        
        TalkViewController *talkVC=[[TalkViewController alloc]init];
        
        talkVC.kindItem=self.kindItem;
        
        [self.navigationController pushViewController:talkVC animated:YES];
        
    }
        
        
    
    
   
    
    
}

//选择城市

- (void)selectCity {
    
    CityListViewController *cityListVC=[[CityListViewController alloc]init];
    cityListVC.delegate=self;
    [self.navigationController pushViewController:cityListVC animated:YES];
    
}

#pragma mark CityListViewControllerDelegate

- (void)trsnsmitLocation:(NSString *)cityName {
    
    CLog(@"%@",cityName);
    
    [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
    
    
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

-(void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
}

- (void)dealloc
{
    if (_mapView) {
        _mapView=nil;
    }
}




@end
