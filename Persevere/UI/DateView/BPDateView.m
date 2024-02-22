//
//  BPDateView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/18.
//

#import "BPDateView.h"
#import "BPDateHelper.h"
#import "DateTools.h"
#import "BPUIHelper.h"

@interface BPDateView()

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *dayLabel;

@end

@implementation BPDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.dayLabel];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0;
    }
    return self;
}

- (void)refreshWithDate:(NSDate *)date {
    [self.subTitleLabel setText:[BPDateHelper transformDateToMMWeekday:date]];
    [self.dayLabel setText:[NSString stringWithFormat:@"%ld", (long)date.day]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize subTitleLabelSize = [self.subTitleLabel.text textSizeWithFont:self.subTitleLabel.font];
    CGSize dayLabelSize = [self.dayLabel.text textSizeWithFont:self.dayLabel.font];
    CGFloat vPadding = ceil(self.bp_height - dayLabelSize.height - subTitleLabelSize.height) / 3;
    self.subTitleLabel.frame = CGRectMake((self.bp_width - subTitleLabelSize.width) / 2, vPadding, subTitleLabelSize.width, subTitleLabelSize.height);
    self.dayLabel.frame = CGRectMake((self.bp_width - dayLabelSize.width) / 2, vPadding + self.subTitleLabel.bp_bottom, dayLabelSize.width, dayLabelSize.height);
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setFont:[UIFont bp_timeViewSubTitleFont]];
        [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _subTitleLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        [_dayLabel setFont:[UIFont bp_timeViewDayTextFont]];
        [_dayLabel setTextColor:[UIColor bp_defaultThemeColor]];
        [_dayLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _dayLabel;
}

@end
