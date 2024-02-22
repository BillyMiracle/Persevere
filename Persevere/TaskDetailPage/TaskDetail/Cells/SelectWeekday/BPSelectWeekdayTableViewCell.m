//
//  BPSelectWeekdayTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPSelectWeekdayTableViewCell.h"
#import "BPUIHelper.h"

@implementation BPSelectWeekdayTableViewCell

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
    [self.bp_backgroundView addSubview:self.weekdayPickerView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.bp_backgroundView.bp_height;
    CGFloat cellWidth = self.bp_backgroundView.bp_width;
    CGSize titleLabelSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (cellHeight - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    CGFloat weekdayPickerWidth = cellWidth - self.bp_titleLabel.bp_right - 2 * hPadding;
    CGFloat weekdayPickerHeight = weekdayPickerWidth / 7;
    self.weekdayPickerView.frame = CGRectMake(self.bp_titleLabel.bp_right + hPadding, (cellHeight - weekdayPickerHeight) / 2, weekdayPickerWidth, weekdayPickerHeight);
}

// MARK: Getters
- (BPWeekDayPickerView *)weekdayPickerView {
    if (!_weekdayPickerView) {
        _weekdayPickerView = [[BPWeekDayPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andShowSelectAllButton:NO andSelectedWeekDayArray:[NSArray array]];
    }
    return _weekdayPickerView;
}

@end
