//
//  MLNavBar.m
//  BasicFramework
//
//  Created by luoty on 2019/5/23.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLNavBar.h"

@interface MLNavBar ()

@property (nonatomic, strong)   UIView *navLine;

@property (nonatomic, strong)   UIImageView *navBgImageView;

@property (nonatomic, strong)   UILabel *navTitleLb;

@property (nonatomic, strong)   UIView *bgView;

@end

@implementation MLNavBar

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_NAVBAR_HEIGHT);
        
        [self reloadNavBar];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        
        self.frame = CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_NAVBAR_HEIGHT);
        [self reloadNavBar];
    }
    return self;
}

- (void)reloadNavBar{
    self.baseViewY = ML_NAVBAR_HEIGHT;
    
    [self addSubview:self.bgView];
    [self addSubview:self.navBgImageView];
    [self addSubview:self.navTitleLb];
    [self addSubview:self.navLine];
}

#pragma -mark setters/getters
#pragma -mark 主体部分
- (void)setNavBarHidden:(BOOL)navBarHidden{
    _navBarHidden = navBarHidden;
    self.hidden = _navBarHidden;
    if (_navBarHidden) {
        self.baseViewY = ML_STATUS_HEIGHT;
    }else{
        self.baseViewY = ML_NAVBAR_HEIGHT;
    }
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor{
    _navBackgroundColor = navBackgroundColor;
    self.bgView.backgroundColor = _navBackgroundColor;
}

- (void)setNavBackgroundImage:(UIImage *)navBackgroundImage{
    _navBackgroundImage = navBackgroundImage;
    _navBgImageView.image = _navBackgroundImage;
}

- (void)setNavAlpha:(CGFloat)navAlpha{
    _navAlpha = navAlpha;
    self.bgView.alpha =_navAlpha;
}

- (void)setNavLineHidden:(BOOL)navLineHidden{
    _navLineHidden = navLineHidden;
    _navLine.hidden = _navLineHidden;
}

#pragma -mark 标题部分
- (void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    _navTitleLb.text = _navTitle;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor{
    _navTitleColor = navTitleColor;
    _navTitleLb.textColor = _navTitleColor;
}

- (void)setNavTitleFont:(UIFont *)navTitleFont{
    _navTitleFont = navTitleFont;
    _navTitleLb.font = _navTitleFont;
}

#pragma -mark 左右按钮部分
- (void)addLeftItems:(NSArray<MLNavBarItem *> *)items{
    CGFloat x = ML_ITEM_MARGIN;
    for (MLNavBarItem *item in items) {
        item.frame = CGRectMake(x, ML_STATUS_HEIGHT, ML_ITEM_WIDTH, 44);
        [self addSubview:item];
        x = x + ML_ITEM_WIDTH + 5;
    }
}

- (void)addRightItems:(NSArray<MLNavBarItem *> *)items{
    CGFloat x = ML_SCREEN_WIDTH - ML_ITEM_MARGIN - ML_ITEM_WIDTH;
    for (MLNavBarItem *item in items) {
        item.frame = CGRectMake(x, ML_STATUS_HEIGHT, ML_ITEM_WIDTH, 44);
        [self addSubview:item];
        x = x - 5 - ML_ITEM_WIDTH;
    }
}

#pragma -mark private
- (UIImageView *)navBgImageView{
    if (!_navBgImageView) {
        _navBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_NAVBAR_HEIGHT)];
        [self addSubview:_navBgImageView];
    }
    return _navBgImageView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_NAVBAR_HEIGHT)];
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)navTitleLb{
    if (!_navTitleLb) {
        CGFloat labelWidth = ML_SCREEN_WIDTH -  ML_ITEM_WIDTH*4 - ML_ITEM_MARGIN*5;
        _navTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ML_STATUS_HEIGHT, labelWidth, ML_NAVBAR_HEIGHT)];
        _navTitleLb.center = CGPointMake(self.center.x, 22+ML_STATUS_HEIGHT);
        _navTitleLb.textAlignment = NSTextAlignmentCenter;
        _navTitleLb.font = [UIFont systemFontOfSize:17];
        _navTitleLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_navTitleLb];
    }
    return _navTitleLb;
}

- (UIView *)navLine{
    if (!_navLine) {
        _navLine = [[UIView alloc] initWithFrame:CGRectMake(0, ML_NAVBAR_HEIGHT-0.5, ML_SCREEN_WIDTH, 0.5f)];
        _navLine.backgroundColor = [self colorWithHexString:@"#CCCCCC" alpha:1];
        [self addSubview:_navLine];
    }
    return _navLine;
}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
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
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end


@implementation MLNavBarItem

- (void)setItemTitle:(NSString *)itemTitle{
    _itemTitle = itemTitle;
    [self setTitle:_itemTitle forState:UIControlStateNormal];
}

- (void)setItemImage:(UIImage *)itemImage{
    _itemImage = itemImage;
    [self setImage:_itemImage forState:UIControlStateNormal];
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor{
    _itemTitleColor = itemTitleColor;
    [self setTitleColor:_itemTitleColor forState:UIControlStateNormal];
}

- (void)setItemHandler:(void (^)(void))itemHandler{
    _itemHandler = itemHandler;
    [self addTarget:self action:@selector(itemHandelCallback) forControlEvents:UIControlEventTouchUpInside];
}

- (void)itemHandelCallback{
    if (_itemHandler) {
        _itemHandler();
    }
}

@end
