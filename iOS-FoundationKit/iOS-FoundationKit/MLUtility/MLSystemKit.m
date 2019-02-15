//
//  MLSystemKit.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLSystemKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Macro.h"

@interface MLSystemKit()<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CLLocationManager           *_locationManager;              //!< 定位管理器
    CLLocationCoordinate2D      _coordinate;                    //!< 当前经纬度
    CLLocation                  *_lastLocation;
}

@end

@implementation MLSystemKit

+ (void)registeNotification
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge| UIUserNotificationTypeSound|UIUserNotificationTypeAlert  categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //申请使用通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma -mark 定位功能
- (instancetype)initWithType:(MLSystemType)type
{
    self = [super init];
    if (self) {
        switch (type) {
            case MLSystem_Location:
            {
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.delegate = self;
                _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            }
                break;
            case MLSystem_Camera:
            default:
                break;
        }
    }
    return self;
}

- (void)startUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //开始定位，不断调用其代理方法
        [_locationManager startUpdatingLocation];
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
    }
    else {
        //定位不能用
    }
}

#pragma mark - Delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //获取用户位置的对象
    CLLocation *location = [locations lastObject];
    _lastLocation = location;
    //停止定位
    [manager stopUpdatingLocation];
    
//    CLLocationCoordinate2D chinaCoordinate = [self transformFromWGSToGCJ:location.coordinate];
//
//    //转化为BD09格式
//    Location oldlocation;
//    oldlocation.lat = chinaCoordinate.latitude;
//    oldlocation.lng = chinaCoordinate.longitude;
//    Location newlocation = bd_encrypt(oldlocation);
//    _coordinate.latitude = newlocation.lat;
//    _coordinate.longitude = newlocation.lng;
    
    [self requestLocationAddress];
}

- (void)requestLocationAddress
{
    CLLocation *newLocation = _lastLocation;
    if (!newLocation) {
        return;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (! error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                
                ML_LOG(@"placemark:%@",placemark);
                if (self->_locationBlock) {
                    self->_locationBlock(placemark,newLocation.coordinate);
                }
            }
        }else {
            ML_LOG(@"error:%@",error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        //被用户禁止
    }
    else
    {
        //其他错误
    }
}

#pragma -mark 选择照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] copy];
        
        ML_LOG(@"照片图片：%@",image);
        if (_imagePickerBlock) {
            _imagePickerBlock(image);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes = mediatypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        
        [[self currentViewController] presentViewController:picker animated:YES completion:nil];
    }
    else{
        //提示语
    }
}

#pragma mark - private
- (UIViewController *)rootViewController
{
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
    {
        result = topWindow.rootViewController;
    }
    else
    {
    }
    return result;
}
 
- (UIViewController*)currentViewController
{
    UIViewController *controller = [self rootViewController];
    
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    return controller;
}


@end
