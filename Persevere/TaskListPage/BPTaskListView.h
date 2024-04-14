//
//  BPTaskListPageView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPTaskListViewDelegate <NSObject>

- (void)pushToSearchPage;

@end

@interface BPTaskListView : UIView

@property (nonatomic, weak) id<BPTaskListViewDelegate> delegate;
/// 刷新数据
- (void)refreshAndLoadTasksWithDate:(NSDate *)date;
/// 导航栏标题点击
- (void)navigationTitleViewTapped;

@end

NS_ASSUME_NONNULL_END
