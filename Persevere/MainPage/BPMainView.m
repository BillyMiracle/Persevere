//
//  BPMainPageView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import "BPMainView.h"
#import "BPUIHelper.h"
#import "BPSectionHeaderView.h"
#import "BPTableViewHoverView.h"
#import "LocalTaskDataManager.h"
#import "FSCalendar.h"
#import "BPColorPickerView.h"
#import "DateTools.h"
#import "TaskDataHelper.h"
#import "BPDateAndProgressTableViewCell.h"
#import "BPARInteractTableViewCell.h"
#import "BPMainPageTaskTableViewCell.h"

static const CGFloat sectionHeaderHeight = 45.f;

//static const CGFloat calendarAndColorViewHeight = 300.f;
static const CGFloat calendarAndColorPadding = 10.f;
static const CGFloat calendarViewHeight = 230.f;
static const CGFloat colorViewHeight = 50.f;

static const CGFloat hBorderPadding = 10.0f;
static const CGFloat vBorderPadding = 10.0f;

@interface BPMainView()
<
UITableViewDelegate,
UITableViewDataSource,
FSCalendarDataSource,
FSCalendarDelegate,
BPColorPickerDelegate,
BPMainPageTaskTableViewCellDelegate,
MGSwipeTableCellDelegate,
BPARInteractTableViewCellDelegate
>

typedef void (^loadTasksFinishedBlock)(BOOL success);

@property (nonnull, nonatomic) NSCalendar *gregorian;

/// tableView
@property (nonatomic, strong) UITableView *mainTableView;
/// 顶部日历和颜色悬浮View
@property (nonatomic, strong) BPTableViewHoverView *hoverView;
/// 日历View
@property (nonatomic, strong) FSCalendar *fsCalendarView;
@property (nonatomic, strong) UIButton *previousMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;
/// 颜色View
@property (nonatomic, strong) BPColorPickerView *colorPickerView;
/// 日期View手势
@property (nonatomic, strong) UIGestureRecognizer *tapDateViewGesture;
/// 今日未完成数组
@property (nonatomic, nonnull) NSMutableArray *unfinishedTaskArr;
/// 今日已完成数组
@property (nonatomic, nonnull) NSMutableArray *finishedTaskArr;
/// 选择日期
@property (nonnull, nonatomic) NSDate *selectedDate;
/// 选择indexPath
@property (nullable, nonatomic) NSIndexPath *selectedIndexPath;;
/// 选择颜色num
@property (nonatomic, assign) NSInteger selectedColorNum;

@end

@implementation BPMainView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bp_backgroundThemeColor];
        
        [self addSubview:self.mainTableView];
        [self.fsCalendarView addSubview:self.previousMonthButton];
        [self.fsCalendarView addSubview:self.nextMonthButton];
        [self.hoverView addSubview:self.fsCalendarView];
        [self.hoverView addSubview:self.colorPickerView];
        [self.mainTableView addSubview:self.hoverView];
        [self.mainTableView bringSubviewToFront:self.hoverView];
        
        [self.mainTableView addObserver:self.hoverView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)refreshAndLoadTasksWithDate:(NSDate *)date {
    if (!self.selectedDate) {
        self.selectedDate = date;
    }
    if (![self.fsCalendarView.today isToday]) {
        self.selectedDate = [NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]];
    }
    self.fsCalendarView.today = [NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]];
    [self.fsCalendarView selectDate:self.selectedDate scrollToDate:YES];
    [self loadTasksFinished:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
    }];
}

- (void)refreshDateViewAndProgressLabel {
    [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)loadTasksFinished:(loadTasksFinishedBlock)finishedBlock {
    [[LocalTaskDataManager sharedInstance] getTasksOfDate:self.selectedDate finished:^(NSMutableArray * _Nonnull taskArray) {
        [self.unfinishedTaskArr removeAllObjects];
        [self.finishedTaskArr removeAllObjects];;
        for (TaskModel *task in taskArray) {
            if ([task hasPunchedOnDate:self.selectedDate]) {
                [self.finishedTaskArr addObject:task];
            } else {
                [self.unfinishedTaskArr addObject:task];
            }
        }
            
        //排序
        [self sortTasks];
        
        // 按照颜色筛选
        self.unfinishedTaskArr = [NSMutableArray arrayWithArray:[TaskDataHelper filtrateTasks:self.unfinishedTaskArr withType:self.selectedColorNum]];
        self.finishedTaskArr = [NSMutableArray arrayWithArray:[TaskDataHelper filtrateTasks:self.finishedTaskArr withType:self.selectedColorNum]];
        NSLog(@"%@", self.unfinishedTaskArr);
        finishedBlock(YES);
    } error:^(NSError * _Nonnull error) {}];
}

- (void)sortTasksAndReloadTableView {
    [self sortTasksFinished:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
            });
        }
    }];
}

