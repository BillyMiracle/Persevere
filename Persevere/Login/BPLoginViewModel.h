//
//  BPLoginViewModel.h
//  Persevere
//
//  Created by 张博添 on 2024/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LoginFinishedBlock)(BOOL isRegistered, BOOL isCodeCorrect);

@interface BPLoginViewModel : NSObject

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password finished:(LoginFinishedBlock)finished;

- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code finished:(LoginFinishedBlock)finished;

@end

NS_ASSUME_NONNULL_END
