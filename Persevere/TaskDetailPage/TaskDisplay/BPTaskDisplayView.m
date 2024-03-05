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

static const CGFloat sectionHeaderViewHeight = 45.0f;

@interface BPTaskDisplayView()
<
UITableViewDelegate,
UITableViewDataSource
>

/// 任务信息 tableView
@property (nonatomic, strong) UITableView *displayTableView;

/// 信息标题框
@property (nonatomic, strong) BPSectionHeaderView *infoSectionHeader;
/// 进度标题框
@property (nonatomic, strong) BPSectionHeaderView *progressSectionHeader;

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
            return 2;
        case 1:
            return 3;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 140;
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
//    NSLog(@"%@", indexPath);
}

// MARK: 返回cell

- (void)registerCells {
    [self.displayTableView registerClass:[BPInfoCardTableViewCell class] forCellReuseIdentifier:@"infoCard"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        BPInfoCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCard" forIndexPath:indexPath];
        [cell bindTask:self.dataSource.task];
        cell.isTopBorder = YES;
        cell.isBottomBorder = YES;
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

@end