- (void)sortTasksFinished:(loadTasksFinishedBlock)finishedBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sortTasks];
        finishedBlock(YES);
    });
}

- (void)sortTasks {
    NSDictionary *sortDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"sort"];
    NSString *sortFactor = sortDict.allKeys[0];
    NSNumber *isAscend = sortDict.allValues[0];
    self.unfinishedTaskArr = [NSMutableArray arrayWithArray:[TaskDataHelper sortTasks:self.unfinishedTaskArr withSortFactor:sortFactor isAscend:isAscend.boolValue]];
    self.finishedTaskArr = [NSMutableArray arrayWithArray:[TaskDataHelper sortTasks:self.finishedTaskArr withSortFactor:sortFactor isAscend:isAscend.boolValue]];
}

// MARK: Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
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
                BPSectionHeaderView *view = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderHeight) title:@"未完成"];
                return view;
            }
        }
        case 2: {
            if ([self.finishedTaskArr count] == 0) {
                return [UIView new];
            } else {
                BPSectionHeaderView *view = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderHeight) title:@"已完成"];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        BPDateAndProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateAndProgress" forIndexPath:indexPath];
        [cell.dateView refreshWithDate:self.selectedDate];
        [cell.progressLabel setProgressWithFinished:self.finishedTaskArr.count andTotal:(self.finishedTaskArr.count + self.unfinishedTaskArr.count)];
        if (![cell.dateView.gestureRecognizers containsObject:self.tapDateViewGesture]) {
            [cell.dateView addGestureRecognizer:self.tapDateViewGesture];
        }
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        BPARInteractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ar" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        BPMainPageTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
        cell.bp_indexPath = indexPath;
        [cell bindTask:[self.unfinishedTaskArr objectAtIndex:indexPath.row]];
        cell.checkDelegate = self;
        cell.delegate = self;
        [cell setIsFinished:NO];
        return cell;
    } else if (indexPath.section == 2) {
        BPMainPageTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
        cell.bp_indexPath = indexPath;
        [cell bindTask:[self.finishedTaskArr objectAtIndex:indexPath.row]];
        cell.checkDelegate = self;
        cell.delegate = self;
        [cell setIsFinished:YES];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return timeAndProgressViewHeight;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        return 60;
    }
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return NO;
    }
    return self.selectedIndexPath != indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// MARK: TaskCell代理方法

- (void)checkTaskAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        TaskModel *task = self.unfinishedTaskArr[indexPath.row];
        [[LocalTaskDataManager sharedInstance] punchForTaskWithID:@(task.taskId) onDate:self.selectedDate finished:^(BOOL succeeded) {
            if (succeeded) {
                [self loadTasksFinished:^(BOOL success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainTableView reloadData];
                    });
                }];
            }
        }];
    } else if(indexPath.section == 2) {
        TaskModel *task = self.finishedTaskArr[indexPath.row];
        [[LocalTaskDataManager sharedInstance] unpunchForTaskWithID:@(task.taskId) onDate:self.selectedDate finished:^(BOOL succeeded) {
            if (succeeded) {
                [self loadTasksFinished:^(BOOL success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainTableView reloadData];
                    });
                }];
            }
        }];
    }
}

