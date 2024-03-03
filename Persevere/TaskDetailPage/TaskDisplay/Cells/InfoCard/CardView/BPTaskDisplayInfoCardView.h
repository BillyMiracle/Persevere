//
//  BPTaskDisplayInfoCardView.h
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import <UIKit/UIKit.h>

@class TaskModel;

NS_ASSUME_NONNULL_BEGIN

@interface BPTaskDisplayInfoCardView : UIView

- (void)bindTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
