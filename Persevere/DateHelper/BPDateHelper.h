//
//  BPDateHelper.h
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define BPConvertToMondayBasedWeekday(sundayBasedWeekday) ((sundayBasedWeekday + 5) % 7 + 1)

static const NSString *BPEndlessString = @"到无限期";
static const NSString *BPDateFormat = @"yyyy/MM/dd";
static const NSString *BPTimeFormat = @"HH:mm";

@interface BPDateHelper : NSObject

+ (NSString *)weekStringFromNumber:(NSInteger)weekDay;
+ (NSString *)transformDateToyyyyMMdd:(NSDate *)date;
+ (NSString *)transformDateToMMWeekday:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
