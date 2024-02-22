//
//  TaskModel.h
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : JSONModel

@property (nonatomic) NSInteger taskId;
/// 任务名
@property (nonatomic, nonnull) NSString *name;
/// 提醒的日子（星期 x）
@property (nonatomic, nonnull) NSArray *reminderDays;
/// 开始日期
@property (nonatomic, nonnull) NSDate *startDate;
/// 结束日期
@property (nonatomic, nullable) NSDate *endDate;
/// 跳转 app 的 scheme
//@property (nonatomic, nullable) NSDictionary *appScheme;
/// 提醒时间
@property (nonatomic, nullable) NSDate *reminderTime;
/// 打卡日期数组
@property (nonatomic, nullable) NSArray *punchDateArray;
/// 图片
@property (nonatomic, nullable) NSData *imageData;
/// 链接
@property (nonatomic, nullable) NSString *link;
/// 备注
@property (nonatomic, nullable) NSString *memo;
/// 类别
@property (nonatomic) NSInteger type;
/// 打卡备注数组
@property (nonatomic, nullable) NSArray *punchMemoArray;
/// 跳过打卡日期数组
@property (nonatomic, nullable) NSArray *punchSkipArray;
/// 任务完成率
@property (nonatomic) float progress;
/// 排序的任务名
@property (nonatomic, nonnull) NSString *sortName;

/// 有没有更多信息
- (BOOL)hasMoreInfo;
/// 在某个date上有没有打过卡
- (BOOL)hasPunchedOnDate:(NSDate *_Nonnull)date;
/// 总天数
@property (nonatomic) NSUInteger totalDays;
/// 打卡天数
@property (nonatomic) NSUInteger punchDays;

@end

NS_ASSUME_NONNULL_END
