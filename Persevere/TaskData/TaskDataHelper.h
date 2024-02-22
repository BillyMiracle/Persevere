//
//  TaskDataHepler.h
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskDataHelper : NSObject

+ (NSArray *)sortTasks:(NSArray *)tasks withSortFactor:(NSString *)factor isAscend:(BOOL)isAscend;

+ (NSArray *)filtrateTasks:(NSArray *)tasks withType:(NSInteger)typeNum;

+ (NSArray *)filtrateTasks:(NSArray *)tasks withString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
