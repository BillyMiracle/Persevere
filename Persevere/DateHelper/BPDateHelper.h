//
//  BPDateHelper.h
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *BPEndlessString = @"到无限期";
static const NSString *BPDateFormat = @"yyyy/MM/dd";

@interface BPDateHelper : NSObject

+ (NSString *)weekStringFromNumber:(NSInteger)weekDay;
+ (NSString *)transformDateToyyyyMMdd:(NSDate *)date;
+ (NSString *)transformDateToMMWeekday:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
