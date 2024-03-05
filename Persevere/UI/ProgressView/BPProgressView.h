//
//  BPProgressView.h
//  Persevere
//
//  Created by 张博添 on 2024/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPProgressView : UIView

/// 进度条宽度
@property (nonatomic,assign) CGFloat progressLineWidth;
/// 背景线条宽度
@property (nonatomic,assign) CGFloat backgroundLineWidth;
/// 进度百分比
@property (nonatomic,assign) CGFloat percentage;
/// 背景填充颜色
@property (nonatomic,strong) UIColor *backgroundStrokeColor;
/// 进度条填充颜色
@property (nonatomic,strong) UIColor *progressStrokeColor;
/// 距离边框边距偏移量
@property (nonatomic,assign) CGFloat offset;
/// 步长
@property (nonatomic,assign) CGFloat step;
/// 数字字体颜色
@property (nonatomic,strong) UIColor *digitTintColor;

/// 设置进度
/// @param percentage 进度百分比
/// @param animated 是否开启动画
- (void)setProgress:(CGFloat)percentage animated:(BOOL)animated;

/// 设置进度字体
/// @param size 字体大小的具体数字
- (void)setFontWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
