//
//  LocalSettingDataManager.m
//  Persevere
//
//  Created by 张博添 on 2024/3/31.
//

#import "LocalSettingDataManager.h"
#import "DataBaseManager.h"

typedef void (^getDataUptodateFinishedBlock)(BOOL succeeded);

@interface LocalSettingDataManager()

/// 是否是从表中读取的数据，表示所有数据就绪
@property (nonatomic, assign) BOOL isSettingsUptodate;

@property (nonatomic, assign) BOOL isBigFontOn;
@property (nonatomic, assign) BOOL isAnimationOn;
@property (nonatomic, assign) BOOL isShowUndoneCountOn;
@property (nonatomic, assign) BOOL isAutoRefreshTodayDateOn;


@end

@implementation LocalSettingDataManager

static LocalSettingDataManager* _instance = nil;

+ (instancetype)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:NULL];
        });
    }
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [LocalSettingDataManager sharedInstance];
}

- (instancetype)init {
    return [LocalSettingDataManager sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [LocalSettingDataManager sharedInstance] ;
}

- (void)setDataUptodateIfNeededFinished:(getDataUptodateFinishedBlock)finished {
    if (!self.isSettingsUptodate) {
        // 需要处理的名称数组
        NSArray *settingNames = @[BPLocalSettingBigFont,
                                  BPLocalSettingAnimation,
                                  BPLocalSettingShowUndoneCount,
                                  BPLocalSettingAutoRefreshTodayDate];
        
        dispatch_group_t group = dispatch_group_create();
        for (int i = 0; i < settingNames.count; i++) {
            NSString *settingName = settingNames[i];
            dispatch_group_enter(group);
            [self getSettingUptodateWithName:settingName finished:^(BOOL updated) {
                // 处理完成后的操作
                dispatch_group_leave(group);
            }];
        }

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            // 所有任务完成后执行的操作
            NSLog(@"All tasks completed.");
            self.isSettingsUptodate = YES;
            finished(YES);
        });
    } else {
        finished(YES);
    }
}

// 更新设置项的状态
- (void)getSettingUptodateWithName:(NSString *)name finished:(getDataUptodateFinishedBlock)finished {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM setting_table WHERE setting_type = ?", name];
        // 如果结果集中不存在匹配行，则插入一行数据
        BOOL updateTodate = NO;
        if (![resultSet next]) {
            // 原先 table 里没有这个设置
            if (![db executeUpdate:@"INSERT INTO setting_table (setting_type, setting_status) VALUES (?, ?)", name, @0]) {
                NSLog(@"DEBUG: Could not insert row.");
            } else {
                updateTodate = YES;
                NSLog(@"DEBUG: Insert row %@", name);
            }
            [self updateSettingNamed:name to:NO];
        } else {
            // table 里有这个设置
            BOOL status = [resultSet boolForColumn:@"setting_status"];
            NSLog(@"DEBUG: Has row %@ %d", name, status);
            [self updateSettingNamed:name to:status];
            updateTodate = YES;
        }
        finished(updateTodate);
    }];
}

- (void)updateSettingNamed:(NSString *)name to:(BOOL)status {
    // 设置属性
    if ([name isEqualToString:BPLocalSettingBigFont]) {
        self.isBigFontOn = status;
    } else if ([name isEqualToString:BPLocalSettingAnimation]) {
        self.isAnimationOn = status;
    } else if ([name isEqualToString:BPLocalSettingShowUndoneCount]) {
        self.isShowUndoneCountOn = status;
    } else if ([name isEqualToString:BPLocalSettingAutoRefreshTodayDate]) {
        self.isAutoRefreshTodayDateOn = status;
    }
}

- (BOOL)getSettingNamed:(NSString *)name {
    // 查找属性
    if ([name isEqualToString:BPLocalSettingBigFont]) {
        return self.isBigFontOn;
    } else if ([name isEqualToString:BPLocalSettingAnimation]) {
        return self.isAnimationOn;
    } else if ([name isEqualToString:BPLocalSettingShowUndoneCount]) {
        return self.isShowUndoneCountOn;
    } else if ([name isEqualToString:BPLocalSettingAutoRefreshTodayDate]) {
        return self.isAutoRefreshTodayDateOn;
    }
    return NO;
}

// MARK: public

- (void)getSettingFromName:(NSString *)name succeeded:(getSettingSucceededBlock)successBlock {
    __weak typeof(self) weakSelf = self;
    [self setDataUptodateIfNeededFinished:^(BOOL succeeded) {
        __weak typeof(weakSelf) self = weakSelf;
        if (succeeded) {
            BOOL isOn = [self getSettingNamed:name];
            successBlock(isOn);
        } else {
            successBlock(NO);
        }
    }];
}

- (void)updateSettingFromName:(NSString *)name status:(BOOL)status succeeded:(updateSettingFinishedBlock)finishedBlock {
    __weak typeof(self) weakSelf = self;
    [self setDataUptodateIfNeededFinished:^(BOOL succeeded) {
        __strong typeof(weakSelf) self = weakSelf;
        if (succeeded) {
            [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
                if ([db executeUpdate:@"UPDATE setting_table SET setting_status = ? WHERE setting_type = ?", @(status), name]) {
                    [self updateSettingNamed:name to:status];
                    finishedBlock(YES);
                } else {
                    finishedBlock(NO);
                }
            }];
        } else {
            finishedBlock(NO);
        }
    }];
}

- (void)getColorDescriptions {
    
}


@end
