//
//  IconAndWeekdayTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/7.
//

#import "IconAndWeekdayTableViewCell.h"

#import "BPUIHelper.h"

static const CGFloat kborderWidth = 10.0f;

@implementation IconAndWeekdayTableViewCell

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
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.weekdayPickerView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.contentView.bp_height;
    CGFloat cellWidth = self.contentView.bp_width;
    
    if (cellHeight > kborderWidth * 2 && cellWidth >= cellHeight) {
        CGFloat iconViewLength = MIN(16, (cellHeight - 2 * kborderWidth));
        self.iconView.frame = CGRectMake(kborderWidth, (cellHeight - iconViewLength) / 2, iconViewLength, iconViewLength);
        CGFloat weekdayPickerHeight = self.bp_height - kborderWidth;
        self.weekdayPickerView.frame = CGRectMake(self.iconView.bp_right + kborderWidth, (cellHeight - weekdayPickerHeight) / 2, cellWidth - 2 * kborderWidth - self.iconView.bp_right, weekdayPickerHeight);
    } else {
        self.iconView.frame = CGRectZero;
        self.weekdayPickerView.frame = CGRectZero;
    }
}

// MARK: Getters

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (BPWeekDayPickerView *)weekdayPickerView {
    if (!_weekdayPickerView) {
        _weekdayPickerView = [[BPWeekDayPickerView alloc] init];
    }
    return _weekdayPickerView;
}

@end
