//
//  BPInputTextTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPInputLongTextTableViewCell.h"
#import "BPUIHelper.h"

@interface BPInputLongTextTableViewCell ()

@end


@implementation BPInputLongTextTableViewCell

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
    [self.bp_backgroundView addSubview:self.inputTextView];
    return self;
}

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.font = [UIFont bp_taskDetailInfoFont];
        _inputTextView.scrollEnabled = NO;
        _inputTextView.textAlignment = NSTextAlignmentLeft;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _inputTextView.layer.cornerRadius = 5;
//        _inputTextView.
    }
    return _inputTextView;
}

- (void)doneButtonPressed {
    [self.inputTextView resignFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.bp_backgroundView.bp_height;
    CGFloat cellWidth = self.bp_backgroundView.bp_width;
    CGSize titleLabelSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (cellHeight - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    CGFloat inputTextViewHeight = self.bp_height - 2 * vPadding;
    self.inputTextView.frame = CGRectMake(self.bp_titleLabel.bp_right + hPadding, (cellHeight - inputTextViewHeight) / 2, cellWidth - self.bp_titleLabel.bp_right - 2 * hPadding, inputTextViewHeight);
}

@end
