//
//  BPMainPageTaskTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/19.
//

#import "BPTaskBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@protocol BPMainPageTaskTableViewCellDelegate <NSObject>

- (void)checkTaskAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BPMainPageTaskTableViewCell : BPTaskBaseTableViewCell

@property (nonatomic, strong) id<BPMainPageTaskTableViewCellDelegate> checkDelegate;

- (void)configureWithTask:(TaskModel *)task;
- (void)setIsFinished:(BOOL)isFinished;

@end

NS_ASSUME_NONNULL_END
