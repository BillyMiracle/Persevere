//
//  BPTaskDisplayView.h
//  Persevere
//
//  Created by 张博添 on 2024/2/27.
//

#import "TaskModel.h"
#import "BPExtraInfoTableViewCell.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// BPTaskDisplayView展示页数据源
@protocol BPTaskDisplayViewDataSource <NSObject>

@property (nonatomic, strong) TaskModel *task;

typedef void (^UpdateTaskFinishedBlock)(BOOL succeeded);
/// 补打卡
- (void)fixPunchOnDate:(NSDate *)date finished:(UpdateTaskFinishedBlock)finished;
/// 取消打卡
- (void)unpunchOnDate:(NSDate *)date finished:(UpdateTaskFinishedBlock)finished;
/// 跳过打卡
- (void)skipPunchOnDate:(NSDate *)date finished:(UpdateTaskFinishedBlock)finished;
/// 取消跳过打卡
- (void)cancelSkipPunchOnDate:(NSDate *)date finished:(UpdateTaskFinishedBlock)finished;

@end

@protocol BPTaskDisplayViewDelegate <BPExtraInfoTableViewCellDelegate>

- (void)currentTaskInteractWithAR;
- (void)deleteCurrentTask;

@end

@interface BPTaskDisplayView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id<BPTaskDisplayViewDataSource> dataSource;
@property (nonatomic, weak) id<BPTaskDisplayViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
