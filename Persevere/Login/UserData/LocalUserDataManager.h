//
//  LocalUserDataManager.h
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

typedef void (^IsRegisteredBlock)(BOOL succeeded, BOOL isRegistered);
typedef void (^LoginBlock)(BOOL isRegistered, BOOL isPasswordCorrect);
typedef void (^UserDataProcessFinishedBlock)(BOOL succeeded);
typedef void (^UserDataFetchFinishedBlock)(UserModel *_Nullable user);

@interface LocalUserDataManager : NSObject

@property (nonatomic, strong) UserModel *currentUser;

/// 获取Manager单例对象
+ (_Nonnull instancetype)sharedInstance;

- (void)checkIsPhoneRegistered:(NSString *)phoneNumber finished:(IsRegisteredBlock)finished;

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password finished:(LoginBlock)finished;

- (void)registerWithUserModel:(UserModel *)user finished:(UserDataProcessFinishedBlock)finished;

- (void)fetchCurrentUserFinished:(UserDataFetchFinishedBlock)finished;

- (void)updateUserName:(NSString *)name finished:(UserDataProcessFinishedBlock)finished;
- (void)updateUserPhoneNumber:(NSString *)phoneNumber finished:(UserDataProcessFinishedBlock)finished;
- (void)updateUserPassword:(NSString *)password finished:(UserDataProcessFinishedBlock)finished;
- (void)updateUserHeadImage:(NSDate *)imageData finished:(UserDataProcessFinishedBlock)finished;

- (void)closeCurrentAccountFinished:(UserDataProcessFinishedBlock)finished;

- (void)logoutFinished:(UserDataProcessFinishedBlock)finished;

@end

NS_ASSUME_NONNULL_END
