//
//  WTTipsHUD.h
//  WTTipsHUD
//
//  Created by Dwt on 2017/2/17.
//  Copyright © 2017年 Dwt. All rights reserved.
//




#import <UIKit/UIKit.h>


@interface WTTipsHUD : NSObject



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
