//
//  UIDevice+BPAddition.h
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (BPAddition)

/// 顶部安全区高度
+ (CGFloat)bp_safeDistanceTop;

/// 底部安全区高度
+ (CGFloat)bp_safeDistanceBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)bp_statusBarHeight;

/// 导航栏高度
+ (CGFloat)bp_navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)bp_navigationFullHeight;

/// 底部导航栏高度
+ (CGFloat)bp_tabBarHeight;

/// 底部导航栏高度（包括安全区）
+ (CGFloat)bp_tabBarFullHeight;

@end

NS_ASSUME_NONNULL_END
