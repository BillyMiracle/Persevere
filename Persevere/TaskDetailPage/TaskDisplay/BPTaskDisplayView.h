//
//  BPTaskDisplayView.h
//  Persevere
//
//  Created by 张博添 on 2024/2/27.
//

#import "TaskModel.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// BPTaskDisplayView展示页数据源
@protocol BPTaskDisplayViewDataSource <NSObject>

@property (nonatomic, strong) TaskModel *task;

@end

@protocol BPTaskDisplayViewDelegate <NSObject>

- (void)currentTaskInteractWithAR;
- (void)deleteCurrentTask;

@end

@interface BPTaskDisplayView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id<BPTaskDisplayViewDataSource> dataSource;
@property (nonatomic, weak) id<BPTaskDisplayViewDelegate> delegate;
- (TaskModel *)getCurrentTaskInfo;

@end

NS_ASSUME_NONNULL_END
