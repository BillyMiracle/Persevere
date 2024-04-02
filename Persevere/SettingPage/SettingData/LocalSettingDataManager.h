//
//  LocalSettingDataManager.h
//  Persevere
//
//  Created by 张博添 on 2024/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 大字号
static NSString * const BPLocalSettingBigFont = @"BigFontOn";
/// 动画效果
static NSString * const BPLocalSettingAnimation = @"AnimationOn";
/// 角标显示未完成数
static NSString * const BPLocalSettingShowUndoneCount = @"ShowUndoneCountOn";
/// 自动刷新今日日期
static NSString * const BPLocalSettingAutoRefreshTodayDate = @"AutoRefreshTodayDateOn";

typedef void (^getSettingSucceededBlock)(BOOL isOn);
typedef void (^updateSettingFinishedBlock)(BOOL succeeded);

@interface LocalSettingDataManager : NSObject

/// 获取Manager单例对象
+ (_Nonnull instancetype)sharedInstance;

/// 获取指定名的设置项
- (void)getSettingFromName:(NSString *)name succeeded:(getSettingSucceededBlock)successBlock;

/// 更新指定名的设置项
- (void)updateSettingFromName:(NSString *)name status:(BOOL)status succeeded:(updateSettingFinishedBlock)successBlock;

/// 获取颜色备注数组
- (void)getColorDescriptions;

@end

NS_ASSUME_NONNULL_END
