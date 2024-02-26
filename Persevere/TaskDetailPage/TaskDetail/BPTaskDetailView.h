//
//  BPTaskDetailView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import "TaskModel.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPTaskDetailViewDataSource <NSObject>

@property (nonatomic, strong) TaskModel *task;
/// 是否是添加（YES是添加，NO是修改）
@property (nonatomic, assign) BOOL isAddMode;

@end

@interface BPTaskDetailView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id<BPTaskDetailViewDataSource> dataSource;
- (TaskModel *)getCurrentTaskInfo;

@end

NS_ASSUME_NONNULL_END
