//
//  BPMainPageView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPMainViewDelegate <NSObject>

/// 改变颜色
- (void)changeColor:(NSInteger)colorId;

@end

@interface BPMainView : UIView

/// 向controller传输数据代理
@property (nonatomic, weak) id<BPMainViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *parentViewController;

/// 刷新数据与选中日期
- (void)refreshAndLoadTasksWithDate:(NSDate *)date;
/// 导航栏标题点击
- (void)navigationTitleViewTapped;

@end

NS_ASSUME_NONNULL_END
