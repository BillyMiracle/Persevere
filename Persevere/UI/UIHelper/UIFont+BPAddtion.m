//
//  UIFont+BPAddtion.m
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import "UIFont+BPAddtion.h"

@implementation UIFont (BPAddtion)

+ (UIFont *)bp_defaultFont {
    return [UIFont systemFontOfSize:16.0];
}
+ (UIFont *)bp_taskDetailTitleFont {
    return [UIFont systemFontOfSize:17.5 weight:UIFontWeightBold];
}
+ (UIFont *)bp_taskDetailInfoFont {
    return [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
}
+ (UIFont *)bp_sectionHeaderTitleFont {
    return [UIFont systemFontOfSize:25.0 weight:UIFontWeightBold];
}
+ (UIFont *)bp_navigationTitleFont {
    return [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
}
+ (UIFont *)bp_timeViewSubTitleFont {
    return [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
}
+ (UIFont *)bp_timeViewDayTextFont {
    return [UIFont fontWithName:@"Futura Medium" size:35.0];
}
+ (UIFont *)bp_progressViewFont {
    return [UIFont fontWithName:@"Futura Medium" size:40.0];
}
+ (UIFont *)bp_progressViewSmallFont {
    return [UIFont fontWithName:@"Futura Medium" size:30.0];
}
+ (UIFont *)bp_taskListFont {
    return [UIFont systemFontOfSize:17.0];
}
@end
