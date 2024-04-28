//
//  BPCalanderTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/3/10.
//

#import "BPTaskDetailBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@protocol BPCalanderTableViewCellDelegate <NSObject>

/// 日历选中 date
- (void)didSelectDate:(NSDate *)date;

@end

@interface BPCalanderTableViewCell : BPTaskDetailBaseTableViewCell

@property (nonatomic, weak) id<BPCalanderTableViewCellDelegate> delegate;

- (void)bindTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
