//
//  BPSelectDateTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPSelectDateOrTimeTableViewCell.h"
#import "BPUIHelper.h"

@implementation BPSelectDateOrTimeTableViewCell

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
    [self.bp_backgroundView addSubview:self.selecetDateButton];
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.selecetDateButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.bp_backgroundView.bp_height;
    CGFloat cellWidth = self.bp_backgroundView.bp_width;
    CGSize titleLabelSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (cellHeight - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    [self.selecetDateButton sizeToFit];
    self.selecetDateButton.center = self.bp_titleLabel.center;
    self.selecetDateButton.bp_left = self.bp_titleLabel.bp_right + hPadding;
}

// MARK: Getters

- (UIButton *)selecetDateButton {
    if (!_selecetDateButton) {
        _selecetDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selecetDateButton setTitleColor:[UIColor bp_defaultThemeColor] forState:UIControlStateNormal];
        [_selecetDateButton.titleLabel setFont:[UIFont bp_taskDetailInfoFont]];
    }
    return _selecetDateButton;
}

@end
