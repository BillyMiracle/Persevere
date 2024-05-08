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
#import "NSString+BPAddition.h"

@interface BPSelectTaskViewModel()

/// 全部任务数组
@property (nonatomic, nonnull) NSMutableArray *allTaskArray;
/// 全部数据数组
@property (nonatomic, nonnull) NSMutableArray *allCellModelArray;
/// 展示任务数组
@property (nonatomic, strong) NSMutableArray *filteredCellModelArray;
/// 已选择数组
@property (nonatomic, strong) NSMutableArray *selectedCellModelArray;

@end

@implementation BPSelectTaskViewModel

/// 加载任务，重新刷新任务数据
- (void)loadTasksFinished:(loadTasksFinishedBlock)finishedBlock {
    [[LocalTaskDataManager sharedInstance] getTasksFinished:^(NSMutableArray * _Nonnull taskArray) {
        [self.allTaskArray removeAllObjects];
        [self.filteredCellModelArray removeAllObjects];
        for (TaskModel *task in taskArray) {
            if (self.type == BPARTypeManually) {
                if (![task.endDate isEarlierThan:[NSDate date]]) {
                    [self.allTaskArray addObject:task];
                }
            } else if (self.type == BPARTypeAutomatically) {
                if (![task.endDate isEarlierThan:[NSDate date]]
                    && task.imageData != nil) {
                    [self.allTaskArray addObject:task];
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
        for (int i = 0; i < self.allTaskArray.count; i++) {
            BPSelectTableViewCellModel *model = [[BPSelectTableViewCellModel alloc] initWithTask:self.allTaskArray[i] selected:false];
            [self.allCellModelArray addObject:model];
            [self.filteredCellModelArray addObject:model];
        }
        finishedBlock(YES);
    });
}

- (void)searchTasksWithText:(NSString *)text finished:(loadTasksFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *lower = [NSString changetoLower:text];
        [self.filteredCellModelArray removeAllObjects];
        for (BPSelectTableViewCellModel *model in self.allCellModelArray) {
            NSString *nameInPinyin = [NSString transformToPinyin:model.task.name];
            NSString *memoInPinyin = [NSString transformToPinyin:model.task.memo];
            if ([nameInPinyin containsString:lower] || [memoInPinyin containsString:lower]) {
                [self.filteredCellModelArray addObject:model];
            }
        }
        if (self.filteredCellModelArray.count == 0) {
            [self.filteredCellModelArray addObjectsFromArray:self.allCellModelArray];
        } else {
            for (BPSelectTableViewCellModel *model in self.selectedCellModelArray) {
                if (![self.filteredCellModelArray containsObject:model]) {
                    [self.filteredCellModelArray addObject:model];
                }
            }
        }
        finishedBlock(YES);
    });
}

// MARK: UITableViewDelegate, UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BPSelectTableViewCellModel *model = [self.filteredCellModelArray objectAtIndex:indexPath.row];
    BPSelectTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task" forIndexPath:indexPath];
    [cell bindModel:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredCellModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BPSelectTableViewCellModel *model = [self.filteredCellModelArray objectAtIndex:indexPath.row];
    model.selected = !model.selected;
    if (model.selected) {
        // TODO: 暂时手动添加只允许单选
        if (self.type == BPARTypeManually) {
            [self.selectedCellModelArray removeAllObjects];
        }
        [self.selectedCellModelArray addObject:model];
    } else {
        [self.selectedCellModelArray removeObject:model];
    }
    if ([self.delegate respondsToSelector:@selector(didSelectTaskAtIndexPath:)]) {
        [self.delegate didSelectTaskAtIndexPath:indexPath];
    }
}

// MARK: Getters

- (NSMutableArray *)filteredCellModelArray {
    if (!_filteredCellModelArray) {
        _filteredCellModelArray = [[NSMutableArray alloc] init];
    }
    return _filteredCellModelArray;
}

- (NSMutableArray *)allTaskArray {
    if (!_allTaskArray) {
        _allTaskArray = [[NSMutableArray alloc] init];
    }
    return _allTaskArray;
}

- (NSMutableArray *)selectedCellModelArray {
    if (!_selectedCellModelArray) {
        _selectedCellModelArray = [[NSMutableArray alloc] init];
    }
    return _selectedCellModelArray;
}

- (NSMutableArray *)allCellModelArray {
    if (!_allCellModelArray) {
        _allCellModelArray = [[NSMutableArray alloc] init];
    }
    return _allCellModelArray;
}

- (NSArray *)selectedTasksArray {
    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    for (BPSelectTableViewCellModel *model in self.selectedCellModelArray) {
        [tasks addObject:model.task];
    }
    return [tasks copy];
}

@end
