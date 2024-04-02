//
//  DataBaseManager.m
//  Persevere
//
//  Created by 张博添 on 2023/11/15.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

static DataBaseManager* _instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [DataBaseManager sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self establishDataBaseInQueue];
    }
    return self;
}

- (void)closeDataBase {
    NSLog(@"database close");
    [self.databaseQueue close];
    self.databaseQueue = NULL;
}

- (void)establishDataBaseInQueue {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db tableExists:@"task_table"]) {
            BOOL result = [db executeUpdate: @"CREATE TABLE IF NOT EXISTS task_table (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, reminderDays text, addDate date NOT NULL, reminderTime date, punchDateArr text, image blob, link text, endDate date, memo text, type integer, punchMemoArr text, punchSkipArr text)"];
            if (result) {
                NSLog(@"创建表成功");
            }
        } else {
            NSLog(@"表已存在");
        }
        if (![db tableExists:@"setting_table"]) {
            BOOL result = [db executeUpdate: @"CREATE TABLE IF NOT EXISTS setting_table (id integer PRIMARY KEY AUTOINCREMENT, setting_type text NOT NULL, setting_status integer)"];
            if (result) {
                NSLog(@"创建表成功");
            }
        } else {
            NSLog(@"表已存在");
//            BOOL result = [db executeUpdate:@"DROP TABLE IF EXISTS setting_table"];
//            if (result) {
//                NSLog(@"删除 setting_table 成功");
//            } else {
//                NSLog(@"删除 setting_table 失败");
//            }
        }
        if (![db tableExists:@"setting_color_table"]) {
            BOOL result = [db executeUpdate: @"CREATE TABLE IF NOT EXISTS setting_color_table (id integer PRIMARY KEY AUTOINCREMENT, color_type_id integer, color_content text)"];
            if (result) {
                NSLog(@"创建表成功");
            }
        } else {
            NSLog(@"表已存在");
//            BOOL result = [db executeUpdate:@"DROP TABLE IF EXISTS setting_color_table"];
//            if (result) {
//                NSLog(@"删除 setting_color_table 成功");
//            } else {
//                NSLog(@"删除 setting_color_table 失败");
//            }
        }
    }];
}

- (FMDatabaseQueue *)databaseQueue {
    if (!_databaseQueue) {
        _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:self.databasePath];
    }
    return _databaseQueue;
}

- (NSString *)databasePath {
    if (!_databasePath) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _databasePath = [documentsPath stringByAppendingPathComponent:@"task.db"];
    }
    return _databasePath;
}

@end
