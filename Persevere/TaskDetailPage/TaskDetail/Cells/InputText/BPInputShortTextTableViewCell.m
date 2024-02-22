//
//  BPInputShortTextTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/9.
//

#import "BPInputShortTextTableViewCell.h"
#import "BPUIHelper.h"

@interface BPInputShortTextTableViewCell ()

@end

@implementation BPInputShortTextTableViewCell

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
    self.inputTextField.placeholder = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self.bp_backgroundView addSubview:self.inputTextField];
    return self;
}

- (void)doneButtonPressed {
    [self.inputTextField resignFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.bp_backgroundView.bp_height;
    CGFloat cellWidth = self.bp_backgroundView.bp_width;
    CGSize titleLabelSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (cellHeight - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    CGFloat inputTextFieldHeight = [UIFont bp_taskDetailInfoFont].lineHeight + 2 * vPadding;
    self.inputTextField.frame = CGRectMake(self.bp_titleLabel.bp_right + hPadding, (cellHeight - inputTextFieldHeight) / 2, cellWidth - self.bp_titleLabel.bp_right - 2 * hPadding, inputTextFieldHeight);
}

// MARK: Getters

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont bp_taskDetailInfoFont];
        _inputTextField.textAlignment = NSTextAlignmentLeft;
        _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}

@end
