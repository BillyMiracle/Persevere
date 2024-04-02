//
//  BPSettingView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/28.
//

#import "BPSettingView.h"
#import "BPUIHelper.h"
#import "BPSettingSectionView.h"
#import "BPSettingSwitchTableViewCell.h"
#import "BPSettingBaseTableViewCell.h"
#import "LocalSettingDataManager.h"

static const CGFloat sectionHeaderViewHeight = 40.0f;

@interface BPSettingView()
<
UITableViewDelegate,
UITableViewDataSource,
BPSettingSwitchTableViewCellDelegate
>

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSArray *sectionHeaderTitleArray;

@end

@implementation BPSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bp_backgroundThemeColor];
        [self addSubview:self.settingTableView];
    }
    return self;
}

// MARK: Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 2;
        case 3:
            return 3;
        case 4:
            return 4;
        case 5:
            return 1;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGFLOAT_MIN;
        case 1:
        case 2:
        case 3:
        case 4:
            return sectionHeaderViewHeight;
        default:
            return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
        case 2:
        case 3:
        case 4:
            return [self sectionHeaderViewWithTitle:self.sectionHeaderTitleArray[section - 1]];
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)sectionHeaderViewWithTitle:(NSString *)title {
    return [[BPSettingSectionView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderViewHeight) title:title];
}

// MARK: 返回cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        // 个人信息
        
    } else if (section == 1 && row == 0) {
        // iCloud备份
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"iCloud备份"];
        return cell;
    } else if (section == 1 && row == 1) {
        // 清理缓存
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"清理缓存"];
        return cell;
    } else if (section == 2 && row == 0) {
        // 是否开启大字号
        BPSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        [LocalSettingDataManager.sharedInstance getSettingFromName:BPLocalSettingBigFont succeeded:^(BOOL isOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setSwitchStatus:isOn];
            });
        }];
        [cell.textLabel setText:@"是否开启大字号"];
        return cell;
    } else if (section == 2 && row == 1) {
        // 动画效果
        BPSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        [LocalSettingDataManager.sharedInstance getSettingFromName:BPLocalSettingAnimation succeeded:^(BOOL isOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setSwitchStatus:isOn];
            });
        }];
        [cell.textLabel setText:@"动画效果"];
        cell.delegate = self;
        return cell;
    } else if (section == 3 && row == 0) {
        // 类别颜色备注
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"类别颜色备注"];
        return cell;
    } else if (section == 3 && row == 1) {
        // 角标显示今日未完成任务数
        BPSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        [LocalSettingDataManager.sharedInstance getSettingFromName:BPLocalSettingShowUndoneCount succeeded:^(BOOL isOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setSwitchStatus:isOn];
            });
        }];
        [cell.textLabel setText:@"角标显示今日未完成任务数"];
        cell.delegate = self;
        return cell;
    } else if (section == 3 && row == 2) {
        // 首页自动刷新今日日期
        BPSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        [LocalSettingDataManager.sharedInstance getSettingFromName:BPLocalSettingAutoRefreshTodayDate succeeded:^(BOOL isOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setSwitchStatus:isOn];
            });
        }];
        [cell.textLabel setText:@"首页自动刷新今日日期"];
        cell.delegate = self;
        return cell;
    } else if (section == 4 && row == 0) {
        // 联系作者
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"联系作者"];
        return cell;
    } else if (section == 4 && row == 1) {
        // 评价我们
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"评价我们"];
        return cell;
    } else if (section == 4 && row == 2) {
        // 常见问题
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"常见问题"];
        return cell;
    } else if (section == 4 && row == 3) {
        // 致谢
        BPSettingBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"致谢"];
        return cell;
    } else if (section == 5 && row == 0) {
        // 图标
        
    }
    
    return [[UITableViewCell alloc] init];
}

// MARK: BPSettingSwitchTableViewCellDelegate

- (void)switchValueChanged:(UITableViewCell *)cell value:(BOOL)value {
    NSIndexPath *indexPath = [self.settingTableView indexPathForCell:cell];
    
}

// MARK: Getters

- (UITableView *)settingTableView {
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, self.bp_height) style:UITableViewStyleGrouped];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        
        [_settingTableView registerClass:[BPSettingBaseTableViewCell class] forCellReuseIdentifier:@"base"];
        [_settingTableView registerClass:[BPSettingSwitchTableViewCell class] forCellReuseIdentifier:@"switch"];
    }
    return _settingTableView;
}

- (NSArray *)sectionHeaderTitleArray {
    return @[
        @"数据",
        @"外观",
        @"偏好",
        @"其他"
    ];
}

@end
