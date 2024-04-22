//
//  BPSelectTaskViewController.h
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import <UIKit/UIKit.h>
#import "ARUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPSelectTaskViewController : UIViewController

// 根据类型初始化
- (instancetype)initWithType:(BPARType)type;

@end

NS_ASSUME_NONNULL_END
