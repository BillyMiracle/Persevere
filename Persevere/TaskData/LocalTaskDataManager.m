//
//  LocalTaskDataManager.m
//  Persevere
//
//  Created by 张博添 on 2023/11/15.
//

#import "LocalTaskDataManager.h"
#import "DataBaseManager.h"
#import "DateTools.h"
#import "BPDateHelper.h"

typedef void (^loadTasksFinished)(void);

@interface LocalTaskDataManager()

@property (nonnull, nonatomic) NSMutableArray *taskArray;

@end

@implementation LocalTaskDataManager

static LocalTaskDataManager* _instance = nil;

+ (instancetype)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:NULL];
            if (_instance) {
                _instance.taskArray = [NSMutableArray array];
            }
        });
    }
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [LocalTaskDataManager sharedInstance];
}

- (instancetype)init {
    return [LocalTaskDataManager sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [LocalTaskDataManager sharedInstance] ;
}

// MARK: 添加
- (void)addTask:(TaskModel *)task finished:(nonnull updateTaskFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *err = nil;
        NSArray *daysArr = task.reminderDays;
        NSString *daysJsonStr = nil;
        if ([daysArr count] > 0 || daysArr != NULL) {
            NSData *daysJsonData = [NSJSONSerialization dataWithJSONObject:daysArr options:NSJSONWritingPrettyPrinted error:&err];
            daysJsonStr = [[NSString alloc] initWithData:daysJsonData encoding:NSUTF8StringEncoding];
        }
        NSArray *punchArr = task.punchDateArray;
        NSString *punchJsonStr = nil;
        if ([punchArr count] > 0 || punchArr != NULL) {
            NSData *punchJsonData = [NSJSONSerialization dataWithJSONObject:punchArr options:NSJSONWritingPrettyPrinted error:&err];
            punchJsonStr = [[NSString alloc] initWithData:punchJsonData encoding:NSUTF8StringEncoding];
        }
        NSArray *punchMemoArr = task.punchMemoArray;
        NSString *punchMemoJsonStr = nil;
        if ([punchMemoArr count] > 0 || punchMemoArr != NULL) {
            NSData *punchJsonData = [NSJSONSerialization dataWithJSONObject:punchMemoArr options:NSJSONWritingPrettyPrinted error:&err];
            punchMemoJsonStr = [[NSString alloc] initWithData:punchJsonData encoding:NSUTF8StringEncoding];
        }
        NSArray *punchSkipArr = task.punchSkipArray;
        NSString *punchSkipJsonStr = nil;
        if ([punchSkipArr count] > 0 || punchSkipArr != NULL) {
            NSData *punchJsonData = [NSJSONSerialization dataWithJSONObject:punchSkipArr options:NSJSONWritingPrettyPrinted error:&err];
            punchSkipJsonStr = [[NSString alloc] initWithData:punchJsonData encoding:NSUTF8StringEncoding];
        }
        [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL succeeded = [db executeUpdate:
                @"INSERT INTO task_table (name, reminderDays, addDate, reminderTime, punchDateArr, image, link, endDate, memo, type, punchMemoArr, punchSkipArr) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
                task.name,
                daysJsonStr,
                task.startDate,
                task.reminderTime,
                punchJsonStr,
                task.imageData,
                task.link,
                task.endDate,
                task.memo,
                @(task.type),
                punchMemoJsonStr,
                punchSkipJsonStr
            ];
            NSLog(@"%@", succeeded ? @"添加成功" : @"添加失败");
            finishedBlock(succeeded);
        }];
    });
}

// MARK: 删除
- (void)deleteTask:(TaskModel *)task finished:(updateTaskFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL result = [db executeUpdate:@"delete from task_table where id = ?;", @(task.taskId)];
            finishedBlock(result);
        }];
    });
}

// MARK: 获取
- (void)loadAllTasksFinished:(loadTasksFinished)finishedBlock {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        [self.taskArray removeAllObjects];
        FMResultSet *resultSet = [db executeQuery:@"select * from task_table;"];
        while ([resultSet next]) {
            TaskModel *task = [[TaskModel alloc] init];
            task.taskId = [resultSet intForColumn:@"id"];
            task.name = [resultSet stringForColumn:@"name"];
            
            NSString *daysJsonStr = [resultSet stringForColumn:@"reminderDays"];
            if (daysJsonStr != nil) {
                NSData *daysData = [daysJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *daysArr = [NSJSONSerialization JSONObjectWithData:daysData options:NSJSONReadingAllowFragments error:nil];
                task.reminderDays = daysArr;
            }
            
            NSString *punchJsonStr = [resultSet stringForColumn:@"punchDateArr"];
            if (punchJsonStr != nil) {
                NSData *punchData = [punchJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *punchArr = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                task.punchDateArray = punchArr;
            }
            
            NSString *punchMemoJsonStr = [resultSet stringForColumn:@"punchMemoArr"];
            if (punchMemoJsonStr != nil) {
                NSData *punchData = [punchMemoJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *punchArr = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                task.punchMemoArray = punchArr;
            }
            
            NSString *punchSkipJsonStr = [resultSet stringForColumn:@"punchSkipArr"];
            if (punchSkipJsonStr != nil) {
                NSData *punchData = [punchSkipJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *punchArr = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                task.punchSkipArray = punchArr;
            }
            
            task.startDate = [resultSet dateForColumn:@"addDate"];
            task.reminderTime = [resultSet dateForColumn:@"reminderTime"];
            task.imageData = [resultSet dataForColumn:@"image"];
            task.link = [resultSet stringForColumn:@"link"];
            task.endDate = [resultSet dateForColumn:@"endDate"];
            task.memo = [resultSet stringForColumn:@"memo"];
            task.type = [resultSet intForColumn:@"type"];
            
            [self.taskArray addObject:task];
        }
        finishedBlock();
    }];
}

- (void)getTasksFinished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadAllTasksFinished:^{
            successBlock(self.taskArray);
        }];
    });
}

