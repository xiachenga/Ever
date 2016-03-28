//
//  ReleaseaViewController.m
//  Ever
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

NSString *const releaseCollectionCell = @"releaseCell";
static long count=0;

#import "ReleaseaViewController.h"

#import "VPImageCropperViewController.h"



@interface ReleaseaViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    ALAssetsLibrary *library;
    
    NSMutableArray *imageArray;
    
    NSMutableArray *mutableArray;
    
    
  //  ALAssetsLibrary *library;
    NSMutableArray *mutableAssets;
}

@end

@implementation ReleaseaViewController

- (id)init
{
    //uiCollectionViewFlowLayout的初始化，
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    
    
    
    //设置每个UICollectionView的大小
    CGFloat width=(kScreen_Width-8)/3;
    layout.itemSize=CGSizeMake(width,width);
    //设置每个UICollectinView的间距
    layout.minimumInteritemSpacing=0;
    //左右间的间距
   
    //上下间的间距
    layout.minimumLineSpacing=4;
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad
{
    self.title=LOCALIZATION(@"PhotoLibrary");
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    [self setupCollectionView];
    [self getAllPictures];
    
}

- (void)setupCollectionView
{
    
    self.collectionView.backgroundColor=kColor(230, 230, 224);
    
    self.collectionView.alwaysBounceVertical=YES;
    
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:releaseCollectionCell];
}


-(void)getAllPictures {
    mutableAssets = [[NSMutableArray alloc]init];
    library = [[ALAssetsLibrary alloc] init];
    
    NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *tempMutableAssets = mutableAssets;
  //  __block UICollectionViewController *tempSelf = self;
    __block NSMutableArray *tempAssetGroups = assetGroups;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if (group != nil) {
            count = [group numberOfAssets];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                if(asset != nil) {
                    if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        [assetURLDictionaries addObject:[asset valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url= (NSURL*) [[asset defaultRepresentation]url];
                        
                        NSLog(@"%@,%@",[asset valueForProperty:ALAssetPropertyDate],url);
                        
                        //                        [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];//图片
                        //                        [UIImage imageWithCGImage:[result thumbnail]];    //缩略图
                        
                        [tempMutableAssets addObject:asset];
                        if (tempMutableAssets.count == count) {
                            
                            [self allPhotosCollected:tempMutableAssets];
                        }
                    }
                }
            }];
            [tempAssetGroups addObject:group];
        }
    }failureBlock:^(NSError *error){
        NSLog(@"There is an error");
    }];
}

-(void)allPhotosCollected:(NSMutableArray *)mutableAsset{
    [self.collectionView reloadData];
}




#pragma  mark CollectionDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long count=mutableAssets.count;
    return count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:releaseCollectionCell forIndexPath:indexPath];
    
    UIImageView *imageView=[[UIImageView alloc]init];
    CGFloat width=(kScreen_Width-8)/3;
    imageView.frame=CGRectMake(0, 0, width, width);
    
    if (cell==nil) {
        cell=[[UICollectionViewCell alloc]init];
    }
    if (indexPath.row==0) {
        
        UIImage *cameraImage=[UIImage imageNamed:@"paizhao"];
        imageView.image=cameraImage;

    }else
    {
        ALAsset *asset = mutableAssets[indexPath.row];
        UIImage *image=[UIImage imageWithCGImage:[asset thumbnail]];
        imageView.image=image;
    }
    
    [cell.contentView addSubview:imageView];
    
    
    return  cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//     UIImage *image=imageArray[indexPath.row];
    
    ALAsset *asset = mutableAssets[indexPath.row];
    UIImage *image=[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
    
     switch (indexPath.row) {
        case 0:
        {
            [self openCamera];
            
        }
            break;
            
        default:
        {
//            if (self.kind.kind!=4) {
//               
//         
                VPImageCropperViewController *imageCropVC=[[VPImageCropperViewController alloc]initWithImage:image cropFrame:CGRectMake(0, 100.f, kScreen_Width, kScreen_Width) limitScaleRatio:3];
                
            
                imageCropVC.kind=self.kind;
                
                [self.navigationController pushViewController:imageCropVC animated:YES];
//            }else{
//                
//                MyDataViewController *myDataVC=(MyDataViewController *)[self.navigationController.viewControllers objectAtIndex:1];
//                myDataVC.image=image;
//                
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }
            
        }
            break;
    }
    
}


- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
         
    }else{
        
        [MBProgressHUD showError:@"相机不可用"];
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data;
    //图片压缩，因为原图都是很大的，不必要传原图
    UIImage *scaleImage = [self scaleImage:originalImage toScale:0.3];
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    if (UIImagePNGRepresentation(scaleImage) == nil) {
        //将图片转换为JPG格式的二进制数据
       data = UIImageJPEGRepresentation(scaleImage, 1);
    } else {
        //将图片转换为PNG格式的二进制数据
        data = UIImagePNGRepresentation(scaleImage);
    }
    
   UIImage *image=[UIImage imageWithData:data];
    
    VPImageCropperViewController *imageCropVC=[[VPImageCropperViewController alloc]initWithImage:image cropFrame:CGRectMake(0, 100.f, kScreen_Width, kScreen_Width) limitScaleRatio:3];
    
  
       imageCropVC.kind=self.kind;
    
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


//- (void)languageChange
//{
//    CLog(@"收到通知");
//    
//    self.title=LOCALIZATION(@"PhotoLibrary");
//    
//    
//}
//

@end
