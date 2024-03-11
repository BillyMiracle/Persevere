//
//  BPTaskDetailTitleTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/12.
//

#import "BPTaskDetailTitleTableViewCell.h"
#import "BPUIHelper.h"

@implementation BPTaskDetailTitleTableViewCell

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
        [self.bp_backgroundView addSubview:self.bp_titleLabel];
    }
    return self;
}

// MARK: Getters

- (UILabel *)bp_titleLabel {
    if (!_bp_titleLabel) {
        _bp_titleLabel = [[UILabel alloc] init];
        _bp_titleLabel.font = [UIFont bp_taskDetailTitleFont];
        _bp_titleLabel.textColor = [UIColor blackColor];
        _bp_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bp_titleLabel;
}

@end
