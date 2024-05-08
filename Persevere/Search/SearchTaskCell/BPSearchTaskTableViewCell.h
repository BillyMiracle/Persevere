//
//  BPSearchTaskTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

@interface BPSearchTaskTableViewCell : UITableViewCell

- (void)bindTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
