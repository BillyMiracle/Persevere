//
//  BPNavigationTitleView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPNavigationTitleViewDelegate <NSObject>

- (void)navigationTitleViewTapped;

@end

@interface BPNavigationTitleView : UIView

@property (weak, nonatomic, nullable) id<BPNavigationTitleViewDelegate> navigationTitleDelegate;

/// 初始化
/// @param title  标题
/// @param color  颜色
/// @param shouldShowType 是否展示类别
- (_Nonnull instancetype)initWithTitle:(NSString *_Nonnull)title andColor:(UIColor *_Nullable)color andShouldShowType:(BOOL)shouldShowType;

/// 改变颜色
- (void)changeColor:(UIColor *_Nullable)thisColor;

@end

NS_ASSUME_NONNULL_END
