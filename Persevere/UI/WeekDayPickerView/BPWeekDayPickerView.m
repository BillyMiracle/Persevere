//
//  BPWeekDayPickerView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import "BPWeekDayPickerView.h"
#import "BPUIHelper.h"
#import "BPDateHelper.h"

@interface BPWeekDayButton : UIButton
@property (nonatomic, assign) NSInteger weekDay;
@end
@implementation BPWeekDayButton
@end

static const CGFloat vPadding = 5.0f;
static const CGFloat hPadding = 5.0f;
static const NSInteger weekdayButtonCount = 7;

@interface BPWeekDayPickerView()

@property (nonatomic, strong) NSMutableArray <BPWeekDayButton *>*buttonArray;
@property (nonatomic, strong) NSMutableArray *selectedWeekdayArray;

@end

@implementation BPWeekDayPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andShowSelectAllButton:NO];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andShowSelectAllButton:(BOOL)shouldShow {
    self = [self initWithFrame:frame andShowSelectAllButton:shouldShow andSelectedWeekDayArray:[[NSMutableArray alloc] init]];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andShowSelectAllButton:(BOOL)shouldShow andSelectedWeekDayArray:(NSArray *)selectedWeekdaysArray {
//    CGFloat viewWidth = frame.size.width;
//    CGFloat btnWidth = 0, viewHeight = 0;
//    if (!shouldShow) {
//        btnWidth = (viewWidth - 8 * hPadding) / 7;
//        viewHeight = btnWidth + 2 * vPadding;
//    } else {
//
//    }
//    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, viewHeight)];
    self = [super initWithFrame:frame];
    _selectedWeekdayArray = [NSMutableArray arrayWithArray:selectedWeekdaysArray];
    self.backgroundColor = [UIColor whiteColor];
//    [self createWeekDayButtonsWithFrame:frame];
    [self createWeekDayButtons];
    [self refreshWeekdayButtons];
    [self refreshWithFrame:frame];
    return self;
}
- (void)createWeekDayButtons {
    for (int i = 0; i < 7; i++) {
        BPWeekDayButton *btn = [self weekDayButtonAtWeekDay:((i + 6) % 7 + 1)];
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
    }
    
}
/*
- (void)createWeekDayButtonsWithFrame:(CGRect)frame {
    CGFloat viewWidth = frame.size.width;
    CGFloat btnWidth = (viewWidth - 8 * hPadding) / 7;
    for (int i = 0; i < 7; i++) {
        BPWeekDayButton *btn = [self weekDayButtonAtWeekDay:((i + 6) % 7 + 1)];
        [self addSubview:btn];
        [btn setFrame:CGRectMake((1 + i) * hPadding + i * btnWidth, vPadding, btnWidth, btnWidth)];
        [self.buttonArray addObject:btn];
    }
}
*/
- (BPWeekDayButton *)weekDayButtonAtWeekDay:(NSInteger)weekDay {
    BPWeekDayButton *button = [BPWeekDayButton buttonWithType:UIButtonTypeCustom];
    button.weekDay = weekDay;
    [button setTitle:[BPDateHelper weekStringFromNumber:weekDay] forState:UIControlStateNormal];
    [button setTintColor:[UIColor bp_defaultThemeColor]];
    [button setTitleColor:[UIColor bp_defaultThemeColor] forState:UIControlStateNormal];
    UIImage *buttonImg = [UIImage imageNamed:@"CircleBorder"];
    buttonImg = [buttonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectWeekDay:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)selectWeekDay:(id)sender {
    [self generateImpact];
    BPWeekDayButton *button = (BPWeekDayButton *)sender;
    NSNumber *weekDay = [NSNumber numberWithInteger:button.weekDay];
    if ([self.selectedWeekdayArray containsObject:weekDay]) {
        [self.selectedWeekdayArray removeObject:weekDay];
    } else {
        [self.selectedWeekdayArray addObject:weekDay];
    }
    [self refreshWeekdayButtons];
    [self.delegate didChangeWeekdays:[self.selectedWeekdayArray copy]];
}

/// 刷新按钮状态
- (void)refreshWeekdayButtons {
    for (BPWeekDayButton *button in self.buttonArray) {
        NSNumber *weekDay = [NSNumber numberWithInteger:button.weekDay];
        if ([self.selectedWeekdayArray containsObject:weekDay]) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIImage *buttonImg = [UIImage imageNamed:@"CircleFill"];
            buttonImg = [buttonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor bp_defaultThemeColor] forState:UIControlStateNormal];
            UIImage *buttonImg = [UIImage imageNamed:@"CircleBorder"];
            buttonImg = [buttonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
        }
    }
}

- (void)refreshViewsWithSelectedWeekDayArray:(NSArray *_Nonnull)selectedWeekdaysArray {
    if (!self) {
        return;
    }
    self.selectedWeekdayArray = [NSMutableArray arrayWithArray:selectedWeekdaysArray];
    [self refreshWeekdayButtons];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    CGFloat btnWidth = MIN((viewWidth - (weekdayButtonCount + 1) * hPadding) / weekdayButtonCount , (viewHeight - 2 * vPadding));
    CGFloat newHPadding = (viewWidth - weekdayButtonCount * btnWidth) / (weekdayButtonCount + 1);
    CGFloat newVPadding = (viewHeight - btnWidth) / 2;
    for (BPWeekDayButton *btn in self.buttonArray) {
        NSInteger i = btn.weekDay % 7;
        [btn setFrame:CGRectMake((i + 1) * newHPadding + i * btnWidth, newVPadding, btnWidth, btnWidth)];
    }
}

- (void)refreshWithFrame:(CGRect)frame {
    self.frame = frame;
    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    CGFloat btnWidth = MIN((viewWidth - (weekdayButtonCount + 1) * hPadding) / weekdayButtonCount , (viewHeight - 2 * vPadding));
    CGFloat newHPadding = (viewWidth - weekdayButtonCount * btnWidth) / (weekdayButtonCount + 1);
    CGFloat newVPadding = (viewHeight - btnWidth) / 2;
    for (BPWeekDayButton *btn in self.buttonArray) {
        NSInteger i = btn.weekDay % 7;
        [btn setFrame:CGRectMake((i + 1) * newHPadding + i * btnWidth, newVPadding, btnWidth, btnWidth)];
    }
}

- (void)generateImpact {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
}

// MARK: Getters

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end

