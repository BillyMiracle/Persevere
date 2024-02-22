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

@property (nonnull, nonatomic) NSMutableArray *taskArray;

+ (_Nonnull instancetype)shareInstance;

- (void)addTask:(TaskModel *_Nonnull)task finished:(updateTaskFinishedBlock)finishedBlock;
- (void)updateTask:(TaskModel *_Nonnull)task finished:(updateTaskFinishedBlock)finishedBlock;
- (void)deleteTask:(TaskModel *_Nonnull)task finished:(updateTaskFinishedBlock)finishedBlock;

- (void)getTasksFinished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock;
- (void)getTasksOfID:(int)taskId finished:(getTasksucceededBlock)successBlock error:(errorBlock)errorBlock;
- (void)getTasksOfDate:(NSDate *_Nonnull)date finished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock;
- (void)getTasksOfWeekdays:(NSArray *_Nonnull)weekdays finished:(getTaskArraysucceededBlock)successBlock error:(errorBlock)errorBlock;

- (void)punchForTaskWithID:(NSNumber *)taskid onDate:(NSDate *)date finished:(updateTaskFinishedBlock)finishedBlock;
- (void)unpunchForTaskWithID:(NSNumber *)taskid onDate:(NSDate *)date finished:(updateTaskFinishedBlock)finishedBlock;

@end

NS_ASSUME_NONNULL_END
