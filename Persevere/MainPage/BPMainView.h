//
//  BPMainPageView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import <UIKit/UIKit.h>
#import "ARUtility.h"

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@protocol BPMainViewDelegate <NSObject>

/// 改变颜色
- (void)changeColor:(NSInteger)colorId;

/// 跳转到taskDisplay
- (void)displayTask:(TaskModel *)task;

/// 跳转到AR
- (void)interactWithARwithType:(BPARType)type;

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
