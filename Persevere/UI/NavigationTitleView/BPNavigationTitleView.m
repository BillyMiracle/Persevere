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

@interface BPNavigationTitleView () {
    NSString *_title;
    UIColor *_color;
    BOOL _shouldShowType;
}

@property (nonatomic, assign) CGRect myFrame;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation BPNavigationTitleView

- (instancetype)init {
    if (self = [super init]) {
        _title = @"";
        [self changeColor:nil];
        [self setShouldShowType:NO];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andColor:(UIColor *)color andShouldShowType:(BOOL)shouldShowType {
    if (self = [super init]) {
        _title = title;
        _shouldShowType = shouldShowType;
        [self addSubview:self.stackView];
        [self changeColor:color];
        [self setShouldShowType:shouldShowType];
        self.frame = CGRectMake(([BPUIHelper mainScreenWidth] - self.stackView.bp_width) / 2,
                                0,
                                self.stackView.bp_width,
                                self.stackView.bp_height);
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)changeColor:(UIColor *)newColor {
    _color = newColor;
    if (_color == nil) {
        UIImage *img = [UIImage imageNamed:@"NavTypeNone"];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.typeImageView.tintColor = [UIColor whiteColor];
        self.typeImageView.image = img;
    } else {
        UIImage *img = [UIImage imageNamed:@"NavType"];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.typeImageView.tintColor = _color;
        self.typeImageView.image = img;
    }
}

/// 是否展示类型
- (void)setShouldShowType:(BOOL)shouldShowType {
    [self.stackView setUserInteractionEnabled:shouldShowType];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.stackView addGestureRecognizer:tapGesture];
    if (shouldShowType) {
        self.typeImageView.hidden = NO;
        self.stackView.frame = CGRectMake(0, 0, self.titleLabel.bp_width + typeViewWidth + typeViewPadding, [UIDevice bp_navigationBarHeight]);
    } else {
        self.typeImageView.hidden = YES;
        self.stackView.frame = CGRectMake(0, 0, self.titleLabel.bp_width, [UIDevice bp_navigationBarHeight]);
    }
}

- (void)tapAction:(id)sender {
    [self.navigationTitleDelegate navigationTitleViewTapped];
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
        [_titleLabel setText:_title];
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
