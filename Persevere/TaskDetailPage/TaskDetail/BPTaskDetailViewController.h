//
//  BPTaskDetailViewController.h
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@interface BPTaskDetailViewController : UIViewController

- (instancetype)initWithTask:(TaskModel *_Nullable)task;

@end

NS_ASSUME_NONNULL_END
