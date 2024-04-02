//
//  BPSettingSectionView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/31.
//

#import "BPSettingSectionView.h"
#import "BPUIHelper.h"

static const CGFloat hPadding = 15.0f;

@interface BPSettingSectionView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BPSettingSectionView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel setText:title];
        [self.titleLabel sizeToFit];
        self.titleLabel.frame = CGRectMake(hPadding, (self.bp_height - self.titleLabel.bp_height) / 2, ceilf(self.titleLabel.bp_width), ceilf(self.titleLabel.bp_height));
    }
    return self;
}


// MARK: Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor bp_defaultThemeColor];
    }
    return _titleLabel;
}

@end
