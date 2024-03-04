//
//  InconAndLabelTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/2.
//

#import "IconAndLabelTableViewCell.h"

#import "BPUIHelper.h"

static const CGFloat kborderWidth = 10.0f;

@implementation IconAndLabelTableViewCell

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
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.contentView.bp_height;
    CGFloat cellWidth = self.contentView.bp_width;
    
    if (cellHeight > kborderWidth * 2 && cellWidth >= cellHeight) {
        CGFloat iconViewLength = cellHeight - 2 * kborderWidth;
        self.iconView.frame = CGRectMake(kborderWidth, kborderWidth, iconViewLength, iconViewLength);
        CGFloat titleLabelHeight = self.titleLabel.font.lineHeight;
        self.titleLabel.frame = CGRectMake(self.iconView.bp_right + kborderWidth, (cellHeight - titleLabelHeight) / 2, cellWidth - 2 * kborderWidth, titleLabelHeight);
    } else {
        self.iconView.frame = CGRectZero;
        self.titleLabel.frame = CGRectZero;
    }
}

// MARK: Getters

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _titleLabel;
}

@end
