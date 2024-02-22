//
//  BPDateAndProgressTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/18.
//

#import "BPDateAndProgressTableViewCell.h"
#import "BPUIHelper.h"

static const CGFloat hBorderPadding = 10.0f;
static const CGFloat vBorderPadding = 10.0f;

@implementation BPDateAndProgressTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.dateView];
    [self.contentView addSubview:self.progressLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.bp_height - vBorderPadding;
    self.dateView.frame = CGRectMake(hBorderPadding, vBorderPadding / 2, height, height);
    self.progressLabel.frame = CGRectMake(self.dateView.bp_right + hBorderPadding, vBorderPadding / 2, self.bp_width - self.dateView.bp_right - 2 * hBorderPadding, height);
}

- (BPDateView *)dateView {
    if (!_dateView) {
        _dateView = [[BPDateView alloc] init];
    }
    return _dateView;
}

- (BPProgressLabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[BPProgressLabel alloc] init];
        _progressLabel.font = [UIFont bp_progressViewFont];
        _progressLabel.textColor = [UIColor bp_defaultThemeColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor whiteColor];
        _progressLabel.layer.cornerRadius = 10.0f;
    }
    return _progressLabel;
}

@end
