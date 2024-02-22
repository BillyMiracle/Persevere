//
//  UserNotificationManager.h
//  Persevere
//
//  Created by 张博添 on 2023/11/15.
//

#import <Foundation/Foundation.h>
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserNotificationManager : NSObject

+ (void)createLocalizedUserNotification:(TaskModel *)task;
+ (void)deleteLocalizedUserNotification:(TaskModel *)task;
+ (void)printNumberOfNotifications;
+ (void)reconstructNotifications;

@end

NS_ASSUME_NONNULL_END
