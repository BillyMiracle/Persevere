//
//  LocalUserDataManager.m
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "LocalUserDataManager.h"
#import "DataBaseManager.h"
#import "UserModel.h"

@implementation LocalUserDataManager

static LocalUserDataManager* _instance = nil;

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
    return [LocalUserDataManager sharedInstance];
}

- (instancetype)init {
    return [LocalUserDataManager sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [LocalUserDataManager sharedInstance] ;
}

- (void)checkIsPhoneRegistered:(NSString *)phoneNumber finished:(IsRegisteredBlock)finished; {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *query = @"SELECT COUNT(*) FROM user_table WHERE phone_number = ?";
        FMResultSet *resultSet = [db executeQuery:query, phoneNumber];
        BOOL isRegistered = NO;
        if ([resultSet next]) {
            // 如果count(*)大于0，则表示电话号码已注册
            int count = [resultSet intForColumnIndex:0];
            isRegistered = count > 0;
        }
        finished(YES, isRegistered);
    }];
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password finished:(LoginBlock)finished {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *query = @"SELECT u.id, u.phone_number, u.password, i.nick_name, i.head_image, i.token, i.head_image_path FROM user_table u LEFT JOIN user_info_table i ON u.id = i.user_id WHERE u.phone_number = ?";
        FMResultSet *resultSet = [db executeQuery:query, phoneNumber];
        if ([resultSet next]) {
            UserModel *user = [[UserModel alloc] init];
            user.userID = [resultSet stringForColumn:@"id"];
            user.phoneNumber = [resultSet stringForColumn:@"phone_number"];
            user.passWord = [resultSet stringForColumn:@"password"];
            user.nickName = [resultSet stringForColumn:@"nick_name"];
            user.imageData = [resultSet dataForColumn:@"head_image"];
            user.loginStatus = [resultSet intForColumn:@"login_status"];
            user.token = [resultSet stringForColumn:@"token"];
            user.headImagePath = [resultSet stringForColumn:@"head_image_path"];
            if ([user.passWord isEqualToString:password]) {
                BOOL updateCurrentUserScuuess = [db executeUpdate:@"INSERT INTO current_user_table (phone_number, nick_name, password, head_image, user_id, head_image_path, login_status, token, id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", user.phoneNumber, user.nickName, user.passWord, user.imageData, user.userID, user.headImagePath, @(user.loginStatus), user.token, @(1)];
                if (updateCurrentUserScuuess) {
                    NSLog(@"用户信息保存成功");
                    self.currentUser = user;
                } else {
                    NSLog(@"用户信息保存失败");
                }
                finished(YES, YES);
            } else {
                finished(YES, NO);
            }
        } else {
            finished(NO, NO);
        }
    }];
}

- (void)registerWithUserModel:(UserModel *)user finished:(UserDataProcessFinishedBlock)finished {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:@"INSERT INTO user_table (phone_number, password) VALUES (?, ?)", user.phoneNumber, user.passWord];
        if (success) {
            NSInteger lastInsertedRowID = [db lastInsertRowId];
            NSLog(@"新用户的user_id是：%ld", lastInsertedRowID);
            BOOL newUserInfoSuccess = [db executeUpdate:@"INSERT INTO user_info_table (user_id, nick_name, head_image, head_image_path) VALUES (?, ?, ?, ?)", @(lastInsertedRowID), user.nickName, user.imageData, user.headImagePath];
            if (newUserInfoSuccess) {
                NSLog(@"新建用户信息成功");
                user.loginStatus = 1;
//                user.token = nil;
                BOOL updateCurrentUserScuuess = [db executeUpdate:@"INSERT INTO current_user_table (phone_number, nick_name, password, head_image, user_id, head_image_path, login_status, token, id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", user.phoneNumber, user.nickName, user.passWord, user.imageData, @(lastInsertedRowID), user.headImagePath, @(user.loginStatus), user.token, @(1)];
                if (updateCurrentUserScuuess) {
                    NSLog(@"用户信息保存成功");
                    self.currentUser = user;
                    finished(YES);
                } else {
                    NSLog(@"用户信息保存失败");
                    finished(NO);
                }
            } else {
                NSLog(@"新建用户信息失败");
                finished(NO);
            }
        } else {
            NSLog(@"插入用户信息到user_table失败");
            finished(NO);
        }
    }];
}

- (void)fetchCurrentUserFinished:(UserDataFetchFinishedBlock)finished {
    [[[DataBaseManager sharedInstance] databaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *query = @"select * from current_user_table where id = 1";
        FMResultSet *resultSet = [db executeQuery:query];
        if ([resultSet next]) {
            UserModel *user = [[UserModel alloc] init];
            user.userID = [resultSet stringForColumn:@"id"];
            user.phoneNumber = [resultSet stringForColumn:@"phone_number"];
            user.passWord = [resultSet stringForColumn:@"password"];
            user.nickName = [resultSet stringForColumn:@"nick_name"];
            user.imageData = [resultSet dataForColumn:@"head_image"];
            user.loginStatus = [resultSet intForColumn:@"login_status"];
            user.token = [resultSet stringForColumn:@"token"];
            user.headImagePath = [resultSet stringForColumn:@"head_image_path"];
            self.currentUser = user;
            finished(user);
        } else {
            finished(nil);
        }
    }];
}

@end
