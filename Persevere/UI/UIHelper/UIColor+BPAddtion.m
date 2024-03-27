//
//  UIColor+BPAddtion.m
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import "UIColor+BPAddtion.h"

@implementation UIColor (BPAddtion)

// #4682C8
+ (UIColor *)bp_defaultThemeColor {
    return [UIColor colorWithRed:70.0/255.0 green:130.0/255.0 blue:200.0/255.0 alpha:1];
}

+ (UIColor *)bp_backgroundThemeColor {
    return [UIColor colorWithWhite:0.95 alpha:1];
}

+ (UIColor *)bp_colorPickerColorWithIndex:(NSInteger)index {
    switch (index) {
        case 1:
            return [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
        case 2:
            return [UIColor colorWithRed:250.0/255.0 green:150.0/255.0 blue:70.0/255.0 alpha:1];
        case 3:
            return [UIColor colorWithRed:240.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0];;
        case 4:
            return [UIColor colorWithRed:90.0/255.0 green:255.0/255.0 blue:90.0/255.0 alpha:1.0];;
        case 5:
            return [UIColor colorWithRed:80.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
        case 6:
            return [UIColor colorWithRed:210.0/255.0 green:140.0/255.0 blue:230.0/255.0 alpha:1.0];;
        case 7:
            return [UIColor colorWithWhite:0.7 alpha:1];
        default:
            break;
    }
    return nil;
}

@end
