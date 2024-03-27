//
//  BPNavigationTitleView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/3.
//

#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"

static const CGFloat typeViewPadding = 5.0;
static const CGFloat typeViewWidth = 10.0;

@interface BPNavigationTitleView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL shouldShowType;

@property (nonatomic, assign) CGRect myFrame;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation BPNavigationTitleView

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        [self changeColor:nil];
        [self changeShouldShowType:NO];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andColor:(UIColor *)color andShouldShowType:(BOOL)shouldShowType {
    if (self = [super init]) {
        self.title = title;
        [self addSubview:self.stackView];
        [self changeColor:color];
        [self changeShouldShowType:shouldShowType];
    }
    return self;
}

- (void)refreshWithTitle:(NSString *)title andColor:(UIColor *)color andShouldShowType:(BOOL)shouldShowType {
    self.title = title;
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    [self changeColor:color];
    [self changeShouldShowType:shouldShowType];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(([BPUIHelper mainScreenWidth] - self.stackView.bp_width) / 2,
                            0,
                            self.stackView.bp_width,
                            self.stackView.bp_height);
    self.center = CGPointMake(self.superview.bp_width / 2, self.superview.bp_height / 2);
}

/// 改变颜色
- (void)changeColor:(UIColor *)newColor {
    self.color = newColor;
    NSString *imageName = @"NavTypeNone";
    UIColor *tintColor = [UIColor whiteColor];
    if (self.color != nil) {
        imageName = @"NavType";
        tintColor = self.color;
    }
    UIImage *img = [UIImage imageNamed:imageName];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.typeImageView.tintColor = tintColor;
    self.typeImageView.image = img;
}

/// 是否展示类型
- (void)changeShouldShowType:(BOOL)shouldShowType {
    self.shouldShowType = shouldShowType;
    [self.stackView setUserInteractionEnabled:shouldShowType];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.stackView addGestureRecognizer:tapGesture];
    CGFloat maxWidth = [BPUIHelper mainScreenWidth] / 2;
    // 计算出的宽度
    CGFloat calWidth = self.titleLabel.bp_width + typeViewWidth + typeViewPadding;
    if (shouldShowType) {
        self.typeImageView.hidden = NO;
    } else {
        self.typeImageView.hidden = YES;
        calWidth = self.titleLabel.bp_width;
    }
    calWidth = calWidth > maxWidth ? maxWidth : calWidth;
    self.stackView.frame = CGRectMake(0, 0, calWidth, [UIDevice bp_navigationBarHeight]);
}

- (void)tapAction:(id)sender {
    if ([self.navigationTitleDelegate respondsToSelector:@selector(navigationTitleViewTapped)]) {
        [self.navigationTitleDelegate navigationTitleViewTapped];
    }
}

//MARK: Getters

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.spacing = typeViewPadding;
        [_stackView addArrangedSubview:self.titleLabel];
        [_stackView addArrangedSubview:self.typeImageView];
    }
    return _stackView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, [UIDevice bp_navigationBarHeight])];
        [_titleLabel setFont:[UIFont bp_navigationTitleFont]];
        [_titleLabel setText:self.title];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, typeViewWidth, typeViewWidth)];
        _typeImageView.clipsToBounds = YES;
    }
    return _typeImageView;
}

@end
