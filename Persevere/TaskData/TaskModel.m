//
//  TaskModel.m
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import "TaskModel.h"
#import "LocalTaskDataManager.h"
#import "BPDateHelper.h"

@implementation TaskModel

- (float)progress {
    float totaldays = (float)[self totalDays];
    float progress = (float)[self punchDays] / totaldays;
    return totaldays == 0.0 ? 0.0 : progress;
}

- (NSUInteger)totalDays {
    return [[LocalTaskDataManager shareInstance] totalDayCountOfTask:self] - [[LocalTaskDataManager shareInstance] skipPunchDayCountOfTask:self];
}

- (NSUInteger)punchDays {
    return [[LocalTaskDataManager shareInstance] didPunchDayNumberOfTask:self];
}

- (NSString *)sortName {
    return [self.name stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
}

- (BOOL)hasMoreInfo {
    return self.imageData != NULL || (self.memo != NULL && ![self.memo isEqualToString:@""])
    || (self.link != NULL && ![self.link isEqualToString:@""]);
}

- (BOOL)hasPunchedOnDate:(NSDate *)date {
    return [self.punchDateArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]];
}


@end
