//
//  LocalTaskDataManager.h
//  Persevere
//
//  Created by 张博添 on 2023/11/15.
//

#import <Foundation/Foundation.h>

#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalTaskDataManager : NSObject

typedef void (^updateTaskFinishedBlock)(BOOL succeeded);
typedef void (^getTasksucceededBlock)(TaskModel *task);
typedef void (^getTaskArraysucceededBlock)(NSMutableArray *taskArray);

typedef void (^errorBlock)(NSError * _Nonnull error);

/// 获取Manager单例对象
+ (_Nonnull instancetype)shareInstance;

/// 添加task
- (void)addTask:(TaskModel *_Nonnull)task finished:(updateTaskFinishedBlock)finishedBlock;
/// 更新task
- (void)updateTask:(TaskModel *_Nonnull)task finished:(updateTaskFinishedBlock)finishedBlock;
/// 删除task
- (void)deleteTask:(TaskModel *_Nonnull)task finished:(updateTaskFinishedBlock)finishedBlock;

/// 获取全部任务
- (void)getTasksFinished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock;
- (void)getTasksOfID:(int)taskId finished:(getTasksucceededBlock)successBlock error:(errorBlock)errorBlock;
- (void)getTasksOfDate:(NSDate *_Nonnull)date finished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock;
- (void)getTasksOfWeekdays:(NSArray *_Nonnull)weekdays finished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock;

- (void)punchForTaskWithID:(NSNumber *)taskid onDate:(NSDate *)date finished:(updateTaskFinishedBlock)finishedBlock;
- (void)unpunchForTaskWithID:(NSNumber *)taskid onDate:(NSDate *)date finished:(updateTaskFinishedBlock)finishedBlock;

/// 一共需要打卡的天数（截至当天）
- (NSInteger)totalDayCountOfTask:(TaskModel *)task;
/// 已经打卡的天数
- (NSInteger)didPunchDayNumberOfTask:(TaskModel *)task;
/// 跳过打卡的天数
- (NSInteger)skipPunchDayCountOfTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
