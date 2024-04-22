//
//  BPSelectTableViewCellModel.h
//  Persevere
//
//  Created by 张博添 on 2024/4/22.
//

#import "TaskModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPSelectTableViewCellModel : NSObject

@property (nonatomic, strong) TaskModel *task;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithTask:(TaskModel *)task selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
