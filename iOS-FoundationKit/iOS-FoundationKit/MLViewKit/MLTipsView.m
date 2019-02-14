//
//  MLTipsView.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLTipsView.h"

#define ML_SCREEN_WIDTH               CGRectGetWidth([[UIScreen mainScreen] bounds])
#define ML_SCREEN_HEIGHT              CGRectGetHeight([[UIScreen mainScreen] bounds])

#define ml_OffsetX    15       //!< 文字距离背景图片left，right距离
#define ml_OffsetY    15       //!< 文字具体背景图片bottom，top距离

@interface MLTipsView()
{
    UILabel         *_tipsLabel;        //!< 提示文字
    UIImageView     *_bgImageview;      //!< 背景图片
}
@end

@implementation MLTipsView

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_SCREEN_HEIGHT);
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_SCREEN_HEIGHT);
    }
    return self;
}

#pragma mark - Public Method
//显示弱提示文字，默认显示2s
- (void)showTips:(NSString *)tips
{
    [self showTips:tips hideDelay:2.f];
}

- (CGSize)ml_sizeWithFont:(UIFont *)font forWith:(CGFloat)width text:(NSString *)tips
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [tips boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

- (void)showTips:(NSString *)tips hideDelay:(NSTimeInterval)delay
{
    CGSize maxSize=CGSizeMake(ML_SCREEN_WIDTH-100, MAXFLOAT);
    //    CGSize strSize = MULTILINE_TEXTSIZE(tips, [UIFont systemFontOfSize:15.f], maxSize, LINE_BREAK_WORD_WRAP);
    CGSize strSize = [self ml_sizeWithFont:[UIFont systemFontOfSize:15.0] forWith:maxSize.width text:tips];
    //84
    if (_bgImageview == nil) {
        _bgImageview=[[UIImageView alloc] init];
    }
    CGFloat width = strSize.width+ml_OffsetX*2;
    CGFloat height = strSize.height+ml_OffsetY*2;
    _bgImageview.frame = CGRectMake((ML_SCREEN_WIDTH-width)/2, (ML_SCREEN_HEIGHT-height)/2+65, width, height);
    _bgImageview.backgroundColor = [self colorWithHexString:@"000000"];
    
    [self addSubview:_bgImageview];
    
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
    }
    _tipsLabel.text = tips;
    _tipsLabel.textColor = [UIColor whiteColor];
    _tipsLabel.backgroundColor = [UIColor clearColor];
    _tipsLabel.font = [UIFont systemFontOfSize:14.f];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.backgroundColor = [UIColor clearColor];
    
    if (_bgImage)
    {
        _bgImageview.backgroundColor = [UIColor clearColor];
        _bgImageview.image = _bgImage;
    }
    else
    {
        _bgImageview.layer.cornerRadius = 3;
        _bgImageview.layer.masksToBounds = YES;
    }
    
    _tipsLabel.frame = CGRectMake(ml_OffsetX, ml_OffsetY, strSize.width, strSize.height);
    [_bgImageview addSubview:_tipsLabel];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundColor = [UIColor clearColor];
    [window addSubview:self];
    
    
    [self performSelector:@selector(hideTips) withObject:self afterDelay:delay];
    
}

- (UIColor *)colorWithHexString:(NSString *)color
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0];
}

- (void)hideTips
{
    [self removeFromSuperview];
}

@end
