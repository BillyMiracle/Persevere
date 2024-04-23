//
//  BPSelectTaskViewModel.m
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import "BPSelectTaskViewModel.h"
#import "LocalTaskDataManager.h"
#import "DateTools.h"
#import "BPSelectTaskTableViewCell.h"
#import "BPSelectTableViewCellModel.h"

@interface BPSelectTaskViewModel()

/// 全部任务数组
@property (nonatomic, nonnull) NSMutableArray *allTaskArray;
/// 展示任务数组
@property (nonatomic, strong) NSMutableArray *filteredTasks;
/// 已选择数组
@property (nonatomic, strong) NSMutableArray *selectedTasks;
/// 是否选择数组
@property (nonatomic, strong) NSMutableArray *isSelectedArray;

@end

@implementation BPSelectTaskViewModel

/// 加载任务，重新刷新任务数据
- (void)loadTasksFinished:(loadTasksFinishedBlock)finishedBlock {
    [[LocalTaskDataManager sharedInstance] getTasksFinished:^(NSMutableArray * _Nonnull taskArray) {
        [self.allTaskArray removeAllObjects];
        [self.filteredTasks removeAllObjects];
        for (TaskModel *task in taskArray) {
            if (self.type == BPARTypeManually) {
                if (![task.endDate isEarlierThan:[NSDate date]]) {
                    [self.allTaskArray addObject:task];
                    [self.isSelectedArray addObject:@(false)];
                }
            } else if (self.type == BPARTypeAutomatically) {
                if (![task.endDate isEarlierThan:[NSDate date]]
                    && task.imageData != nil) {
                    [self.allTaskArray addObject:task];
                    [self.isSelectedArray addObject:@(false)];
                }
            }
            
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
        self.filteredTasks = self.allTaskArray;
        finishedBlock(YES);
    });
}

// MARK: UITableViewDelegate, UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSNumber *num = [self.isSelectedArray objectAtIndex:indexPath.row];
    TaskModel *task = [self.filteredTasks objectAtIndex:indexPath.row];
    BOOL selected = num.boolValue;
    BPSelectTableViewCellModel *model = [[BPSelectTableViewCellModel alloc] initWithTask:task selected:selected];
    BPSelectTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task" forIndexPath:indexPath];
    [cell bindModel:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredTasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskModel *task = [self.filteredTasks objectAtIndex:indexPath.row];
    NSNumber *num = [self.isSelectedArray objectAtIndex:indexPath.row];
    BOOL selected = !num.boolValue;
    if (selected) {
        [self.selectedTasks addObject:task];
    } else {
        [self.selectedTasks removeObject:task];

    }
    self.isSelectedArray[indexPath.row] = @(selected);
    if ([self.delegate respondsToSelector:@selector(didSelectTaskAtIndexPath:)]) {
        [self.delegate didSelectTaskAtIndexPath:indexPath];
    }
}

// MARK: Getters

- (NSMutableArray *)filteredTasks {
    if (!_filteredTasks) {
        _filteredTasks = [[NSMutableArray alloc] init];
    }
    return _filteredTasks;
}

- (NSMutableArray *)allTaskArray {
    if (!_allTaskArray) {
        _allTaskArray = [[NSMutableArray alloc] init];
    }
    return _allTaskArray;
}

- (NSMutableArray *)selectedTasks {
    if (!_selectedTasks) {
        _selectedTasks = [[NSMutableArray alloc] init];
    }
    return _selectedTasks;
}

- (NSMutableArray *)isSelectedArray {
    if (!_isSelectedArray) {
        _isSelectedArray = [[NSMutableArray alloc] init];
    }
    return _isSelectedArray;
}

- (NSArray *)selectedTasksArray {
    return [self.selectedTasks copy];
}

@end
