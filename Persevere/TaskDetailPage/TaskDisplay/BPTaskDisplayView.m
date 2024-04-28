//
//  BPTaskDisplayView.m
//  Persevere
//
//  Created by 张博添 on 2024/2/27.
//

#import "BPTaskDisplayView.h"
#import "BPUIHelper.h"
#import "BPSectionHeaderView.h"
#import "BPInfoCardTableViewCell.h"
#import "BPExtraInfoTableViewCell.h"
#import "BPShowARTableViewCell.h"
#import "BPProgressTableViewCell.h"
#import "BPCalanderTableViewCell.h"
#import "BPDeleteTaskTableViewCell.h"
#import "BPDateHelper.h"
#import "NSDate+DateTools.h"
#import "LocalTaskDataManager.h"

static const CGFloat sectionHeaderViewHeight = 45.0f;
//static const CGFloat calendarViewHeight = 250.f;

@interface BPTaskDisplayView()
<
UITableViewDelegate,
UITableViewDataSource,
BPCalanderTableViewCellDelegate
>

/// 任务信息 tableView
@property (nonatomic, strong) UITableView *displayTableView;

/// 信息标题框
@property (nonatomic, strong) BPSectionHeaderView *infoSectionHeader;
/// 进度标题框
@property (nonatomic, strong) BPSectionHeaderView *progressSectionHeader;
/// 是否可以启用AR
@property (nonatomic, assign, readonly) BOOL isAREnabled;

@end

@implementation BPTaskDisplayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self registerCells];
        self.backgroundColor = [UIColor bp_backgroundThemeColor];
        [self addSubview:self.displayTableView];
    }
    return self;
}

// MARK: Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.bp_width / 2.5;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return self.bp_width / 1.5;
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return sectionHeaderViewHeight;
        case 2:
        case 3:
            return 8.0f;
        default:
            return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.infoSectionHeader;
        case 1:
            return self.progressSectionHeader;
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        // 删除任务
        [self presentAlertToDeleteTask];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        // 展示AR
        [self interactWithARAction];
    }
}

// MARK: BPCalanderTableViewCellDelegate

- (void)didSelectDate:(NSDate *)date {
    if (self.dataSource.task == nil) {
        return;
    }
    [self presentAlertForDate:date];
}

// MARK: 日期操作

/// 选中 date 后弹窗
- (void)presentAlertForDate:(NSDate *)date {
    
//    NSString *memo = [[LocalTaskDataManager sharedInstance] getPunchMemoOfTask:self.task onDate:date];
    NSString *memo = @"";
    NSString *displayMemo;
    NSString *buttonMemoText;
    if (memo == nil || [memo isEqualToString:@""]) {
        displayMemo = @"当日无备注";
        buttonMemoText = @"添加当日备注";
    } else {
        displayMemo = [NSString stringWithFormat:@"%@：%@", @"当日备注：", memo];
        buttonMemoText = @"修改当日备注";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[date formattedDateWithFormat:(NSString *)BPDateFormat] message:displayMemo preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *memoAction = [UIAlertAction actionWithTitle:buttonMemoText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self memoActionOnDate:date];
    }];
    [alert addAction:memoAction];
    
    // 补打卡
    if ([self canFixPunch:date]) {
        UIAlertAction *fixPunchAction = [UIAlertAction actionWithTitle:@"打卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self fixPunchOnDate:date];
        }];
        [alert addAction:fixPunchAction];
    }
    // 取消打卡
    if ([self.dataSource.task.punchDateArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
        UIAlertAction *cancelPunchAction = [UIAlertAction actionWithTitle:@"取消打卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self unpunchOnDate:date];
        }];
        [alert addAction:cancelPunchAction];
    }
    
    // 跳过打卡
    if ([self canSkipTask:date] && [self canFixPunch:date]) {
        UIAlertAction *skipPunchAction = [UIAlertAction actionWithTitle:@"标记跳过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self skipPunchOnDate:date];
        }];
        [alert addAction:skipPunchAction];
    }
    // 取消跳过打卡
    if ([self.dataSource.task.punchSkipArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
        UIAlertAction *unskipPunchAction = [UIAlertAction actionWithTitle:@"取消标记跳过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancelSkipPunchOnDate:date];
        }];
        [alert addAction:unskipPunchAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)canFixPunch:(NSDate *)date {
    if ([[NSDate date] isEarlierThanOrEqualTo:date]) {
        return NO;
    }
    if (self.dataSource.task.endDate != nil
        && [self.dataSource.task.endDate isEarlierThan:date]) {
        return NO;
    } else {
        return ![self.dataSource.task.punchDateArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]
                && [self.dataSource.task.reminderDays containsObject:@(BPConvertToMondayBasedWeekday(date.weekday))]
                && [self.dataSource.task.startDate isEarlierThanOrEqualTo:date];
    }
}

- (BOOL)canSkipTask:(NSDate *)date {
    if ([[NSDate date] isEarlierThanOrEqualTo:date]) {
        return NO;
    }
    if (self.dataSource.task.endDate != nil
        && [self.dataSource.task.endDate isEarlierThan:date]) {
        return NO;
    } else {
        return ![self.dataSource.task.punchSkipArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]
                && [self.dataSource.task.reminderDays containsObject:@(BPConvertToMondayBasedWeekday(date.weekday))]
                && [self.dataSource.task.startDate isEarlierThanOrEqualTo:date];
    }
}

/// 补打卡
- (void)fixPunchOnDate:(NSDate *)date {
    [self.dataSource fixPunchOnDate:date finished:^(BOOL succeeded) {
        if (succeeded) {
            [self mainThreadReloadCalendar];
        }
    }];
}

/// 取消打卡
- (void)unpunchOnDate:(NSDate *)date {
    [self.dataSource unpunchOnDate:date finished:^(BOOL succeeded) {
        if (succeeded) {
            [self mainThreadReloadCalendar];
        }
    }];
}

/// 跳过打卡
- (void)skipPunchOnDate:(NSDate *)date {
    [self.dataSource skipPunchOnDate:date finished:^(BOOL succeeded) {
        if (succeeded) {
            [self mainThreadReloadCalendar];
        }
    }];
}

/// 取消跳过打卡
- (void)cancelSkipPunchOnDate:(NSDate *)date {
    [self.dataSource cancelSkipPunchOnDate:date finished:^(BOOL succeeded) {
        if (succeeded) {
            [self mainThreadReloadCalendar];
        }
    }];
}

- (void)memoActionOnDate:(NSDate *)date {
    
}

- (void)mainThreadReloadCalendar {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.displayTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    });
}

