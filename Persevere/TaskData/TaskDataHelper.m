//
//  TaskDataHepler.m
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import "TaskDataHelper.h"

@implementation TaskDataHelper

+ (NSDictionary *)getTaskSortArray {
    return @{
        @"任务名" : @"sortName",
        @"任务开始时间" : @"startDate",
        @"任务结束时间" : @"endDate",
        @"提醒时间" : @"reminderTime.hour|reminderTime.minute",
        @"完成进度" : @"progress"
    };
}

+ (NSArray *)sortTasks:(NSArray *)tasks withSortFactor:(NSString *)factor isAscend:(BOOL)isAscend {
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for (NSString *str in [factor componentsSeparatedByString:@"|"]) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:str ascending:isAscend];
        [sortDescriptors addObject:sortDescriptor];
    }
    return [NSMutableArray arrayWithArray:[tasks sortedArrayUsingDescriptors:sortDescriptors]];
}

+ (NSArray *)filtrateTasks:(NSArray *)tasks withType:(NSInteger)typeNum {
    if (typeNum <= 0 || typeNum > 7) {
        return tasks;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type == %ld", typeNum];
        return [NSMutableArray arrayWithArray:[tasks filteredArrayUsingPredicate:predicate]];
    }
}

+ (NSArray *)filtrateTasks:(NSArray *)tasks withWeekdays:(NSArray *)weekdays {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY SELF.reminderDays in %@", weekdays];
    return [NSMutableArray arrayWithArray:[tasks filteredArrayUsingPredicate:predicate]];
}

+ (NSArray *)filtrateTasks:(NSArray *)tasks withString:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS %@ OR SELF.memo CONTAINS %@", str, str];
    return [NSMutableArray arrayWithArray:[tasks filteredArrayUsingPredicate:predicate]];
}

@end
