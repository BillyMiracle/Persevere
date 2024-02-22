//
//  BPSelectImageTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPSelectImageTableViewCell.h"
#import "BPUIHelper.h"

static const CGFloat buttonVPadding = 16.0f;

@implementation BPSelectImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.deleteImageButton.hidden = YES;
    self.customImageButton.hidden = YES;
    self.imageSize = CGSizeZero;
    [self.selectImageButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.deleteImageButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self.bp_backgroundView addSubview:self.selectImageButton];
    [self.bp_backgroundView addSubview:self.deleteImageButton];
    [self.bp_backgroundView addSubview:self.customImageButton];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.bp_backgroundView.bp_height;
    CGFloat cellWidth = self.bp_backgroundView.bp_width;
    CGSize titleLabelSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (cellHeight - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    [self.selectImageButton sizeToFit];
//    self.selectImageButton.center = self.bp_titleLabel.center;
    self.selectImageButton.bp_top = buttonVPadding;
    self.selectImageButton.bp_left = self.bp_titleLabel.bp_right + hPadding;
    [self.deleteImageButton sizeToFit];
    self.deleteImageButton.bp_top = self.selectImageButton.bp_top;
    self.deleteImageButton.bp_left = self.selectImageButton.bp_right + hPadding;
    self.customImageButton.bp_left = self.selectImageButton.bp_left;
    CGFloat maxImageWidth = cellWidth - self.selectImageButton.bp_left - hPadding;
    CGFloat maxImageHeight = cellHeight - self.selectImageButton.bp_bottom - vPadding * 2;
    if (self.imageSize.width > 0 && self.imageSize.height > 0) {
        CGFloat R1 = self.imageSize.width / self.imageSize.height;
        CGFloat R2 = maxImageWidth / maxImageHeight;
        if (R1 <= R2) {
            self.customImageButton.bp_height = maxImageHeight;
            self.customImageButton.bp_width = maxImageHeight * R1;
            self.customImageButton.bp_top = self.selectImageButton.bp_bottom + vPadding;
        } else {
            self.customImageButton.bp_width = maxImageWidth;
            self.customImageButton.bp_height = maxImageWidth / R1;
            self.customImageButton.bp_top = self.selectImageButton.bp_bottom + vPadding + (maxImageHeight - maxImageWidth / R1) / 2;
        }
    } else {
        self.customImageButton.bp_height = maxImageHeight;
        self.customImageButton.bp_width = maxImageWidth;
        self.customImageButton.bp_top = self.selectImageButton.bp_bottom + vPadding;
    }
    
}

// MARK: Getters

- (UIButton *)selectImageButton {
    if (!_selectImageButton) {
        _selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectImageButton setTitleColor:[UIColor bp_defaultThemeColor] forState:UIControlStateNormal];
        [_selectImageButton.titleLabel setFont:[UIFont bp_taskDetailInfoFont]];
    }
    return _selectImageButton;
}

- (UIButton *)deleteImageButton {
    if (!_deleteImageButton) {
        _deleteImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteImageButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
        [_deleteImageButton.titleLabel setFont:[UIFont bp_taskDetailInfoFont]];
    }
    return _deleteImageButton;
}

- (UIButton *)customImageButton {
    if (!_customImageButton) {
        _customImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    return _customImageButton;
}

@end
