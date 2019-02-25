//
//  MLViewUtility.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/15.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLViewUtility.h"

@implementation MLViewUtility

+ (UIView *)setUpCorner:(UIRectCorner )corner size:(CGSize )radio view:(UIView *)child
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:child.bounds byRoundingCorners:corner cornerRadii:radio];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
    masklayer.frame = child.bounds;
    masklayer.path = path.CGPath;//设置路径
    child.layer.mask = masklayer;
    child.layer.shouldRasterize = YES; //圆角缓存
    child.layer.rasterizationScale = [UIScreen mainScreen].scale;//提高流畅度
    
    return child;
}

+ (UIImage *)stringConvertToImage:(NSString *)qrString size:(CGFloat)rectSize
{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:rectSize];
    
    return image;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (void)alertController:(NSString *)title
                message:(NSString *)message
            cancelTitle:(NSString *)cancelTitle
            cancelBlcok:(void (^)(void))cancelBlcok
           comfirmTitle:(NSString *)comfirmTitle
           comfirmBlcok:(void (^)(void))comfirmBlcok
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle && [cancelTitle length] > 0) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancelBlcok ? cancelBlcok() : NULL;
        }];
        [alert addAction:actionCancel];
    }
    
    if (!comfirmTitle || [comfirmTitle length] == 0) {
        comfirmTitle = @"确定";
    }
    UIAlertAction *actionComfirm = [UIAlertAction actionWithTitle:comfirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
        comfirmBlcok ? comfirmBlcok() : NULL;
    }];
    [alert addAction:actionComfirm];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}


@end
