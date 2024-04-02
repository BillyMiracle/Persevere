//
//  BPSettingSwitchTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/4/3.
//

#import "BPSettingSwitchTableViewCell.h"
#import <Masonry.h>

@interface BPSettingSwitchTableViewCell()

@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation BPSettingSwitchTableViewCell

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
        [self.contentView addSubview:self.switchButton];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
    }];
}

- (void)setSwitchStatus:(BOOL)isOn {
    [self.switchButton setOn:isOn];
}

- (void)switchValueChanged:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(switchValueChanged:value:)]) {
        [self.delegate switchValueChanged:self value:sender.isOn];
    }
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}


@end