// MARK: 删除

/// 弹出确认删除弹窗
- (void)presentAlertToDeleteTask {
    UIAlertController *deleteAlertController = [UIAlertController alertControllerWithTitle:@"是否确认删除任务" message:@"此操作不可逆" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(deleteCurrentTask)]) {
            [self.delegate deleteCurrentTask];
        }
    }];
    [deleteAlertController addAction:cancelAction];
    [deleteAlertController addAction:deleteAction];
    [self.parentViewController presentViewController:deleteAlertController animated:YES completion:nil];
}

/// 点击AR按钮后操作
- (void)interactWithARAction {
    if (!self.isAREnabled) {
        // AR不可用
        UIAlertController *tipAlertController = [UIAlertController alertControllerWithTitle:@"此任务不支持AR自动展示" message:@"请为此任务添加图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [tipAlertController addAction:cancelAction];
        [self.parentViewController presentViewController:tipAlertController animated:YES completion:nil];
    } else if ([self.delegate respondsToSelector:@selector(currentTaskInteractWithAR)]) {
        // 可以使用AR
        [self.delegate currentTaskInteractWithAR];
    }
}

// MARK: 返回cell

- (void)registerCells {
    [self.displayTableView registerClass:[BPInfoCardTableViewCell class] forCellReuseIdentifier:@"infoCard"];
    [self.displayTableView registerClass:[BPExtraInfoTableViewCell class] forCellReuseIdentifier:@"extraInfo"];
    [self.displayTableView registerClass:[BPShowARTableViewCell class] forCellReuseIdentifier:@"ar"];
    [self.displayTableView registerClass:[BPProgressTableViewCell class] forCellReuseIdentifier:@"progress"];
    [self.displayTableView registerClass:[BPCalanderTableViewCell class] forCellReuseIdentifier:@"calander"];
    [self.displayTableView registerClass:[BPDeleteTaskTableViewCell class] forCellReuseIdentifier:@"delete"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 1-1 信息展示
        BPInfoCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCard" forIndexPath:indexPath];
        [cell bindTask:self.dataSource.task];
        return cell;
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        // 1-2 信息分类
        BPExtraInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extraInfo" forIndexPath:indexPath];
        TaskModel *task = self.dataSource.task;
        UIImage *image = task.imageData != nil ? [UIImage imageWithData:task.imageData] : nil;
        [cell bindWithModel:[[BPInfoTabViewModel alloc] initWithLink:task.link image:image memo:task.memo]];
        return cell;
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        // 1-3 单任务AR识别图片
        BPShowARTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ar" forIndexPath:indexPath];
        cell.bp_titleLabel.text = @"在AR世界中自动展示任务";
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        // 2-1 进度
        BPProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"progress" forIndexPath:indexPath];
        [cell bindModel:[[BPProgressTableViewCellModel alloc] initWithPunchedDayCount:self.dataSource.task.punchDays totalDayCount:self.dataSource.task.totalDays]];
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        // 2-2 日历
        BPCalanderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calander" forIndexPath:indexPath];
        [cell bindTask:self.dataSource.task];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
        // 2-3 删除
        BPDeleteTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"delete" forIndexPath:indexPath];
        cell.bp_titleLabel.text = @"删除任务";
        return cell;
        
    }
    return [[UITableViewCell alloc] init];
}

// MARK: Getters

- (UITableView *)displayTableView {
    if (!_displayTableView) {
        _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, self.bp_height) style:UITableViewStyleGrouped];
        _displayTableView.delegate = self;
        _displayTableView.sectionFooterHeight = 0;
        _displayTableView.sectionHeaderHeight = 0;
        _displayTableView.dataSource = self;
        _displayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _displayTableView.backgroundColor = [UIColor bp_backgroundThemeColor];
        
    }
    return _displayTableView;
}

- (BPSectionHeaderView *)infoSectionHeader {
    if (!_infoSectionHeader) {
        _infoSectionHeader = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderViewHeight) title:@"基本信息"];
    }
    return _infoSectionHeader;
}

- (BPSectionHeaderView *)progressSectionHeader {
    if (!_progressSectionHeader) {
        _progressSectionHeader = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderViewHeight) title:@"完成进度"];
    }
    return _progressSectionHeader;
}

- (BOOL)isAREnabled {
    // 图片不为空则启用
    return self.dataSource.task.imageData != nil;
}

@end
