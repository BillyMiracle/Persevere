//
//  UIView+BPUIHelper.h
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BPUIHelper)

@property (nonatomic, assign) CGFloat bp_width;
@property (nonatomic, assign) CGFloat bp_height;

@property (nonatomic, assign) CGFloat bp_top;
@property (nonatomic, assign) CGFloat bp_bottom;

@property (nonatomic, assign) CGFloat bp_left;
@property (nonatomic, assign) CGFloat bp_right;

@end

NS_ASSUME_NONNULL_END
