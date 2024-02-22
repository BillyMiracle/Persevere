//
//  BPUIHelper.h
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import <UIKit/UIKit.h>
#import "UIView+BPUIHelper.h"
#import "UIViewController+BPUIHelper.h"
#import "UIDevice+BPAddition.h"
#import "UIColor+BPAddtion.h"
#import "UIFont+BPAddtion.h"
#import "NSString+BPAddition.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPUIHelper : NSObject

+ (CGFloat)mainScreenHeight;
+ (CGFloat)mainScreenWidth;

@end

NS_ASSUME_NONNULL_END
