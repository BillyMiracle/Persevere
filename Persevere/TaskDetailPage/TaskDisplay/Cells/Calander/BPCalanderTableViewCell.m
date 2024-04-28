//
//  BPCalanderTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/10.
//

#import "BPCalanderTableViewCell.h"
#import "FSCalendar.h"
#import "TaskModel.h"
#import "DateTools.h"
#import "BPUIHelper.h"
#import "BPDateHelper.h"

@interface BPCalanderTableViewCell ()
<
FSCalendarDataSource,
FSCalendarDelegate,
FSCalendarDelegateAppearance
>
/// 日历
@property (nonnull, nonatomic) NSCalendar *gregorian;
/// 日历view
@property (nonatomic, strong) FSCalendar *fsCalendarView;
@property (nonatomic, strong) UIButton *previousMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;
/// 任务
@property (nonatomic, strong) TaskModel *task;

@end

@implementation BPCalanderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.fsCalendarView addSubview:self.previousMonthButton];
        [self.fsCalendarView addSubview:self.nextMonthButton];
        [self.bp_backgroundView addSubview:self.fsCalendarView];
    }
    return self;
}

- (void)bindTask:(TaskModel *)task {
    self.task = task;
    [self.fsCalendarView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.fsCalendarView.frame = CGRectMake(0, 0, self.bp_backgroundView.bp_width, self.bp_backgroundView.bp_height);
    self.previousMonthButton.frame = CGRectMake(0, 3, 100, 32);
    self.nextMonthButton.frame = CGRectMake(self.fsCalendarView.bp_width - 100, 3, 100, 32);
}

// MARK: 日历相关

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [calendar deselectDate:date];
    [calendar reloadData];
    if ([self.delegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.delegate didSelectDate:date];
    }
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return self.task.startDate;
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    if ([self.task.punchMemoArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]){
        return 1;
    }
    return 0;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(nonnull NSDate *)date {
    if (self.task != nil) {
        // 打了卡的日子
        if ([self.task.punchDateArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]] &&
            [date isLaterThanOrEqualTo:self.task.startDate]) {
            if (self.task.endDate != nil) {
                if ([self.task.endDate isLaterThanOrEqualTo:date]) {
                    return [UIColor bp_defaultThemeColor];
                }
            } else {
                return [UIColor bp_defaultThemeColor];
            }
        }
        
        // 跳过打卡的日子
        if ([self.task.punchSkipArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]] &&
            [date isLaterThanOrEqualTo:self.task.startDate]) {
            // 不是无限期
            if (self.task.endDate != nil) {
                if ([self.task.endDate isLaterThanOrEqualTo:date]) {
                    return [UIColor lightGrayColor];
                }
            } else {
                return [UIColor lightGrayColor];
            }
        }
    }
    return appearance.borderDefaultColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    if (self.task != NULL) {
        // 打了卡的日子
        // 跳过打卡的日子
        if (([self.task.punchDateArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]] &&
             [date isLaterThanOrEqualTo:self.task.startDate]) ||
            ([self.task.punchSkipArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]] &&
             [date isLaterThanOrEqualTo:self.task.startDate])) {
            // 不是无限期 && 比结束日期早
            if (self.task.endDate != nil && [self.task.endDate isLaterThanOrEqualTo:date]) {
                return [UIColor whiteColor];
            }
        }
    }
    return appearance.borderDefaultColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
    if (self.task != nil) {
        if ([date isEarlierThan:self.task.startDate]) {
            return [UIColor clearColor];
        }
        // 不是无限期 && 比结束日期晚
        if (self.task.endDate != nil && [date isLaterThan:self.task.endDate]) {
            return [UIColor clearColor];
        }
        if ([self.task.reminderDays containsObject:@(BPConvertToMondayBasedWeekday(date.weekday))]) {
            if ([self.task.punchDateArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
                // 打卡
                return [UIColor bp_defaultThemeColor];
            } else if ([self.task.punchSkipArray containsObject:[BPDateHelper transformDateToyyyyMMdd:date]]) {
                // 跳过
                return [UIColor lightGrayColor];
            } else if ([[NSDate date] isLaterThan:date]) {
                // 未打卡
                return [UIColor redColor];
            } else {
                return [UIColor bp_defaultThemeColor];
            }
        } else {
            // 不在打卡weekday范围
            return [UIColor clearColor];
        }
    }
    return appearance.borderDefaultColor;
}

/// 上一月
- (void)previousClicked:(id)sender {
    NSDate *currentMonth = self.fsCalendarView.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.fsCalendarView setCurrentPage:previousMonth animated:YES];
}

// 下一月
- (void)nextClicked:(id)sender {
    NSDate *currentMonth = self.fsCalendarView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.fsCalendarView setCurrentPage:nextMonth animated:YES];
}

// MARK: Getter

- (FSCalendar *)fsCalendarView {
    if (!_fsCalendarView) {
        _fsCalendarView = [[FSCalendar alloc] init];
        _fsCalendarView.dataSource = self;
        _fsCalendarView.delegate = self;
        _fsCalendarView.backgroundColor = [UIColor whiteColor];

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
        [_nextMonthButton setTintColor:[UIColor bp_defaultThemeColor]];
        UIImage *rightImg = [UIImage imageNamed:@"NextMonth"];
        rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_nextMonthButton setImage:rightImg forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextMonthButton;
}

- (NSCalendar *)gregorian {
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}

@end
