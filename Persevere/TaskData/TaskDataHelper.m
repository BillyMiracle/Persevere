//
//  TaskDataHepler.m
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import "TaskDataHelper.h"

@implementation TaskDataHelper

+ (NSArray *)sortTasks:(NSArray *)tasks withSortFactor:(NSString *)factor isAscend:(BOOL)isAscend {
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for(NSString *str in [factor componentsSeparatedByString:@"|"]){
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

+ (NSArray *)filtrateTasks:(NSArray *)tasks withString:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS %@ OR SELF.memo CONTAINS %@", str, str];
    return [NSMutableArray arrayWithArray:[tasks filteredArrayUsingPredicate:predicate]];
}

@end
