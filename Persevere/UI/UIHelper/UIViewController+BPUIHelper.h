//
//  UIViewController+BPUIHelper.h
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BPUIHelper)

@property (nonatomic, assign, readonly) CGFloat bp_width;
@property (nonatomic, assign, readonly) CGFloat bp_height;

@end

NS_ASSUME_NONNULL_END
