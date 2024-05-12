//
//  BPRegisterViewModel.h
//  Persevere
//
//  Created by 张博添 on 2024/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

typedef void (^RegisterFinishedBlock)(BOOL succeeded);

@interface BPRegisterViewModel : NSObject

- (void)registerWithUser:(UserModel *)user finished:(RegisterFinishedBlock)finished;

@end

NS_ASSUME_NONNULL_END
