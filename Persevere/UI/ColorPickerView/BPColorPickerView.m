//
//  BPColorPickerView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import "BPColorPickerView.h"
#import "BPUIHelper.h"

@interface BPColorButton : UIButton
@property (nonatomic, assign) NSInteger buttonId;
@end
@implementation BPColorButton
@end

static const CGFloat vPadding = 5.0f;
static const CGFloat hPadding = 5.0f;
static const NSInteger colorButtonCount = 7;

@interface BPColorPickerView()
@property (nonatomic, strong) NSMutableArray <BPColorButton *>*buttonArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation BPColorPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andSelectedItem:0];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andSelectedItem:(NSInteger)selectedItem {
    if (self) {
        self = [super initWithFrame:frame];
        _selectedIndex = selectedItem;
        self.backgroundColor = [UIColor whiteColor];
        [self createWeekDayButtons];
        [self refreshWithFrame:frame];
    }
    return self;
}

- (void)createWeekDayButtons {
    for (int i = 1; i <= colorButtonCount; i++) {
        BPColorButton *btn = [self colorPickerButtonWithId:i];
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
    }
    
}

- (BPColorButton *)colorPickerButtonWithId:(NSInteger)btnId {
    BPColorButton *button = [BPColorButton buttonWithType:UIButtonTypeCustom];
    button.buttonId = btnId;
    [button setTintColor:[UIColor bp_colorPickerColorWithIndex:btnId]];
    UIImage *buttonImg = [UIImage imageNamed:@"CircleFill"];
    buttonImg = [buttonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImg forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)selectColor:(id)sender {
    [self generateImpact];
    BPColorButton *button = (BPColorButton *)sender;
    if (self.selectedIndex == button.buttonId) {
        self.selectedIndex = 0;
    } else {
        self.selectedIndex = button.buttonId;
    }
    [self.delegate didChangeColor:self.selectedIndex];
    [self refreshColorButtons];
    
}

- (void)refreshColorButtons {
    for (BPColorButton *button in self.buttonArray) {
        if (button.buttonId == self.selectedIndex) {
            UIImage *buttonImg = [UIImage imageNamed:@"CircleHalfFill"];
            buttonImg = [buttonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
            [button setBackgroundImage:buttonImg forState:UIControlStateHighlighted];
        } else {
            UIImage *buttonImg = [UIImage imageNamed:@"CircleFill"];
            buttonImg = [buttonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
            [button setBackgroundImage:buttonImg forState:UIControlStateHighlighted];
        }
    }
}

- (void)refreshViewsWithSelectedItem:(NSInteger)selectedItem {
    self.selectedIndex = selectedItem;
    [self refreshColorButtons];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshWithFrame:frame];
}

- (void)refreshWithFrame:(CGRect)frame {
    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    CGFloat btnWidth = MIN((viewWidth - (colorButtonCount + 1) * hPadding) / colorButtonCount , (viewHeight - 2 * vPadding));
    CGFloat newHPadding = (viewWidth - colorButtonCount * btnWidth) / (colorButtonCount + 1);
    CGFloat newVPadding = (viewHeight - btnWidth) / 2;
    for (BPColorButton *btn in self.buttonArray) {
        NSInteger i = btn.buttonId;
        [btn setFrame:CGRectMake(i * newHPadding + (i - 1) * btnWidth, newVPadding, btnWidth, btnWidth)];
    }
}

- (void)generateImpact {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
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
