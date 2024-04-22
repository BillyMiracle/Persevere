//
//  BPSelectTableViewCellModel.m
//  Persevere
//
//  Created by 张博添 on 2024/4/22.
//

#import "BPSelectTableViewCellModel.h"

@implementation BPSelectTableViewCellModel

- (instancetype)initWithTask:(TaskModel *)task selected:(BOOL)selected {
    self = [super init];
    self.task = task;
    self.selected = selected;
    return self;
}

@end
