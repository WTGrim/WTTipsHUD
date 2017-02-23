//
//  WTTipsHUD.m
//  WTTipsHUD
//
//  Created by Dwt on 2017/2/17.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import "WTTipsHUD.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDefaultDuration 1.5
#define kTimeout 120

@implementation WTTipsHUD

+ (void)showErrorHUD:(NSString *)message{
    
    [self showErrorHUD:message duration:kDefaultDuration];
}

+ (void)showErrorHUD:(NSString *)message duration:(CGFloat)duration{
    
    TipsHUDView *HUD = [[TipsHUDView alloc]init];
    HUD.HUDType = WTTipsHUDTypeFail;
    [HUD showMessage:message duration:duration];
}

+ (void)showSuccessHUD:(NSString *)message{
    
    [self showSuccessHUD:message duration:kDefaultDuration];
}

+ (void)showSuccessHUD:(NSString *)message duration:(CGFloat)duration{
    
    TipsHUDView *HUD = [[TipsHUDView alloc]init];
    HUD.HUDType = WTTipsHUDTypeSuccess;
    [HUD showMessage:message duration:duration];
}

+ (void)showMessage:(NSString *)message{
    
    [self showMessage:message duration:kDefaultDuration];
}

+ (void)showMessage:(NSString *)message duration:(CGFloat)duration{
    
    TipsHUDView *HUD = [[TipsHUDView alloc]init];
    HUD.HUDType = WTTipsHUDTypeText;
    HUD.backViewCanTouch = NO;
    [HUD showMessage:message duration:duration];
}


+ (void)showLoadingMessage:(NSString *)message{
    
    [self showLoadingMessage:message duration:kDefaultDuration];
}

+ (void)showLoadingMessage:(NSString *)message duration:(CGFloat)duration{
    
    TipsHUDView *HUD = [[TipsHUDView alloc]init];
    HUD.HUDType = WTTipsHUDTypeWait;
    HUD.backViewCanTouch = NO;
    [HUD showMessage:message duration:duration];
}

+ (void)showCircleLoaing{
    
    [self showCircleLoaingMessage:nil];
}

+ (void)showCircleLoaingMessage:(NSString *)message{
    
    TipsHUDView *HUD = [[TipsHUDView alloc]init];
    if (!message || message.length == 0) {
        HUD.HUDType = WTTipsHUDTypeLoadWithOutTitle;
    }else{
        HUD.HUDType = WTTipsHUDTypeLoadWithTitle;
    }
    [HUD showMessage:message duration:kTimeout];
}


+ (void)showMessage:(NSString *)message withCustomView:(UIView *)customView{
    
    TipsHUDView *HUD = [[TipsHUDView alloc]init];
    HUD.HUDType = WTTipsHUDTypeCustomView;
    HUD.priority = PriorityHigh;
    HUD.customView = customView;
    [HUD showMessage:message duration:kTimeout];
}


+ (void)hide{
    
    UIWindow *currentWindow = nil;
    NSEnumerator *enumerator = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    
    for (UIWindow *window in enumerator) {
        if (window.windowLevel == UIWindowLevelNormal) {
            currentWindow = window;
            break;
        }
    }
    
    [currentWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[TipsHUDView class]]) {
            TipsHUDView *HUD = (TipsHUDView *)obj;
            if (HUD.priority != PriorityHigh) {
                [HUD hide];
            }
        }
    }];
}

@end


@interface ActivityView ()

@property(nonatomic, assign)CGFloat radius;
@property(nonatomic, assign)CGFloat lineWidth;
@property(nonatomic, strong)UIImageView *backImageView;
@property(nonatomic, strong)UIImageView *animateImageView;
@property(nonatomic, strong)UIColor *strokeColor;
@property(nonatomic, assign)BOOL animating;
@property(nonatomic, strong)CAShapeLayer *animateLayer;
@end

#define kBackWidth  90.0f
#define kPadding 0.0f
static NSString *const kAppDidBecomActive = @"appDidBecomActive";

@implementation ActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.radius = 24.0f;
        self.lineWidth = 2.0f;
        self.strokeColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - kBackWidth) * 0.5 , (CGRectGetWidth(self.frame) - kBackWidth) * 0.5, kBackWidth, kBackWidth)];
        self.backImageView.image = nil;
        [self addSubview:self.backImageView];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
        self.animateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kPadding, kPadding, kBackWidth - 2*kPadding , kBackWidth - 2*kPadding)];
        [self addSubview:self.animateImageView];
        
        self.animating = NO;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomActive:) name:kAppDidBecomActive object:nil];
    }
    return self;
}

#pragma mark - begin or end
- (void)beginAnimating{
    
    self.animating = YES;
}

- (void)endAnimating{
    
    self.animating = NO;
    [_animateLayer removeFromSuperlayer];
    _animateLayer = nil;
    
}

