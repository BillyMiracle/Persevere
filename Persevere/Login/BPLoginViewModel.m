//
//  BPLoginViewModel.m
//  Persevere
//
//  Created by 张博添 on 2024/4/23.
//

#import "BPLoginViewModel.h"
#import "LocalUserDataManager.h"

@implementation BPLoginViewModel

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password finished:(LoginFinishedBlock)finished {
    [[LocalUserDataManager sharedInstance] loginWithPhoneNumber:phoneNumber password:password finished:^(BOOL isRegistered, BOOL isPasswordCorrect) {
        finished(isRegistered, isPasswordCorrect);
    }];
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code finished:(LoginFinishedBlock)finished {
    NSString *correctCode = @"151488";
    BOOL isCorrect = [code isEqualToString:correctCode];
    [[LocalUserDataManager sharedInstance] checkIsPhoneRegistered:phoneNumber finished:^(BOOL succeeded, BOOL isRegistered) {
        if (succeeded) {
            finished(isRegistered, isCorrect);
        } else {
            finished(NO, NO);
        }
    }];
}

@end
