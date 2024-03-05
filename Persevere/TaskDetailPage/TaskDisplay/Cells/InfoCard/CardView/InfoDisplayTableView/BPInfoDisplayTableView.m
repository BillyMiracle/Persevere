//
//  BPInfoDisplayTableView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import "BPInfoDisplayTableView.h"
#import "BPUIHelper.h"
#import "TaskModel.h"
#import "BPDateHelper.h"
#import "NSDate+DateTools.h"

#import "IconAndLabelTableViewCell.h"

/// 行数
static const int rowCount = 4;

@interface BPInfoDisplayTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) TaskModel *task;
@property (nonatomic, assign, readonly) CGFloat lineHeight;

/// 图标
@property (nonatomic, copy) NSArray<UIImage *> *imageArray;

@end

@implementation BPInfoDisplayTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerCells];
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)reloadWithTask:(TaskModel *)task {
    self.task = task;
    [self reloadData];
}

- (void)registerCells {
    [self registerClass:[IconAndLabelTableViewCell class] forCellReuseIdentifier:@"IconAndLabelCell"];
    
}

// MARK: UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.lineHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", indexPath);
}

// MARK: 返回cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 前面3个，左侧icon，右侧文字
        if (indexPath.row != 4) {
            IconAndLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconAndLabelCell" forIndexPath:indexPath];
            
            cell.iconView.image = [self.imageArray objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self titleForRow:indexPath.row];
            
            return cell;
        } else if (indexPath.row == 4) {
            
        }
    }
    return [[UITableViewCell alloc] init];
}

- (NSString *)titleForRow:(NSInteger)row {
    switch (row) {
        case 0:
            return [NSString stringWithFormat:@"%@ 起", [self.task.startDate formattedDateWithFormat:(NSString *)BPDateFormat]];
        case 1:
            return [self.task.endDate formattedDateWithFormat:(NSString *)BPDateFormat] ?: (NSString *)BPEndlessString;
        case 2:
            return self.task.reminderTime ? [self.task.reminderTime formattedDateWithFormat:(NSString *)BPTimeFormat] : @"全天";
    }
    return @"";
}

- (UIImage *)imageForRow:(NSInteger)row {
    if (row < self.imageArray.count) {
        return [self.imageArray objectAtIndex:row];
    }
    return [UIImage new];
}

// MARK: Getters

- (CGFloat)lineHeight {
    return self.bp_height / (CGFloat)rowCount;
}

- (NSArray<UIImage *> *)imageArray {
    if (!_imageArray) {
        _imageArray = @[
            [UIImage imageNamed:@"Start"],
            [UIImage imageNamed:@"Stop"],
            [UIImage imageNamed:@"Clock"],
            [UIImage imageNamed:@"Calander"]
        ];
    }
    return _imageArray;
}

@end
