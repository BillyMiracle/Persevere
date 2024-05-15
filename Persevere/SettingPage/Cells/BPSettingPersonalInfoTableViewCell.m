//
//  BPSettingPersonalInfoTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "BPSettingPersonalInfoTableViewCell.h"
#import "BPUIHelper.h"
#import "UserModel.h"
#import <Masonry.h>

@interface BPSettingPersonalInfoTableViewCell()

@property (nonatomic, strong) UILabel *bp_titleLabel;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation BPSettingPersonalInfoTableViewCell

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
    [self.contentView addSubview:self.bp_titleLabel];
    [self.contentView addSubview:self.headImageView];
    return self;
}

- (void)bindUser:(UserModel *)user {
    self.bp_titleLabel.text = user.nickName;
    self.headImageView.image = [UIImage imageWithData:user.imageData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.width.mas_equalTo(self.contentView.bp_height - 40);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.bp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

// MARK: Getters

- (UILabel *)bp_titleLabel {
    if (!_bp_titleLabel) {
        _bp_titleLabel = [[UILabel alloc] init];
        _bp_titleLabel.font = [UIFont bp_taskListFont];
        _bp_titleLabel.textColor = [UIColor blackColor];
        _bp_titleLabel.textAlignment = NSTextAlignmentCenter;
        _bp_titleLabel.numberOfLines = 1;
    }
    return _bp_titleLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

@end
