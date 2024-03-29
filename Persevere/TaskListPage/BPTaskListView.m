//
//  BPTaskListPageView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import "BPTaskListView.h"
#import "BPUIHelper.h"
#import "BPSectionHeaderView.h"
#import "BPTableViewHoverView.h"
#import "LocalTaskDataManager.h"
#import "BPColorPickerView.h"
#import "BPWeekDayPickerView.h"

static const CGFloat sectionHeaderHeight = 45.f;

static const CGFloat weekdayAndColorPadding = 10.f;
static const CGFloat weekdayViewHeight = 50.f;
static const CGFloat colorViewHeight = 50.f;

static const CGFloat hBorderPadding = 10.0f;
static const CGFloat vBorderPadding = 10.0f;

@interface BPTaskListView()
<
UITableViewDelegate,
UITableViewDataSource,
BPColorPickerDelegate,
BPWeekdayPickerDelegate
>

/// tableView
@property (nonatomic, strong) UITableView *taskListTableView;
/// 顶部星期日和颜色悬浮View
@property (nonatomic, strong) BPTableViewHoverView *hoverView;
/// weekday View
@property (nonatomic, strong) BPWeekDayPickerView *weekdayPickerView;
/// 颜色View
@property (nonatomic, strong) BPColorPickerView *colorPickerView;

/// 今日未完成数组
@property (nonatomic, nonnull) NSMutableArray *unfinishedTaskArr;
/// 今日已完成数组
@property (nonatomic, nonnull) NSMutableArray *finishedTaskArr;
/// 选择颜色num
@property (nonatomic, assign) NSInteger selectedColorNum;
/// weekday Array
@property (nonatomic, strong) NSMutableArray *selectedWeekdayArray;

@end

@implementation BPTaskListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bp_backgroundThemeColor];
        [self addSubview:self.taskListTableView];
        [self.hoverView addSubview:self.weekdayPickerView];
        [self.hoverView addSubview:self.colorPickerView];
        [self.taskListTableView addSubview:self.hoverView];
        [self.taskListTableView bringSubviewToFront:self.hoverView];
        [self.taskListTableView addObserver:self.hoverView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)navigationTitleViewTapped {
    if (!self.hoverView.isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.taskListTableView setContentOffset:CGPointZero];
        } completion:^(BOOL finished) {
            [self.hoverView show];
        }];
    } else {
        [self.hoverView hide];
    }
}

// MARK: Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return self.unfinishedTaskArr.count;
        case 2:
            return self.finishedTaskArr.count;
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1: {
            if ([self.unfinishedTaskArr count] == 0) {
                return [UIView new];
            } else {
                BPSectionHeaderView *view = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderHeight) title:@"进行中"];
                return view;
            }
        }
        case 2: {
            if ([self.finishedTaskArr count] == 0) {
                return [UIView new];
            } else {
                BPSectionHeaderView *view = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderHeight) title:@"已结束"];
                return view;
            }
        }
        default:
            return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
        {
            if (self.unfinishedTaskArr.count == 0) {
                return CGFLOAT_MIN;
            } else {
                return sectionHeaderHeight;
            }
        }
        case 2:
            if (self.finishedTaskArr.count == 0) {
                return CGFLOAT_MIN;
            } else {
                return sectionHeaderHeight;
            }
        default:
            return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// MARK: Getters

- (BPWeekDayPickerView *)weekdayPickerView {
    if (!_weekdayPickerView) {
        _weekdayPickerView = [[BPWeekDayPickerView alloc] initWithFrame:CGRectMake(10, 10, self.hoverView.bp_width - 20, weekdayViewHeight)];
        [_weekdayPickerView refreshViewsWithSelectedWeekDayArray:self.selectedWeekdayArray];
        _weekdayPickerView.delegate = self;
        _weekdayPickerView.layer.cornerRadius = 10.0;
    }
    return _weekdayPickerView;
}

- (BPColorPickerView *)colorPickerView {
    if (!_colorPickerView) {
        _colorPickerView = [[BPColorPickerView alloc] initWithFrame:CGRectMake(self.weekdayPickerView.bp_left, self.weekdayPickerView.bp_bottom + weekdayAndColorPadding, self.weekdayPickerView.bp_width, colorViewHeight) andSelectedItem:0];
        _colorPickerView.delegate = self;
        _colorPickerView.layer.cornerRadius = 10.0;
    }
    return _colorPickerView;
}

- (BPTableViewHoverView *)hoverView {
    if (!_hoverView) {
        _hoverView = [[BPTableViewHoverView alloc] initWithFrame:CGRectMake(hBorderPadding, -(weekdayAndColorPadding * 3 + weekdayViewHeight + colorViewHeight), self.bp_width - 2 * vBorderPadding, (weekdayAndColorPadding * 3 + weekdayViewHeight + colorViewHeight)) andVerticalBorderWidth:2 * vBorderPadding];
        _hoverView.headerScrollView = self.taskListTableView;
    }
    return _hoverView;
}

- (UITableView *)taskListTableView {
    if (!_taskListTableView) {
        _taskListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, self.bp_height) style:UITableViewStyleGrouped];
        _taskListTableView.sectionFooterHeight = CGFLOAT_MIN;
        _taskListTableView.delegate = self;
        _taskListTableView.dataSource = self;
        _taskListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _taskListTableView;
}

- (NSMutableArray *)selectedWeekdayArray {
    if (!_selectedWeekdayArray) {
        _selectedWeekdayArray = [[NSMutableArray alloc] initWithArray:@[@1, @2, @3, @4, @5, @6, @7]];
    }
    return _selectedWeekdayArray;
}

@end
