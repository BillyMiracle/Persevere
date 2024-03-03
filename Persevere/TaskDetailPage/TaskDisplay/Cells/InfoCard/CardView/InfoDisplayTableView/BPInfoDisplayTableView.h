//
//  BPInfoDisplayTableView.h
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@interface BPInfoDisplayTableView : UITableView

- (void)reloadWithTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
