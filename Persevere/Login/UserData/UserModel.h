//
//  UserModel.h
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : JSONModel

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSData *imageData;
// 0：未登录
// 1：已登录
// 2：游客
@property (nonatomic, assign) NSInteger loginStatus;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *headImagePath;

@end

NS_ASSUME_NONNULL_END
