//
//  BPDateHelper.m
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import "BPDateHelper.h"

static const NSArray *weekDays = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];

@implementation BPDateHelper

+ (NSString *)weekStringFromNumber:(NSInteger)weekDay {
    if (weekDay < 1 || weekDay > weekDays.count) {
        return @"";
    }
    return weekDays[weekDay - 1];
}

+ (NSString *)transformDateToyyyyMMdd:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)transformDateToMMWeekday:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM EEEE"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

@end
