//
//  WTTipsHUD.h
//  WTTipsHUD
//
//  Created by Dwt on 2017/2/17.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTTipsHUD : NSObject

+ (void)showErrorHUD:(NSString *)message;
+ (void)showErrorHUD:(NSString *)message duration:(CGFloat)duration;

+ (void)showSuccessHUD:(NSString *)message;
+ (void)showSuccessHUD:(NSString *)message duration:(CGFloat)duration;

//纯文本提示
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(CGFloat)duration;

//菊花
+ (void)showLoadingMessage:(NSString *)message;
+ (void)showLoadingMessage:(NSString *)message duration:(CGFloat)duration;

//圆环
+ (void)showCircleLoaing;
+ (void)showCircleLoaingMessage:(NSString *)message;

//自定义
+ (void)showMessage:(NSString *)message withCustomView:(UIView *)customView;
+ (void)hide;

@end

//------------------------------------------
@interface ActivityView : UIView

- (void)beginAnimating;
- (void)endAnimating;

@end



//------------------------------------------
@interface TipsHUDView : UIView

//样式
typedef enum : NSUInteger {
    WTTipsHUDTypeSuccess,
    WTTipsHUDTypeFail,
    WTTipsHUDTypeWait,
    WTTipsHUDTypeText,
    WTTipsHUDTypeCustomView,
    WTTipsHUDTypeLoadWithOutTitle,
    WTTipsHUDTypeLoadWithTitle,
    WTTipsHUDTypeLoadWithCustomView
}  WTTipsHUDType;
//优先级
typedef enum : NSUInteger {
    PriorityHigh = 1000,
    PriorityMiddle = 750,
    PriorityLow = 500
} WTTipsHUDPPriority;

@property(nonatomic, strong)UIView *customView;
@property(nonatomic, assign)BOOL backViewCanTouch;
@property(nonatomic, assign)WTTipsHUDType HUDType;
@property(nonatomic, assign)WTTipsHUDPPriority priority;

- (void)showMessage:(NSString *)message duration:(CGFloat)duration;
- (void)hide;

@end
