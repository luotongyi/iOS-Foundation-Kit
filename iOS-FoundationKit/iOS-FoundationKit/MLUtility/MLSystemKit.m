//
//  MLSystemKit.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLSystemKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import "Macro.h"

@interface MLSystemKit()<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,CNContactPickerDelegate>
{
    CLLocationManager           *_locationManager;              //!< 定位管理器
    CLLocationCoordinate2D      _coordinate;                    //!< 当前经纬度
    CLLocation                  *_lastLocation;
    
    AVCaptureSession *_session;
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
            case MLSystem_QRCode:
            case MLSystem_Contact:
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
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        ML_LOG(@"%@",@"请打开相机权限");
        return;
    }
    
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

#pragma -mark 二维码扫描
- (void)startCamera:(UIView *)view
{
    if (_session) {
        [_session startRunning];
        return;
    }
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        ML_LOG(@"%@",@"请打开相机权限");
        return;
    }
    
    _session = [[AVCaptureSession alloc]init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
        // output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        output.metadataObjectTypes =  @[AVMetadataObjectTypeQRCode,//二维码
                                        //以下为条形码，如果项目只需要扫描二维码，下面都不要写
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeUPCECode,
                                        AVMetadataObjectTypeCode39Code,
                                        AVMetadataObjectTypeCode39Mod43Code,
                                        AVMetadataObjectTypeCode93Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypePDF417Code];
    }
    //    if (_rect.size.width == 0 || _rect.size.height == 0) {
    //        output.rectOfInterest = CGRectMake(CROP_RECT.origin.y/(CGRectGetHeight([UIScreen mainScreen].bounds)-20-44), CROP_RECT.origin.x/kscreenWidth, CROP_RECT.size.height/(CGRectGetHeight([UIScreen mainScreen].bounds)-20-44), CROP_RECT.size.width/kscreenWidth);
    //    }
    //    else{
    //        output.rectOfInterest = CROP_RECT;
    //    }
    //    output.rectOfInterest = CROP_RECT;
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    AVCaptureVideoPreviewLayer * avLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avLayer.frame = [UIScreen mainScreen].bounds;
    [view.layer insertSublayer:avLayer atIndex:0];
    [_session startRunning];
}

- (void)stopCamera
{
    [_session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue = @"";
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        stringValue = metadataObject.stringValue;
    }
    [self operate:stringValue];
}

- (void)operate:(NSString *)symbolStr{
    [_session stopRunning];
    //扫描结果
    if (_QRHandleBlock) {
        _QRHandleBlock(symbolStr);
    }
}

#pragma -mark 通讯录
- (void)openContact
{
    // 获得通讯录的授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 判断当前的授权状态
    if (status != CNAuthorizationStatusAuthorized)
    {
        ML_LOG(@"您的通讯录暂未允许访问，请去设置->隐私里面授权!");
        return;
    }
    // 判断当前的授权状态是否是用户还未选择的状态
    if (status == CNAuthorizationStatusNotDetermined)
    {
        CNContactStore *store = [CNContactStore new];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                // 1.创建选择联系人的控制器
                CNContactPickerViewController *contactControl = [[CNContactPickerViewController alloc] init];
                // 2.设置代理
                contactControl.delegate = self;
                [[self currentViewController] presentViewController:contactControl animated:YES completion:nil];
            }
            else
            {
                ML_LOG(@"授权失败!");
            }
        }];
    }
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    ML_LOG(@"%@",@"取消选择联系人");
}
// 2.当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSString *name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    ML_LOG(@"%@ %@", lastname, firstname);
    
    // 2.获取联系人的电话号码(此处获取的是该联系人的第一个号码,也可以遍历所有的号码)
    NSArray *phoneNums = contact.phoneNumbers;
    
    NSMutableArray *phones = [[NSMutableArray alloc]init];
    for (int i=0; i<phoneNums.count; i++) {
        CNLabeledValue *labeledValue = phoneNums[i];
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneNumber = phoneNumer.stringValue;
        ML_LOG(@"%@", phoneNumber);
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([phoneNumber hasPrefix:@"+86"]) {
            phoneNumber = [phoneNumber substringFromIndex:4];
        }
        [phones addObject:phoneNumber];
    }
    ML_LOG(@"%@",phones);
    
    NSDictionary *dict = @{@"name":name,@"phones":phones};
    if (_selectContactBlock) {
        _selectContactBlock(dict);
    }
}


@end
