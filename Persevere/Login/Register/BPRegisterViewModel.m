//
//  BPRegisterViewModel.m
//  Persevere
//
//  Created by 张博添 on 2024/5/12.
//

#import "BPRegisterViewModel.h"
#import "LocalUserDataManager.h"

@implementation BPRegisterViewModel

- (void)registerWithUser:(UserModel *)user finished:(RegisterFinishedBlock)finished {
    [[LocalUserDataManager sharedInstance] registerWithUserModel:user finished:^(BOOL succeeded) {
        finished(succeeded);
    }];
}

@end