#pragma mark - setter or getter
- (CAShapeLayer *)animateLayer{
    
    if (!_animateLayer) {
        CGPoint center = CGPointMake(self.radius + self.lineWidth * 0.5 + 5, self.radius + self.lineWidth * 0.5 + 5);
        CGRect rect = CGRectMake(0, 0, center.x * 2, center.y * 2);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:(CGFloat)(M_PI * 3/2) endAngle:(CGFloat)(M_PI/2 + 5 * M_PI) clockwise:YES];
        
        _animateLayer = [CAShapeLayer layer];
        _animateLayer.contentsScale = [UIScreen mainScreen].scale;
        _animateLayer.frame = rect;
        _animateLayer.fillColor = [UIColor clearColor].CGColor;
        _animateLayer.strokeColor = self.strokeColor.CGColor;
        _animateLayer.lineCap = kCALineCapRound;
        _animateLayer.lineJoin = kCALineJoinBevel;
        _animateLayer.lineWidth = self.lineWidth;
        _animateLayer.path = path.CGPath;
        
        
        CALayer *layer = [CALayer layer];
        layer.contents = (__bridge id)[UIImage imageNamed:@"maskImage.png"].CGImage;
        layer.frame = _animateLayer.bounds;
        _animateLayer.mask = layer;
        
        NSTimeInterval duration = 1;
        CAMediaTimingFunction *linear = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnimation.fromValue = (id)0;
        basicAnimation.toValue = @(2 * M_PI);
        basicAnimation.duration = duration;
        basicAnimation.timingFunction = linear;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.repeatCount = INFINITY;
        basicAnimation.fillMode = kCAFillModeForwards;
        basicAnimation.autoreverses = NO;
        [_animateLayer.mask addAnimation:basicAnimation forKey:@"rotate"];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = duration;
        group.repeatCount = INFINITY;
        group.removedOnCompletion = NO;
        group.timingFunction = linear;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        group.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_animateLayer addAnimation:group forKey:@"progress"];
        
    }
    
    return _animateLayer;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.backImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - kBackWidth) * 0.5, (CGRectGetHeight(self.frame) - kBackWidth) * 0.5, kBackWidth, kBackWidth);
}

//从后台进入前台
- (void)appDidBecomActive:(NSNotification *)notif{
    
    NSDictionary *userInfo = notif.userInfo;
    if ([[userInfo objectForKey:@"AppActiveState"] isEqualToString:@"AppDidBecomeActive"]) {
        if (self.animating) {
            [self setAnimating:YES];
        }
    }
}

- (void)setAnimating:(BOOL)animating{
    
    _animating = animating;
    if (animating) {
        CALayer *layer = self.animateLayer;
        [self.backImageView.layer addSublayer:layer];
        layer.position = CGPointMake(CGRectGetWidth(self.backImageView.bounds) * 0.5, CGRectGetHeight(self.backImageView.bounds) * 0.5);
        
    }
    self.hidden = !animating;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kAppDidBecomActive object:nil];
}


@end



@interface TipsHUDView ()

#define kImageViewWidth 40.0

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIView *loadView;
@property(nonatomic, strong)UIView *coverView;
@property(nonatomic, assign)CGFloat duration;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIActivityIndicatorView *indicatorView;
@property(nonatomic, strong)ActivityView *activityView;
@property(nonatomic, strong)NSString *message;

@end
@implementation TipsHUDView

- (instancetype)init{
    
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    self.bounds = CGRectMake(0, 0, kBackWidth + 25, kBackWidth + 25);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    self.priority = PriorityMiddle;
    
    self.loadView = [UIView new];
    [self addSubview:self.loadView];
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
//    CGFloat w = kBackWidth;
//    self.loadView.frame = CGRectMake(0, 0, w, w);
    
    self.titleLabel.frame = CGRectMake(20, 10, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame) - 20);
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.bounds) - kImageViewWidth) * 0.5, 25, kImageViewWidth, kImageViewWidth);
    self.loadView.frame = CGRectMake((CGRectGetWidth(self.frame) - kBackWidth) * 0.5, 0, kBackWidth, kBackWidth);
    
    if (self.HUDType == WTTipsHUDTypeText) {
        
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.frame = CGRectMake(20, 10, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame) - 20);        
        
    }else{
        
        self.titleLabel.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame) - (CGRectGetMaxY(self.imageView.frame) + 15) - 20);
        
    }

}

- (ActivityView *)activityView{
    
    if (!_activityView) {
        _activityView = [[ActivityView alloc]initWithFrame:CGRectMake(0, 0, kBackWidth, kBackWidth)];
        [self.imageView removeFromSuperview];
        self.loadView.hidden = NO;
        
        if (self.HUDType == WTTipsHUDTypeLoadWithTitle) {
            self.titleLabel.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 30, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame) - (CGRectGetMaxY(self.loadView.frame) + 30) - 20);
            self.titleLabel.numberOfLines = 1;
            self.bounds = CGRectMake(0, 0, 115, 125);
        }else if(self.HUDType == WTTipsHUDTypeLoadWithOutTitle){
            self.titleLabel.hidden = YES;
            self.bounds = CGRectMake(0, 0, 90, 90);
        }
        
        [self.loadView addSubview:_activityView];
    }
    return _activityView;
}