- (void)getTasksOfID:(int)taskId finished:(getTasksucceededBlock)successBlock error:(errorBlock)errorBlock {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        [self.taskArray removeAllObjects];
        FMResultSet *resultSet = [db executeQuery:@"select * from task_table where id = ?;", @(taskId)];
        TaskModel *task;
        while ([resultSet next]) {
            task = [[TaskModel alloc] init];
            task.taskId = [resultSet intForColumn:@"id"];
            task.name = [resultSet stringForColumn:@"name"];
            
            NSString *daysJsonStr = [resultSet stringForColumn:@"reminderDays"];
            if (daysJsonStr != nil) {
                NSData *daysData = [daysJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *daysArr = [NSJSONSerialization JSONObjectWithData:daysData options:NSJSONReadingAllowFragments error:nil];
                task.reminderDays = daysArr;
            }
            
            NSString *punchJsonStr = [resultSet stringForColumn:@"punchDateArr"];
            if (punchJsonStr != nil) {
                NSData *punchData = [punchJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *punchArr = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                task.punchDateArray = punchArr;
            }
            
            NSString *punchMemoJsonStr = [resultSet stringForColumn:@"punchMemoArr"];
            if (punchMemoJsonStr != nil) {
                NSData *punchData = [punchMemoJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *punchArr = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                task.punchMemoArray = punchArr;
            }
            
            NSString *punchSkipJsonStr = [resultSet stringForColumn:@"punchSkipArr"];
            if (punchSkipJsonStr != nil) {
                NSData *punchData = [punchSkipJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *punchArr = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                task.punchSkipArray = punchArr;
            }
            
            task.startDate = [resultSet dateForColumn:@"addDate"];
            task.reminderTime = [resultSet dateForColumn:@"reminderTime"];
            task.imageData = [resultSet dataForColumn:@"image"];
            task.link = [resultSet stringForColumn:@"link"];
            task.endDate = [resultSet dateForColumn:@"endDate"];
            task.memo = [resultSet stringForColumn:@"memo"];
            task.type = [resultSet intForColumn:@"type"];
        }
        if (task != nil) {
            successBlock(task);
        } else {
            errorBlock([[NSError alloc] initWithDomain:@"Query Task Error" code:-1 userInfo:@{@"description" : @"查询指定id任务失败"}]);
        }
    }];
}

- (void)getTasksOfDate:(NSDate *)date finished:(getTaskArraysucceededBlock)successBlock error:( errorBlock)errorBlock {
    [self getTasksFinished:^(NSMutableArray * _Nonnull taskArray) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (TaskModel *task in taskArray) {
            if ([task.reminderDays containsObject:[NSNumber numberWithInt:BPConvertToMondayBasedWeekday(date.weekday)]] &&
                [task.startDate isEarlierThanOrEqualTo:date] &&
                (task.endDate == NULL ? TRUE : [task.endDate isLaterThanOrEqualTo:date])) {
                [result addObject:task];
            }
        }
        successBlock(result);
    } error:^(NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

// MARK: 打卡
- (void)punchForTaskWithID:(NSNumber *)taskid onDate:(NSDate *)date finished:(nonnull updateTaskFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
            FMResultSet *resultSet = [db executeQuery:@"select * from task_table where id = ?;", taskid];
            BOOL succeeded = NO;
            while ([resultSet next]) {
            
                //如果跳过的数组有，那就移除
                NSString *skipJsonStr = [resultSet stringForColumn:@"punchSkipArr"];
                if (skipJsonStr != NULL) {
                    NSData *punchData = [skipJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *skipArray = [NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil];
                    NSMutableArray *tempSkipArr = [NSMutableArray arrayWithArray:skipArray];
                
                    if (tempSkipArr != NULL || tempSkipArr.count > 0) {
                
                        if ([tempSkipArr containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
                            [tempSkipArr removeObject:[BPDateHelper transformDateToyyyyMMdd:date]];
                        }
                    
                        if ([tempSkipArr count] > 0 || tempSkipArr != NULL) {
                            NSData *punchSkipJsonData = [NSJSONSerialization dataWithJSONObject:tempSkipArr options:NSJSONWritingPrettyPrinted error:nil];
                            skipJsonStr = [[NSString alloc] initWithData:punchSkipJsonData encoding:NSUTF8StringEncoding];
                        } else {
                            skipJsonStr = nil;
                        }
                    }
                }
            
                NSString *punchJsonStr = [resultSet stringForColumn:@"punchDateArr"];
                if (punchJsonStr != NULL) {
                    NSData *punchData = [punchJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableArray *punchArray = [[NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
                
                    if ([punchArray count] <= 0) {
                        punchArray = [[NSMutableArray alloc] init];
                    }
                
                    if (![punchArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
                        [punchArray addObject:[BPDateHelper transformDateToyyyyMMdd:date]];
                    }
                
                    NSError *err = nil;
                    NSString *punchJsonStr;
                    if ([punchArray count] > 0 || punchArray != NULL) {
                        NSData *punchJsonData = [NSJSONSerialization dataWithJSONObject:punchArray options:NSJSONWritingPrettyPrinted error:&err];
                        punchJsonStr = [[NSString alloc] initWithData:punchJsonData encoding:NSUTF8StringEncoding];
                    } else {
                        punchJsonStr = nil;
                    }
                
                    NSLog(@"punch %@", taskid);
                
                    succeeded = [db executeUpdate:@"update task_table set punchDateArr = ?, punchSkipArr = ? where id = ?;", punchJsonStr, skipJsonStr, taskid];
                }
            }
            finishedBlock(succeeded);
        }];
    });
}

// MARK: 取消打卡
- (void)unpunchForTaskWithID:(NSNumber *)taskid onDate:(NSDate *)date finished:(nonnull updateTaskFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
            FMResultSet *resultSet = [db executeQuery:@"select * from task_table where id = ?;", taskid];
            BOOL succeeded = NO;
            while ([resultSet next]) {
                NSString *punchJsonStr = [resultSet stringForColumn:@"punchDateArr"];
                if(punchJsonStr != NULL){
                    NSData *punchData = [punchJsonStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableArray *punchArray = [[NSJSONSerialization JSONObjectWithData:punchData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
                
                    if ([punchArray count] <= 0) {
                        punchArray = [[NSMutableArray alloc] init];
                    }
                
                    if ([punchArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
                        [punchArray removeObject:[BPDateHelper transformDateToyyyyMMdd:date]];
                    }
                
                    NSError *err = nil;
                    NSString *punchJsonStr;
                    if ([punchArray count] > 0 || punchArray != NULL) {
                        NSData *punchJsonData = [NSJSONSerialization dataWithJSONObject:punchArray options:NSJSONWritingPrettyPrinted error:&err];
                        punchJsonStr = [[NSString alloc] initWithData:punchJsonData encoding:NSUTF8StringEncoding];
                    } else {
                        punchJsonStr = nil;
                    }
                
                    succeeded =  [db executeUpdate:@"update task_table set punchDateArr = ? where id = ?;", punchJsonStr, taskid];
                }
            }
            finishedBlock(succeeded);
        }];
    });
}

// MARK: 数据计算
- (NSInteger)totalDayCountOfTask:(TaskModel *)task {
    NSDate *date = task.startDate;
    NSArray *weekDays = task.reminderDays;
    NSInteger count = 0;
    NSDate *realEndDate = (task.endDate == NULL ? [NSDate date] : ([task.endDate isLaterThan:[NSDate date]] ? [NSDate date] : task.endDate));
    // 计算一共多少天
    while ([[BPDateHelper transformDateToyyyyMMdd:date] intValue] <
           [[BPDateHelper transformDateToyyyyMMdd:[realEndDate dateByAddingDays:1]]  intValue]) {
        if ([weekDays containsObject:@(date.weekday)]){
            count++;
        }
        date = [date dateByAddingDays:1];
    }
    return count;
}

- (NSInteger)didPunchDayNumberOfTask:(TaskModel *)task {
    NSInteger count = 0;
    for (NSString *str in task.punchDateArray) {
        if (str.intValue >= [[BPDateHelper transformDateToyyyyMMdd:task.startDate] intValue] &&
            (task.endDate == NULL ? YES : str.intValue <= [[BPDateHelper transformDateToyyyyMMdd:task.endDate] intValue])) {
            count++;
        }
    }
    return count;
}

- (NSInteger)skipPunchDayCountOfTask:(TaskModel *)task {
    NSInteger count = 0;
    for (NSString *str in task.punchSkipArray) {
        if (str.intValue >= [[BPDateHelper transformDateToyyyyMMdd:task.startDate] intValue] &&
            (task.endDate == NULL ? YES : str.intValue <= [[BPDateHelper transformDateToyyyyMMdd:task.endDate] intValue])) {
            count++;
        }
    }
    return count;
}

@end
