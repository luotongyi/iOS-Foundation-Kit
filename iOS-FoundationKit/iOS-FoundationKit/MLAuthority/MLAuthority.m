//
//  MLAuthority.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/8/19.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLAuthority.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <Speech/Speech.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

@implementation MLAuthority

+ (void)checkAuthority:(MLAuthorityType)authType complete:(void (^)(BOOL result))completeBlock{
    
    switch (authType) {
            case MLCamera:
            case MLMedia:
            {
                [self checkCameraAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLMicrophone:
            {
                [self checkMicrophoneAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLPhotoLibrary:
            {
                [self checkPhotoLibraryAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLContacts:
            {
                [self checkContactsAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLSpeech:
            {
                [self checkSpeechAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLLocation:
            {
                [self checkLocationAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLBluetooth:
            {
                [self checkBluetoothAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
            case MLUserNotification:
            {
                [self checkUserNotificationAuthority:^(BOOL result) {
                    completeBlock(result);
                }];
                break;
            }
        default:
            completeBlock(NO);
            break;
    }
    
}

+ (void)checkCameraAuthority :(void (^)(BOOL result))completeBlock{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                } else {
                    if (completeBlock) {
                        completeBlock(NO);
                    }
                }
            });
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        if (completeBlock) {
            completeBlock(YES);
        }
    } else {
        if (completeBlock) {
            completeBlock(NO);
        }
    }
}

+ (void)checkMicrophoneAuthority :(void (^)(BOOL result))completeBlock {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                } else {
                    if (completeBlock) {
                        completeBlock(NO);
                    }
                }
            });
        }];
        
    } else if(authStatus == AVAuthorizationStatusAuthorized){
        if (completeBlock) {
            completeBlock(YES);
        }
    } else {
        if (completeBlock) {
            completeBlock(NO);
        }
    }
}

+ (void)checkPhotoLibraryAuthority :(void (^)(BOOL result))completeBlock {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    //首次安装APP，用户还未授权 系统会请求用户授权
    if (authStatus == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                } else {
                    if (completeBlock) {
                        completeBlock(NO);
                    }
                }
            });
        }];
    }
    else if (authStatus == PHAuthorizationStatusAuthorized) {
        completeBlock(YES);
    }
    else {
        completeBlock(NO);
    }
}

+ (void)checkContactsAuthority :(void (^)(BOOL result))completeBlock {
    CNContactStore * contactStore = [[CNContactStore alloc]init];
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] ;
    if (status== CNAuthorizationStatusNotDetermined) {
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (completeBlock) {
                        completeBlock(NO);
                    }
                    return;
                }
                if (granted) {
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                } else {
                    if (completeBlock) {
                        completeBlock(NO);
                    }
                }
            });
        }];
    }
    else if (status == CNAuthorizationStatusAuthorized) {
        completeBlock(YES);
    }
    else {
        completeBlock(NO);
    }
    
}

+ (void)checkLocationAuthority:(void (^)(BOOL result))completeBlock{
    //先判断定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        completeBlock(NO);
    }
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if(authStatus == kCLAuthorizationStatusNotDetermined){
        if (completeBlock) {
            completeBlock(YES);
        }
    }
    else if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
        authStatus == kCLAuthorizationStatusAuthorizedAlways) {
        if (completeBlock) {
            completeBlock(YES);
        }
    } else {
        completeBlock(NO);
    }
    
}

+ (void)checkBluetoothAuthority:(void (^)(BOOL result))completeBlock{
    CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    if (authStatus == CBPeripheralManagerAuthorizationStatusNotDetermined) {
//        CBCentralManager *cbManager = [[CBCentralManager alloc] init];
//        [cbManager scanForPeripheralsWithServices:nil options:nil];
        if (completeBlock) {
            completeBlock(YES);
        }
    } else if (authStatus == CBPeripheralManagerAuthorizationStatusAuthorized) {
        if (completeBlock) {
            completeBlock(YES);
        }
    } else {
        completeBlock(NO);
    }
}

+ (void)checkSpeechAuthority :(void (^)(BOOL result))completeBlock{
    SFSpeechRecognizerAuthorizationStatus authStatus = [SFSpeechRecognizer authorizationStatus];
    if (authStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                } else {
                    if (completeBlock) {
                        completeBlock(NO);
                    }
                }
            });
        }];
    } else if (authStatus == SFSpeechRecognizerAuthorizationStatusAuthorized){
        if (completeBlock) {
            completeBlock(YES);
        }
    } else {
        if (completeBlock) {
            completeBlock(NO);
        }
    }
}

+ (void)checkUserNotificationAuthority :(void (^)(BOOL result))completeBlock{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (completeBlock) {
                    completeBlock(YES);
                }
            } else {
                if (completeBlock) {
                    completeBlock(NO);
                }
            }
        });
    }];
}


@end