- (UIActivityIndicatorView *)indicatorView{
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, kImageViewWidth, kImageViewWidth)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.imageView addSubview:_indicatorView];

    }
    return _indicatorView;
}

#pragma mark - 显示
- (void)showMessage:(NSString *)message duration:(CGFloat)duration{
    
    self.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
    _coverView = [UIView new];
    _message = message;
    UIWindow *currentWindow = nil;
    NSEnumerator *windowsEnumertor = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    
    for (UIWindow *window in windowsEnumertor) {
        if (window.windowLevel == UIWindowLevelNormal) {
            currentWindow = window;
            break;
        }
    }
    
    for (UIView *view in currentWindow.subviews) {
        if ([view isKindOfClass:[self class]]) {
            TipsHUDView *HUD = (TipsHUDView *)view;
            if (self.priority >= HUD.priority) {
                [HUD hide];
            }
        }
    }
    
    _coverView.center = currentWindow.center;
    _coverView.userInteractionEnabled = YES;
    _coverView.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if (!_backViewCanTouch) {
        [currentWindow addSubview:_coverView];
    }
    
    [currentWindow addSubview:self];
    
    self.loadView.hidden = YES;
    self.titleLabel.text = message;
    
    UIFont *font = [UIFont boldSystemFontOfSize:15];;
    self.titleLabel.font = font;
    if (self.HUDType == WTTipsHUDTypeText) {
        
        CGRect imageViewRect = self.imageView.frame;
        imageViewRect.size.height = 0;
        self.imageView.frame = imageViewRect;
        self.imageView.hidden = YES;
        
        CGSize size = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        CGFloat HUDWidth = size.width;
        if (HUDWidth <= ScreenWidth - 100 - kImageViewWidth) {
            
            HUDWidth += 41;
        }else{
            HUDWidth = ScreenWidth - 100;
        }
        
        self.bounds = CGRectMake(0, 0, HUDWidth, [message boundingRectWithSize:CGSizeMake(HUDWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height + 41);
        
    }else if (self.HUDType == WTTipsHUDTypeLoadWithOutTitle){
        
        [self.activityView beginAnimating];
        
    }else if (self.HUDType == WTTipsHUDTypeLoadWithCustomView){
        
        if (self.customView) {
            self.loadView.hidden = NO;
            self.imageView.hidden = YES;
            self.customView.frame = CGRectMake(0, 0, kBackWidth, kBackWidth);
            [self.loadView addSubview:self.customView];
            
            if (message && message.length > 0) {
                CGRect titleRect = self.titleLabel.frame;
                titleRect.origin.y = CGRectGetMaxY(self.imageView.frame) + 30;
                self.titleLabel.frame = titleRect;
                self.titleLabel.numberOfLines = 1;
                self.bounds = CGRectMake(0, 0, 115, 125);
            }else{
                self.titleLabel.hidden = YES;
                self.bounds = CGRectMake(0, 0, kBackWidth, kBackWidth);
            }
        }
        
    }else{
        
        if (self.HUDType == WTTipsHUDTypeSuccess) {
            
            //继续
            self.imageView.image = [UIImage imageNamed:@"success.png"];
        }else if (self.HUDType == WTTipsHUDTypeFail){
            self.imageView.image = [UIImage imageNamed:@"fail.png"];
        }else if (self.HUDType == WTTipsHUDTypeWait){
            self.imageView.image = nil;
            [self.indicatorView startAnimating];
        }else if (self.HUDType == WTTipsHUDTypeLoadWithTitle){
            self.titleLabel.text = message;
            [self.activityView beginAnimating];
        }
        
        CGSize textSize = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        CGFloat HUDWidth = textSize.width;
        
        if (HUDWidth + kImageViewWidth <= 115) {
            HUDWidth = 115;
        }else if (HUDWidth + kImageViewWidth >= ScreenWidth - 100){
            HUDWidth = ScreenWidth - 100;
        }else{
            HUDWidth += 41;
        }
        
        self.bounds = CGRectMake(0, 0, HUDWidth, [message boundingRectWithSize:CGSizeMake(HUDWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height + 101);
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.duration = duration;
    [self hideWithDuration];
}

- (void)hideWithDuration{
    
    if (self.duration == 0) {
        self.duration = kDefaultDuration;
    }
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf hide];
    });
}

#pragma mark - 隐藏
- (void)hide{
    
    if (_indicatorView) {
        [_indicatorView stopAnimating];
    }
    self.hidden = YES;
    _coverView.hidden = YES;
    [_coverView removeFromSuperview];
    [self removeFromSuperview];
}


@end
