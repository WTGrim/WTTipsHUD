//
//  WTTipsHUD.m
//  WTTipsHUD
//
//  Created by Dwt on 2017/2/17.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import "WTTipsHUD.h"

@implementation WTTipsHUD


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
        CGPoint center = CGPointMake(self.radius + self.lineWidth * 0.5 + 5, self.radius + self.lineWidth * 0.5);
        CGRect rect = CGRectMake(0, 0, center.x * 2, center.y * 2);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:(CGFloat)(M_PI * 3/2) endAngle:(CGFloat)(M_PI/2 + 5 * M_PI) clockwise:YES];
        
        _animateLayer = [CAShapeLayer layer];
        _animateLayer.contentsScale = [UIScreen mainScreen].scale;
        _animateLayer.frame = rect;
        _animateLayer.fillColor = [UIColor clearColor].CGColor;
        _animateLayer.strokeColor = self.strokeColor.CGColor;
        _animateLayer.lineCap = kCALineCapRound;
        _animateLayer.lineJoin = kCALineJoinBevel;
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
