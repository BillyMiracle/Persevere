//
//  BPSearchViewModel.m
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import "BPSearchViewModel.h"
#import "LocalTaskDataManager.h"
#import "NSString+BPAddition.h"
#import "BPSearchTaskTableViewCell.h"

@interface BPSearchViewModel()

/// 全部任务数组
@property (nonatomic, nonnull) NSMutableArray *allTaskArray;
/// 展示任务数组
@property (nonatomic, strong) NSMutableArray *filteredTaskArray;

@end

@implementation BPSearchViewModel

/// 加载任务，重新刷新任务数据
- (void)loadTasksFinished:(loadTasksFinishedBlock)finishedBlock {
    [[LocalTaskDataManager sharedInstance] getTasksFinished:^(NSMutableArray * _Nonnull taskArray) {
        [self.allTaskArray removeAllObjects];
        [self.filteredTaskArray removeAllObjects];
        for (TaskModel *task in taskArray) {
            [self.allTaskArray addObject:task];
        }
        // 筛选
        [self filterTasksFinished:^(BOOL success) {
            finishedBlock(success);
        }];
    } error:^(NSError * _Nonnull error) {
        finishedBlock(false);
    }];
}

/// 筛选任务，无需重新刷新任务数据
- (void)filterTasksFinished:(loadTasksFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < self.allTaskArray.count; i++) {
            TaskModel *task = self.allTaskArray[i];
            [self.filteredTaskArray addObject:task];
        }
        finishedBlock(YES);
    });
}

- (void)searchTasksWithText:(NSString *)text finished:(loadTasksFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!text || [text isEqualToString:@""]) {
            for (int i = 0; i < self.allTaskArray.count; i++) {
                TaskModel *task = self.allTaskArray[i];
                [self.filteredTaskArray addObject:task];
            }
        } else {
            NSString *lower = [NSString changetoLower:text];
            [self.filteredTaskArray removeAllObjects];
            for (TaskModel *task in self.allTaskArray) {
                if (!task.name) {
                    task.name = @"";
                }
                if (!task.memo) {
                    task.memo = @"";
                }
                NSString *nameInPinyin = [NSString transformToPinyin:task.name];
                NSString *memoInPinyin = [NSString transformToPinyin:task.memo];
                if ([nameInPinyin containsString:lower] || [memoInPinyin containsString:lower]) {
                    [self.filteredTaskArray addObject:task];
                }
            }
        }
        if (self.filteredTaskArray.count > 0) {
            finishedBlock(YES);
        } else {
            finishedBlock(NO);
        }
    });
}

// MARK: UITableViewDelegate, UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TaskModel *task = [self.filteredTaskArray objectAtIndex:indexPath.row];
    BPSearchTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task" forIndexPath:indexPath];
    [cell bindTask:task];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredTaskArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectTask:)]) {
        if (indexPath.row < self.filteredTaskArray.count) {
            [self.delegate didSelectTask:self.filteredTaskArray[indexPath.row]];
        }
    }
}

// MARK: Getters

- (NSMutableArray *)allTaskArray {
    if (!_allTaskArray) {
        _allTaskArray = [[NSMutableArray alloc] init];
    }
    return _allTaskArray;
}

- (NSMutableArray *)filteredTaskArray {
    if (!_filteredTaskArray) {
        _filteredTaskArray = [[NSMutableArray alloc] init];
    }
    return _filteredTaskArray;
}

@end
