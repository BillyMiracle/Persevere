//
//  BPInfoTabView.m
//  Persevere
//
//  Created by zhangbotian on 2024/3/14.
//

#import "BPInfoTabView.h"
#import "BPUIHelper.h"

static const CGFloat vPadding = 5.0f;
static const CGFloat hPadding = 5.0f;
static const NSInteger buttonCount = 3;

@implementation BPInfoTabViewModel

- (instancetype)initWithLink:(NSString * _Nullable)link image:(UIImage * _Nullable)image memo:(NSString * _Nullable)memo {
    self = [super init];
    if (self) {
        _link = link;
        _image = image;
        _memo = memo;
    }
    return self;
}

@end

@interface BPInfoTabView ()

@property (nonatomic, strong, nullable) BPInfoTabViewModel *model;

@property (nonatomic, strong) UIButton *linkButton;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *memoButton;

@property (nonatomic, strong) NSArray <UIButton *>*buttonArray;

@end

@implementation BPInfoTabView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame model:[BPInfoTabViewModel new]];
    return self;
}

- (instancetype)initWithModel:(BPInfoTabViewModel *)model {
    self = [self initWithFrame:CGRectZero model:model];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame model:(BPInfoTabViewModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.linkButton];
        [self addSubview:self.imageButton];
        [self addSubview:self.memoButton];
        [self refreshWithModel:model];
        [self refreshUI];
    }
    return self;
}

- (void)refreshWithModel:(BPInfoTabViewModel *)model {
    self.model = model;
    [self refreshButtonState];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshUI];
}

// MARK: 刷新布局

- (void)refreshUI {
    CGRect frame = self.frame;
    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    CGFloat btnWidth = MIN(MIN((viewWidth - (buttonCount + 1) * hPadding) / buttonCount , (viewHeight - 2 * vPadding)), 24);
    CGFloat newHPadding = (viewWidth - buttonCount * btnWidth) / (buttonCount + 1);
    CGFloat newVPadding = (viewHeight - btnWidth) / 2;
    for (int i = 1; i <= self.buttonArray.count; i++) {
        UIButton *btn = [self.buttonArray objectAtIndex:i - 1];
        [btn setFrame:CGRectMake(i * newHPadding + (i - 1) * btnWidth, newVPadding, btnWidth, btnWidth)];
    }
}

- (void)refreshButtonState {
    if (self.model.link && ![self.model.link isEqualToString:@""]) {
        self.linkButton.userInteractionEnabled = YES;
        [self.linkButton setTintColor:[UIColor bp_defaultThemeColor]];
    } else {
        self.linkButton.userInteractionEnabled = NO;
        [self.linkButton setTintColor:[UIColor lightGrayColor]];
    }
    if (self.model.image) {
        self.imageButton.userInteractionEnabled = YES;
        [self.imageButton setTintColor:[UIColor bp_defaultThemeColor]];
    } else {
        self.imageButton.userInteractionEnabled = NO;
        [self.imageButton setTintColor:[UIColor lightGrayColor]];
    }
    if (self.model.memo&& ![self.model.memo isEqualToString:@""]) {
        self.memoButton.userInteractionEnabled = YES;
        [self.memoButton setTintColor:[UIColor bp_defaultThemeColor]];
    } else {
        self.memoButton.userInteractionEnabled = NO;
        [self.memoButton setTintColor:[UIColor lightGrayColor]];
    }
}

// MARK: ButtonActions

- (void)didClickLinkButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectLink)]) {
        [self.delegate didSelectLink];
    }
}

- (void)didClickImageButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectImage)]) {
        [self.delegate didSelectImage];
    }
}

- (void)didClickMemoButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectMemo)]) {
        [self.delegate didSelectMemo];
    }
}

// MARK: Getters

- (UIButton *)linkButton {
    if (!_linkButton) {
        _linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _linkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _linkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [_linkButton setImage:[[UIImage imageNamed:@"InfoLink"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_linkButton setTintColor:[UIColor bp_defaultThemeColor]];
        [_linkButton addTarget:self action:@selector(didClickLinkButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkButton;
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [_imageButton setImage:[[UIImage imageNamed:@"InfoImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_imageButton setTintColor:[UIColor bp_defaultThemeColor]];
        [_imageButton addTarget:self action:@selector(didClickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageButton;
}

- (UIButton *)memoButton {
    if (!_memoButton) {
        _memoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _memoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _memoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [_memoButton setImage:[[UIImage imageNamed:@"InfoMemo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_memoButton setTintColor:[UIColor bp_defaultThemeColor]];
        [_memoButton addTarget:self action:@selector(didClickMemoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _memoButton;
}

- (NSArray <UIButton *>*)buttonArray {
    if (!_buttonArray) {
        _buttonArray = @[
            self.linkButton,
            self.imageButton,
            self.memoButton
        ];
    }
    return _buttonArray;
}

@end
