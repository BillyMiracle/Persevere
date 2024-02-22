//
//  BPSelectColorTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPSelectColorTableViewCell.h"
#import "BPUIHelper.h"

@implementation BPSelectColorTableViewCell

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
    [self.bp_backgroundView addSubview:self.colorPickerView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.bp_backgroundView.bp_height;
    CGFloat cellWidth = self.bp_backgroundView.bp_width;
    CGSize titleLabelSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (cellHeight - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    CGFloat colorPickerWidth = cellWidth - self.bp_titleLabel.bp_right - 2 * hPadding;
    CGFloat colorPickerHeight = colorPickerWidth / 7;
    self.colorPickerView.frame = CGRectMake(self.bp_titleLabel.bp_right + hPadding, (cellHeight - colorPickerHeight) / 2, colorPickerWidth, colorPickerHeight);
}

- (BPColorPickerView *)colorPickerView {
    if (!_colorPickerView) {
        _colorPickerView = [[BPColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andSelectedItem:0];
    }
    return _colorPickerView;
}

@end
