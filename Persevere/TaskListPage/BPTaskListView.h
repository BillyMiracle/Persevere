//
//  BPTaskListPageView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@protocol BPTaskListViewDelegate <NSObject>

/// 跳转到搜索页
- (void)pushToSearchPage;
/// 跳转到taskDisplay
- (void)displayTask:(TaskModel *)task;

@end

@interface BPTaskListView : UIView

@property (nonatomic, weak) id<BPTaskListViewDelegate> delegate;
/// 刷新数据
- (void)refreshAndLoadTasksWithDate:(NSDate *)date;
/// 导航栏标题点击
- (void)navigationTitleViewTapped;

@end

NS_ASSUME_NONNULL_END
