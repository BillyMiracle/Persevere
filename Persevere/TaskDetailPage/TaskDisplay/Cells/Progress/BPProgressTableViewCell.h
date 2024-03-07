//
//  BPProgressTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/3/8.
//

#import "BPTaskDetailBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPProgressTableViewCellModel : NSObject

/// 打卡天数
@property (nonatomic, assign) NSInteger punchedDayCount;
/// 总天数
@property (nonatomic, assign) NSInteger totalDayCount;

- (instancetype)initWithPunchedDayCount:(NSInteger)punchedDayCount totalDayCount:(NSInteger)totalDayCount;

@end

@class TaskModel;

@interface BPProgressTableViewCell : BPTaskDetailBaseTableViewCell

- (void)bindModel:(BPProgressTableViewCellModel *)model;

@end

NS_ASSUME_NONNULL_END
