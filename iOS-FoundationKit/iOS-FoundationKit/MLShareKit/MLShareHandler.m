//
//  MLShareHandler.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLShareHandler.h"
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <MessageUI/MessageUI.h>

#ifndef dispatch_queue_async_ml
#define dispatch_queue_async_ml(queue, block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
        block();\
    } else {\
        dispatch_async(queue, block);\
    }
#endif

#ifndef dispatch_main_async_ml
#define dispatch_main_async_ml(block) dispatch_queue_async_ml(dispatch_get_main_queue(), block)
#endif

#if TARGET_IPHONE_SIMULATOR
@interface MLShareHandler ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
#else
@interface MLShareHandler ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,WXApiDelegate,WeiboSDKDelegate,QQApiInterfaceDelegate>
#endif
@end

@implementation MLShareHandler

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#if TARGET_IPHONE_SIMULATOR
#else
+ (BOOL)isInstalledApp:(MLShareType)shareType
{
    switch (shareType) {
        case MLShareType_message:
        {
            return [MFMessageComposeViewController canSendText];
        }
            break;
        case MLShareType_Mail:
        case MLShareType_PasteBoard:
            return YES;
            break;
        case MLShareType_Weibo:
        case MLShareType_Weibo_Text:
        {
            return [WeiboSDK isWeiboAppInstalled];
        }
            break;
        case MLShareType_WX_Session:
        case MLShareType_WX_Timeline:
        case MLShareType_WX_Session_Text:
        case MLShareType_WX_Timeline_Text:
        {
            return [WXApi isWXAppInstalled];
        }
            break;
        case MLShareType_QQ_Session:
        case MLShareType_QQ_Session_Text:
        case MLShareType_QQ_Zone:
        {
            return [QQApiInterface isQQInstalled];
        }
            break;
        default:
            return NO;
            break;
    }
}

- (void)shareWithType:(MLShareType)shareType shareObject:(MLShareObject *)obj
{
    switch (shareType) {
        case MLShareType_message:
        {
            [self shareToMessage:obj];
        }
            break;
        case MLShareType_PasteBoard:
        {
            [self copyToPasteboard:obj];
        }
            break;
        case MLShareType_Mail:
        {
            [self shareToMail:obj];
        }
            break;
        case MLShareType_Weibo:
        {
            return;
            
            [self shareToWeibo:obj];
        }
            break;
        case MLShareType_Weibo_Text:
        {
            return;
            
            [self shareToWeibo:obj.title description:obj.message];
        }
            break;
        case MLShareType_QQ_Zone:
        {
            return;
            
            [self shareToQQ:obj qzone:YES];
        }
            break;
        case MLShareType_QQ_Session:
        {
            return;
            
            [self shareToQQ:obj qzone:NO];
        }
            break;
        case MLShareType_QQ_Session_Text:
        {
            return;
            
            [self shareToQQ:obj.title message:obj.message];
        }
            break;
        case MLShareType_WX_Session:
        {
            return;
            
            [self shareToWeChat:obj bText:NO WXScene:WXSceneSession];
        }
            break;
        case MLShareType_WX_Session_Text:
        {
            return;
            
            [self shareToWeChat:obj bText:YES WXScene:WXSceneSession];
        }
            break;
        case MLShareType_WX_Timeline:
        {
            return;
            
            [self shareToWeChat:obj bText:NO WXScene:WXSceneTimeline];
        }
            break;
        case MLShareType_WX_Timeline_Text:
        {
            return;
            
            [self shareToWeChat:obj bText:YES WXScene:WXSceneTimeline];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 微博
- (void)shareToWeibo:(MLShareObject *)obj
{
    if (obj.bigImage) {
        WBMessageObject *message = [WBMessageObject message];
        
        WBImageObject *message1 = [WBImageObject object];
        NSData *imageData = UIImagePNGRepresentation(obj.bigImage);
        message1.imageData = imageData;
        message.imageObject = message1;
        
        dispatch_main_async_ml(^{
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        });
        return;
    }
    
    NSData *imageData = nil;
    if ([obj.imageUrl hasPrefix:@"http://"]|| [obj.imageUrl hasPrefix:@"https://"])
    {
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:obj.imageUrl]];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:obj.imageUrl];
        imageData = UIImagePNGRepresentation(image);
    }
    
    WBMessageObject *message = [WBMessageObject message];
    //链接分享到新浪微博
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [self macAddress]?[self macAddress]:@"identifier";
    webpage.title = obj.title;
    webpage.description = obj.message;
    
    webpage.thumbnailData = imageData;
    webpage.webpageUrl = obj.webUrl;
    message.mediaObject = webpage;
    
    dispatch_main_async_ml(^{
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
    });
    
}

