//
//  BPTaskListPageTaskTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/4/10.
//

#import "BPTaskBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@interface BPTaskListPageTaskTableViewCell : BPTaskBaseTableViewCell

- (void)bindTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
