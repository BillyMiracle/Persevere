//
//  BPCalanderTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/3/10.
//

#import "BPTaskDetailBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@interface BPCalanderTableViewCell : BPTaskDetailBaseTableViewCell

- (void)bindTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
