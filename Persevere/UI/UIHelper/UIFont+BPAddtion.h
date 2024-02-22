//
//  UIFont+BPAddtion.h
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (BPAddtion)

+ (UIFont *)bp_defaultFont;
+ (UIFont *)bp_taskDetailTitleFont;
+ (UIFont *)bp_taskDetailInfoFont;
+ (UIFont *)bp_sectionHeaderTitleFont;
+ (UIFont *)bp_navigationTitleFont;

+ (UIFont *)bp_timeViewSubTitleFont;
+ (UIFont *)bp_timeViewDayTextFont;
+ (UIFont *)bp_progressViewFont;

+ (UIFont *)bp_taskListFont;

@end

NS_ASSUME_NONNULL_END
