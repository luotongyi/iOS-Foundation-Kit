//
//  MLTabBar.m
//  BasicFramework
//
//  Created by luoty on 2019/5/20.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLTabBar.h"

#define ML_TAB_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width

@interface MLTabBar ()

@property (nonatomic, strong)   UIButton *specialBtn;

@property (nonatomic, strong) NSArray<NSString *>      *titleArray;

@property (nonatomic, strong) NSArray<NSString *>      *imageArray;

@property (nonatomic, strong) NSArray<NSString *>      *selectedImageArray;

@end

@implementation MLTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedIndex = 0;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndex = 0;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

+ (instancetype)tabBarWithFrame:(CGRect)frame
                         titles:(NSArray<NSString *> *)titles
                         images:(NSArray<NSString *> *)images
                 selectedImages:(NSArray<NSString *> *)selectedImages{
    MLTabBar *tabBar = [[MLTabBar alloc]initWithFrame:frame];
    tabBar.titleArray = titles;
    tabBar.imageArray = images;
    tabBar.selectedImageArray = selectedImages;
    [tabBar realodTabBar];
    return tabBar;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

- (void)realodTabBar{
    CGFloat itemX = 0;
    NSInteger itemCount = self.titleArray.count;
    CGFloat itemWidth = ML_TAB_SCREEN_WIDTH / itemCount;
    
    for (int i = 0; i < itemCount; i++) {
        MLTabBarItem *item = [[MLTabBarItem alloc] initWithFrame:CGRectMake(itemX, 0, itemWidth, 49)];
        item.title = self.titleArray[i];
        item.image = [UIImage imageNamed:self.imageArray[i]];
        item.selectedImage = [UIImage imageNamed:self.selectedImageArray[i]];
        item.tag = i;
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        [self.itemArray addObject:item];
        
        itemX = itemWidth * (i+1);
    }
}

- (void)itemAction:(MLTabBarItem *)item{
    self.selectedIndex = item.tag;
    if (_mlTabBarDelegate && [_mlTabBarDelegate respondsToSelector:@selector(selectedMLTabBarIndex:)]) {
        [_mlTabBarDelegate selectedMLTabBarIndex:item.tag];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MLTabBarItem *item = (MLTabBarItem *)obj;
        if (idx == selectedIndex) {
            item.itemSelected = YES;
        }else {
            item.itemSelected = NO;
        }
    }];
}
/*
#pragma -mark 重写hitTest方法,去监听发布按钮的点击,目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
     * 这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
     * self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
     * 在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在突出的那个按钮身上
     * 是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.hidden) {
        return [super hitTest:point withEvent:event];
    }
    else{
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.specialBtn];
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.specialBtn pointInside:newP withEvent:event]) {
            return self.specialBtn;
        }
        else{
            //如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
}

- (UIButton *)specialBtn{
    if (_specialBtn) {
        _specialBtn = [[UIButton alloc] init];
    }
    return _specialBtn;
}
*/

#pragma -mark private
- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

- (NSArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSArray array];
    }
    return _selectedImageArray;
}

@end


@interface MLTabBarItem ()

@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UILabel     *badgeLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MLTabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"";
        self.badge = @"";
        self.itemSelected = NO;
        
        [self setupUI];
    }
    return self;
}
//height：49
- (void)setupUI{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.badgeLabel];
    
    CGFloat imageHeight = 25;
    CGFloat boundWidth = self.bounds.size.width;
    
    self.imageView.frame = CGRectMake((boundWidth-imageHeight)/2, 5, imageHeight, imageHeight);
    
    self.titleLabel.frame = CGRectMake(0, imageHeight+5, boundWidth, 15);
    
    self.badgeLabel.center = CGPointMake((CGRectGetMaxX(self.imageView.frame) - 5), (self.imageView.bounds.origin.y) + 5);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.badgeLabel sizeToFit];
    //为了左右两边切圆角留间距
    CGSize size = [@"#" sizeWithAttributes:@{NSFontAttributeName: self.badgeLabel.font}];
    float width = self.badgeLabel.bounds.size.width + size.width ;
    float height = self.badgeLabel.bounds.size.height ;
    if (width < height) {
        width = height;
    }
    self.badgeLabel.layer.cornerRadius = height / 2;
    self.badgeLabel.clipsToBounds = YES;
    CGRect frame = self.badgeLabel.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.badgeLabel.frame = frame;
}

/** 动画 */
- (void)animationWithSelectedImg {
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.15;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.8];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [self.imageView.layer addAnimation:pulse forKey:nil];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}

- (void)setBadge:(NSString *)badge{
    _badge = badge;
    if (_badge && ![_badge isEqualToString:@""]) {
        _badgeLabel.hidden = NO;
    }else{
        _badgeLabel.hidden = YES;
    }
    _badgeLabel.text = _badge;
}

- (void)setImage:(UIImage *)image{
    _image = image;
}

- (void)setSelectedImage:(UIImage *)selectedImage{
    _selectedImage = selectedImage;
}

- (void)setColor:(UIColor *)color{
    _color = color;
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
}

- (void)setBadgeColor:(UIColor *)badgeColor{
    _badgeColor = badgeColor;
    _badgeLabel.textColor = _badgeColor;
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor{
    _badgeBackgroundColor = badgeBackgroundColor;
    _badgeLabel.backgroundColor = _badgeBackgroundColor;
}

- (void)setItemSelected:(BOOL)itemSelected{
    _itemSelected = itemSelected;
    self.selected = _itemSelected;
    if (_itemSelected) {
        _titleLabel.textColor = _selectedColor?_selectedColor:UIColor.blueColor;
        _imageView.image = _selectedImage;
        [self animationWithSelectedImg];
    }
    else{
        _titleLabel.textColor = _color?_color:UIColor.lightGrayColor;
        _imageView.image = _image;
    }
}

#pragma -mark private
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = UIColor.lightGrayColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.hidden = YES;
        _badgeLabel.textColor = UIColor.whiteColor;
        _badgeLabel.backgroundColor = UIColor.redColor;
    }
    return _badgeLabel;
}

@end
