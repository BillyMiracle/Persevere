//
//  BPSearchViewModel.h
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TaskModel;

typedef void (^loadTasksFinishedBlock)(BOOL success);

@protocol BPSearchViewModelProtocol <NSObject>

- (void)didSelectTask:(TaskModel *)task;

- (void)setIsDataEmpty:(BOOL)isEmpty;

@end

@interface BPSearchViewModel : NSObject
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<BPSearchViewModelProtocol> delegate;

- (void)loadTasksFinished:(loadTasksFinishedBlock)finishedBlock;

- (void)searchTasksWithText:(NSString *)text finished:(loadTasksFinishedBlock)finishedBlock;

@end

NS_ASSUME_NONNULL_END
