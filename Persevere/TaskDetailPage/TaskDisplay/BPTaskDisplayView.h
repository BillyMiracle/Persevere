//
//  BPTaskDisplayView.h
//  Persevere
//
//  Created by 张博添 on 2024/2/27.
//

#import "TaskModel.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPTaskDisplayViewDataSource <NSObject>

@property (nonatomic, strong) TaskModel *task;

@end

@interface BPTaskDisplayView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id<BPTaskDisplayViewDataSource> dataSource;
- (TaskModel *)getCurrentTaskInfo;

@end

NS_ASSUME_NONNULL_END