- (void)shareToWeibo:(NSString *)title description:(NSString *)description
{
    WBMessageObject *message = [WBMessageObject message];
    if (title.length > 0)
    {
        message.text = title;
    }
    else if (description.length > 0)
    {
        message.text = description;
    }
    else
    {
        message.text = @" ";
    }
    
    dispatch_main_async_ml(^{
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
    });
}

#pragma mark - QQ
- (void)shareToQQ:(MLShareObject *)obj qzone:(BOOL)qzone;
{
    if (obj.bigImage) {
        NSData *imageData = UIImagePNGRepresentation(obj.bigImage);
        
        if (qzone) {}
        else {
            QQApiImageObject *object = [QQApiImageObject objectWithData:imageData previewImageData:imageData title:@"二维码分享" description:@"二维码分享"];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            dispatch_main_async_ml(^{
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleSendResult:sent];
            });
        }
        return;
    }
    
    QQApiNewsObject *object = nil;
    if ([obj.imageUrl hasPrefix:@"http://"] || [obj.imageUrl hasPrefix:@"https://"])
    {
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:obj.imageUrl]];
        object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:obj.webUrl] title:obj.title description:obj.message previewImageData:imageData];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:obj.imageUrl];
        NSData *imageData = UIImagePNGRepresentation(image);
        object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:obj.webUrl] title:obj.title description:obj.message previewImageData:imageData];
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
    if (qzone)
    {
        dispatch_main_async_ml(^{
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        });
    }
    else
    {
        dispatch_main_async_ml(^{
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        });
    }
}

- (void)shareToQQ:(NSString *)title message:(NSString *)message
{
    SendMessageToQQReq *req = nil;
    QQApiTextObject *txtObj = nil;
    if (title.length > 0)
    {
        txtObj = [QQApiTextObject objectWithText:title];
    }
    else if (message.length > 0)
    {
        txtObj = [QQApiTextObject objectWithText:message];
    }
    else
    {
        txtObj = [QQApiTextObject objectWithText:@" "];
    }
    req = [SendMessageToQQReq reqWithContent:txtObj];
    
    
    dispatch_main_async_ml(^{
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    });
}

#pragma mark - 微信
- (void)shareToWeChat:(MLShareObject *)obj bText:(BOOL)bText WXScene:(enum WXScene)scene;
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.scene = scene;
    
    if (obj.bigImage) {
        NSData *imageData = UIImagePNGRepresentation(obj.bigImage);
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = obj.title;
        message.description = obj.message;
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = imageData;
        message.mediaObject = ext;
        
        req.message = message;
        dispatch_main_async_ml(^{
            [WXApi sendReq:req];
        });
        
        return;
    }
    
    if (bText)
    {
        if (obj.title.length > 0)
        {
            req.text = obj.title;
        }
        else if (obj.message.length > 0)
        {
            req.text = obj.message;
        }
        else
        {
            req.text = @" ";
        }
    }
    else
    {
        UIImage *image = nil;
        if ([obj.imageUrl hasPrefix:@"http://"] || [obj.imageUrl hasPrefix:@"https://"]) {
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:obj.imageUrl]];
            image = [UIImage imageWithData:imageData];
        }
        else{
            image = [UIImage imageNamed:obj.imageUrl];
        }
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = obj.title;
        message.description = obj.message;
        [message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = obj.webUrl;
        message.mediaObject = ext;
        
        req.message = message;
    }
    req.bText = bText;
    
    dispatch_main_async_ml(^{
        [WXApi sendReq:req];
    });
}

#pragma mark - 邮件分享
- (void)shareToMail:(MLShareObject *)obj
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        MLShareResult *result = [[MLShareResult alloc]init];
        result.resultType = MLShareResult_Fail;
        result.message = @"当前系统版本不支持应用内发送邮件功能";
        [self shareCallback:result];
        return;
    }
    if (![mailClass canSendMail]) {
        MLShareResult *result = [[MLShareResult alloc]init];
        result.resultType = MLShareResult_Fail;
        result.message = @"没有设置邮件账户";
        [self shareCallback:result];
        return;
    }
    [self displayMailPicker:obj];
}

