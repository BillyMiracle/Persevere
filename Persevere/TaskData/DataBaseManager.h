//
//  DataBaseManager.h
//  Persevere
//
//  Created by 张博添 on 2023/11/15.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataBaseManager : NSObject

//@property (nonatomic, nullable) FMDatabase *database;
@property (nonatomic, nullable) FMDatabaseQueue *databaseQueue;
/// 数据库路径
@property (nonatomic, copy) NSString *databasePath;

+ (_Nonnull instancetype)shareInstance;
- (void)closeDataBase;

@end

NS_ASSUME_NONNULL_END