// MARK: MGSwipeCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    switch (direction) {
        case MGSwipeDirectionLeftToRight:
        {
            // 右滑，点击详情
            TaskModel *task = [self taskAtIndexPath:indexPath];
            if ([self.delegate respondsToSelector:@selector(displayTask:)]) {
                [self.delegate displayTask:task];
            }
        }
            break;
        case MGSwipeDirectionRightToLeft:
        {
            // 左滑，点击删除
            [self presentAlertToDeleteTaskAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

// MARK: 删除任务

/// 弹出确认删除弹窗
- (void)presentAlertToDeleteTaskAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *deleteAlertController = [UIAlertController alertControllerWithTitle:@"是否确认删除此任务" message:@"此操作不可逆" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteTaskAtIndexPath:indexPath];
    }];
    [deleteAlertController addAction:cancelAction];
    [deleteAlertController addAction:deleteAction];
    [self.parentViewController presentViewController:deleteAlertController animated:YES completion:nil];
}

/// 删除任务并刷新列表
- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskModel *task = [self taskAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        [self.unfinishedTaskArr removeObject:task];
    } else if(indexPath.section == 2) {
        [self.finishedTaskArr removeObject:task];
    }
    
    [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [[LocalTaskDataManager sharedInstance] deleteTask:task finished:^(BOOL succeeded) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.finishedTaskArr.count == 0 || self.unfinishedTaskArr.count == 0) {
                    [self.mainTableView reloadData];
                }
                [self refreshDateViewAndProgressLabel];
            });
        }
    }];
}

// MARK: 找到任务

- (TaskModel *)taskAtIndexPath:(NSIndexPath *)indexPath {
    TaskModel *task = nil;
    if (indexPath.section == 1) {
        task = self.unfinishedTaskArr[indexPath.row];
    } else if(indexPath.section == 2) {
        task = self.finishedTaskArr[indexPath.row];
    }
    return task;
}

// MARK: 点击标题

- (void)navigationTitleViewTapped {
    if (!self.hoverView.isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.mainTableView setContentOffset:CGPointZero];
        } completion:^(BOOL finished) {
            [self.hoverView show];
        }];
    } else {
        [self.hoverView hide];
    }
    [self.fsCalendarView selectDate:self.selectedDate scrollToDate:YES];
}

/// 日期view被点击
- (void)tapDateView {
    [self navigationTitleViewTapped];
}

// MARK: 日历相关

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.selectedDate = date;
    [self loadTasksFinished:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
    }];
}

/// 上一月
- (void)previousClicked:(id)sender {
    NSDate *currentMonth = self.fsCalendarView.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.fsCalendarView setCurrentPage:previousMonth animated:YES];
}

/// 下一月
- (void)nextClicked:(id)sender {
    NSDate *currentMonth = self.fsCalendarView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.fsCalendarView setCurrentPage:nextMonth animated:YES];
}

// MARK: 修改颜色
- (void)didChangeColor:(NSInteger)selectedColorIndex {
    [self.delegate changeColor:selectedColorIndex];
    self.selectedColorNum = selectedColorIndex;
    [self loadTasksFinished:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
    }];
}

// MARK: BPARInteractTableViewCellDelegate

- (void)didSelectAutoAddTask {
    if ([self.delegate respondsToSelector:@selector(interactWithARwithType:)]) {
        [self.delegate interactWithARwithType:BPARTypeAutomatically];
    }
}

- (void)didSelectManualAddTask {
    if ([self.delegate respondsToSelector:@selector(interactWithARwithType:)]) {
        [self.delegate interactWithARwithType:BPARTypeManually];
    }
}

// MARK: Getters

- (FSCalendar *)fsCalendarView {
    if (!_fsCalendarView) {
        _fsCalendarView = [[FSCalendar alloc] initWithFrame:CGRectMake(10, 10, self.hoverView.bp_width - 20, calendarViewHeight)];
        _fsCalendarView.dataSource = self;
        _fsCalendarView.delegate = self;
        _fsCalendarView.backgroundColor = [UIColor whiteColor];
        _fsCalendarView.layer.cornerRadius = 10;
        _fsCalendarView.appearance.separators = FSCalendarSeparatorNone;
        _fsCalendarView.clipsToBounds = YES;
        
        _fsCalendarView.appearance.titleFont = [UIFont systemFontOfSize:12.0];
        _fsCalendarView.appearance.headerTitleFont = [UIFont systemFontOfSize:15.0];
        _fsCalendarView.appearance.weekdayFont = [UIFont systemFontOfSize:12.0];
        _fsCalendarView.appearance.subtitleFont = [UIFont systemFontOfSize:10.0];
        
        _fsCalendarView.appearance.headerMinimumDissolvedAlpha = 0;
        _fsCalendarView.appearance.headerDateFormat = @"yyyy / MM";
        
        _fsCalendarView.appearance.headerTitleColor = [UIColor bp_defaultThemeColor];
        _fsCalendarView.appearance.weekdayTextColor = [UIColor bp_defaultThemeColor];
        _fsCalendarView.appearance.selectionColor =  [UIColor bp_defaultThemeColor];
        _fsCalendarView.appearance.titleSelectionColor = [UIColor whiteColor];
        
        _fsCalendarView.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _fsCalendarView.today = [NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]];
    }
    return _fsCalendarView;
}