//调出邮件发送窗口
- (void)displayMailPicker:(MLShareObject *)shareContent
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    [mailPicker setSubject:shareContent.title];
    NSString *url = [NSString stringWithFormat:@"<string>%@</string><br/><a>%@</a>",shareContent.message,shareContent.webUrl];
    [mailPicker setMessageBody:url isHTML:YES];
    
    [[self currentViewController] presentViewController:mailPicker animated:YES completion:^{
        
    }];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    MLShareResult *mResult = [[MLShareResult alloc]init];
    
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            mResult.resultType = MLShareResult_Cancel;
            mResult.message = @"取消编辑邮件";
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            mResult.resultType = MLShareResult_Success;
            mResult.message = @"成功保存邮件";
            break;
        case MFMailComposeResultSent: // 用户点击发送
            mResult.resultType = MLShareResult_Success;
            mResult.message = @"成功添加到邮件发送队列";
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            mResult.resultType = MLShareResult_Fail;
            mResult.message = @"保存或者发送邮件失败";
            break;
        default:
            mResult.resultType = MLShareResult_Fail;
            mResult.message = @"发送邮件失败";
            break;
    }
    [self shareCallback:mResult];
    // 关闭邮件发送视图
    [[self currentViewController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 复制到剪切板
- (void)copyToPasteboard:(MLShareObject *)obj
{
    NSMutableString *message = [NSMutableString stringWithFormat:@"%@\n%@\n%@",obj.title,obj.message,obj.webUrl];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message;
    
    MLShareResult *result = [[MLShareResult alloc]init];
    result.resultType = MLShareResult_Success;
    result.message = @"复制成功";
    [self shareCallback:result];
}

#pragma mark - 短信
- (void)shareToMessage:(MLShareObject *)obj
{
    if ([MFMessageComposeViewController canSendText])
    {
        //必须在创建ViewController之前设置BarTintColor
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.messageComposeDelegate = self;
        controller.subject = obj.title;
        controller.body = obj.message;
        controller.recipients = obj.recipients;
        
    }else {
        NSLog(@"该设备无法发送短信");
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            MLShareResult *result = [[MLShareResult alloc]init];
            result.resultType = MLShareResult_Cancel;
            result.message = @"取消发送短信";
            [self shareCallback:result];
        }
            break;
        case MessageComposeResultSent:
        {
            MLShareResult *result = [[MLShareResult alloc]init];
            result.resultType = MLShareResult_Cancel;
            result.message = @"短信发送成功";
            [self shareCallback:result];
        }
            break;
        case MessageComposeResultFailed:
        {
            MLShareResult *result = [[MLShareResult alloc]init];
            result.resultType = MLShareResult_Cancel;
            result.message = @"短信发送失败";
            [self shareCallback:result];
        }
            break;
        default:
            break;
    }
    if (controller.presentingViewController) {
        [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"App未注册" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"发送参数错误" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"未安装QQ" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"缺少参数或者参数不正确" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"发送失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"当前QQ版本太低，请更新QQ" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        default:
        {
        }
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

- (NSString *) localMAC{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)macAddress
{
    NSString *key = @"macAddress_id";
    NSString *macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (macAddress.length == 0)
    {
        macAddress = [self localMAC];
        if (macAddress.length>0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:macAddress forKey:key];
        }
    }
    
    return macAddress;
}

#pragma mark - delegate 微信和QQ
- (void)onReq:(QQBaseReq *)req
{}

- (void)isOnlineResponse:(NSDictionary *)response
{}

- (void)onResp:(id)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        BaseResp *response = (BaseResp *)resp;
        MLShareResult *result = [[MLShareResult alloc]init];
        if (response.errCode == WXSuccess)
        {
            result.resultType = MLShareResult_Success;
            result.message = @"分享成功";
        }
        else
        {
            if (response.errCode == WXErrCodeUserCancel)
            {
                result.resultType = MLShareResult_Cancel;
                result.message = @"用户取消分享";
            }
            else
            {
                result.resultType = MLShareResult_Fail;
                result.message = response.errStr;
            }
        }
        [self shareCallback:result];
    }
    if ([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        QQBaseResp *response = (QQBaseResp *)resp;
        if (response.type == ESENDMESSAGETOQQRESPTYPE)
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            MLShareResult *result = [[MLShareResult alloc]init];
            if ([sendResp.result integerValue] == 0)
            {
                result.resultType = MLShareResult_Success;
                result.message = @"分享成功";
            }
            else
            {
                result.resultType = MLShareResult_Fail;
                result.message = response.errorDescription;
            }
            [self shareCallback:result];
        }
    }
}
#pragma mark - delegate 微博
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        MLShareResult *result = [[MLShareResult alloc]init];
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            result.resultType = MLShareResult_Success;
            result.message = @"分享成功";
        }
        else
        {
            if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel)
            {
                result.resultType = MLShareResult_Cancel;
                result.message = @"用户取消分享";
            }
            else
            {
                result.resultType = MLShareResult_Fail;
                result.message = @"分享失败";
            }
        }
        [self shareCallback:result];
    }
}

- (void)shareCallback:(MLShareResult *)obj
{
    if (_shareDelegate && [_shareDelegate respondsToSelector:@selector(shareResultCallback:)]) {
        [_shareDelegate shareResultCallback:obj];
    }
}

#endif

@end
