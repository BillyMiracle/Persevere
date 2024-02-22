//
//  UIColor+BPAddtion.h
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (BPAddtion)

+ (UIColor *)bp_defaultThemeColor;
+ (UIColor *)bp_backgroundThemeColor;

+ (UIColor *)bp_colorPickerColorWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