- (UIButton *)previousMonthButton {
    if (!_previousMonthButton) {
        _previousMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousMonthButton.backgroundColor = [UIColor clearColor];
        _previousMonthButton.frame = CGRectMake(0, 3, 100, 32);
        [_previousMonthButton setTintColor:[UIColor bp_defaultThemeColor]];
        UIImage *leftImg = [UIImage imageNamed:@"PreviousMonth"];
        leftImg = [leftImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_previousMonthButton setImage:leftImg forState:UIControlStateNormal];
        [_previousMonthButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousMonthButton;
}

- (UIButton *)nextMonthButton {
    if (!_nextMonthButton) {
        _nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextMonthButton.backgroundColor = [UIColor clearColor];
        _nextMonthButton.frame = CGRectMake(self.fsCalendarView.bp_width - 100, 3, 100, 32);
        [_nextMonthButton setTintColor:[UIColor bp_defaultThemeColor]];
        UIImage *rightImg = [UIImage imageNamed:@"NextMonth"];
        rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_nextMonthButton setImage:rightImg forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextMonthButton;
}

- (BPColorPickerView *)colorPickerView {
    if (!_colorPickerView) {
        _colorPickerView = [[BPColorPickerView alloc] initWithFrame:CGRectMake(self.fsCalendarView.bp_left, self.fsCalendarView.bp_bottom + calendarAndColorPadding, self.fsCalendarView.bp_width, colorViewHeight) andSelectedItem:0];
        _colorPickerView.delegate = self;
        _colorPickerView.layer.cornerRadius = 10.0;
    }
    return _colorPickerView;
}

- (BPTableViewHoverView *)hoverView {
    if (!_hoverView) {
        _hoverView = [[BPTableViewHoverView alloc] initWithFrame:CGRectMake(hBorderPadding, -(calendarAndColorPadding * 3 + calendarViewHeight + colorViewHeight), self.bp_width - 2 * vBorderPadding, (calendarAndColorPadding * 3 + calendarViewHeight + colorViewHeight)) andVerticalBorderWidth:2 * vBorderPadding];
        _hoverView.headerScrollView = self.mainTableView;
    }
    return _hoverView;
}

- (UIGestureRecognizer *)tapDateViewGesture {
    if (!_tapDateViewGesture) {
        _tapDateViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDateView)];
    }
    return _tapDateViewGesture;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, self.bp_height) style:UITableViewStyleGrouped];
        _mainTableView.sectionFooterHeight = CGFLOAT_MIN;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[BPDateAndProgressTableViewCell class] forCellReuseIdentifier:@"dateAndProgress"];
        [_mainTableView registerClass:[BPARInteractTableViewCell class] forCellReuseIdentifier:@"ar"];
        [_mainTableView registerClass:[BPMainPageTaskTableViewCell class] forCellReuseIdentifier:@"taskCell"];
    }
    return _mainTableView;
}

- (NSCalendar *)gregorian {
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}

- (NSMutableArray *)finishedTaskArr {
    if (!_finishedTaskArr) {
        _finishedTaskArr = [[NSMutableArray alloc] init];
    }
    return _finishedTaskArr;
}

- (NSMutableArray *)unfinishedTaskArr {
    if (!_unfinishedTaskArr) {
        _unfinishedTaskArr = [[NSMutableArray alloc] init];
    }
    return _unfinishedTaskArr;
}

@end
