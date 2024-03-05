//
//  BPSectionHeaderView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/11.
//

#import "BPSectionHeaderView.h"
#import "BPUIHelper.h"

static const CGFloat hPadding = 15.0f;

@interface BPSectionHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BPSectionHeaderView

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
        _titleLabel.font = [UIFont bp_sectionHeaderTitleFont];
        _titleLabel.textColor = [UIColor bp_defaultThemeColor];
    }
    return _titleLabel;
}

@end
