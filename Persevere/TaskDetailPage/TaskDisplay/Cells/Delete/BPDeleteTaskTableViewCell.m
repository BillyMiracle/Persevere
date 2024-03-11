//
//  BPDeleteTaskTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/11.
//

#import "BPDeleteTaskTableViewCell.h"
#import "BPUIHelper.h"

@implementation BPDeleteTaskTableViewCell

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
        self.bp_titleLabel.textAlignment = NSTextAlignmentCenter;
        self.bp_titleLabel.textColor = [UIColor systemRedColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bp_titleLabel sizeToFit];
    if (self.bp_titleLabel.bp_width <= self.bp_backgroundView.bp_width &&
        self.bp_titleLabel.bp_height <= self.bp_backgroundView.bp_height) {
        self.bp_titleLabel.center = CGPointMake(self.bp_backgroundView.bp_width / 2, self.bp_backgroundView.bp_height / 2);
    }
}

@end
