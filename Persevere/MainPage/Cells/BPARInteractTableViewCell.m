//
//  BPARInteractTableViewCell.m
//  Persevere
//
//  Created by zhangbotian on 2024/4/18.
//

#import "BPARInteractTableViewCell.h"
#import "BPUIHelper.h"
#import <Masonry.h>

static const CGFloat padding = 10.0f;

@interface BPARInteractTableViewCell()

@property (nonatomic, strong) UILabel *automaticallyAddTaskLabel;
@property (nonatomic, strong) UIView *automaticallyAddTaskView;
@property (nonatomic, strong) UILabel *manuallyAddTaskLabel;
@property (nonatomic, strong) UIView *manuallyAddTaskView;

@end

@implementation BPARInteractTableViewCell

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
    [self.automaticallyAddTaskView addSubview:self.automaticallyAddTaskLabel];
    [self.contentView addSubview:self.automaticallyAddTaskView];
    [self.manuallyAddTaskView addSubview:self.manuallyAddTaskLabel];
    [self.contentView addSubview:self.manuallyAddTaskView];
    [self addTapGestures];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.automaticallyAddTaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding / 2);
        make.bottom.mas_equalTo(-padding / 2);
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(self.contentView.mas_centerX).offset(-padding / 2);
    }];
    [self.automaticallyAddTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.automaticallyAddTaskView);
    }];
    [self.manuallyAddTaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.automaticallyAddTaskView);
        make.left.mas_equalTo(self.automaticallyAddTaskView.mas_right).offset(padding);
        make.right.mas_equalTo(self.contentView).offset(-padding);
    }];
    [self.manuallyAddTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.manuallyAddTaskView);
    }];
}

- (void)addTapGestures {
    UITapGestureRecognizer *tapAutomaticallyAddTaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAutomaticallyAddTaskView)];
    [self.automaticallyAddTaskView addGestureRecognizer:tapAutomaticallyAddTaskView];
    UITapGestureRecognizer *tapManuallyAddTaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapManuallyAddTaskView)];
    [self.manuallyAddTaskView addGestureRecognizer:tapManuallyAddTaskView];
}

- (void)didTapAutomaticallyAddTaskView {
    if ([self.delegate respondsToSelector:@selector(didSelectAutoAddTask)]) {
        [self.delegate didSelectAutoAddTask];
    }
}

- (void)didTapManuallyAddTaskView {
    if ([self.delegate respondsToSelector:@selector(didSelectManualAddTask)]) {
        [self.delegate didSelectManualAddTask];
    }
}

// MARK: Getters

- (UILabel *)automaticallyAddTaskLabel {
    if (!_automaticallyAddTaskLabel) {
        _automaticallyAddTaskLabel = [[UILabel alloc] init];
        _automaticallyAddTaskLabel.font = [UIFont boldSystemFontOfSize:15];
        _automaticallyAddTaskLabel.textColor = [UIColor bp_defaultThemeColor];
        _automaticallyAddTaskLabel.text = @"AR自动识别添加任务";
    }
    return _automaticallyAddTaskLabel;
}

- (UIView *)automaticallyAddTaskView {
    if (!_automaticallyAddTaskView) {
        _automaticallyAddTaskView = [[UIView alloc] init];
        _automaticallyAddTaskView.backgroundColor = [UIColor whiteColor];
        _automaticallyAddTaskView.layer.cornerRadius = 10.0;
    }
    return _automaticallyAddTaskView;
}

- (UILabel *)manuallyAddTaskLabel {
    if (!_manuallyAddTaskLabel) {
        _manuallyAddTaskLabel = [[UILabel alloc] init];
        _manuallyAddTaskLabel.font = [UIFont boldSystemFontOfSize:15];
        _manuallyAddTaskLabel.textColor = [UIColor bp_defaultThemeColor];
        _manuallyAddTaskLabel.text = @"AR手动添加任务";
    }
    return _manuallyAddTaskLabel;
}

- (UIView *)manuallyAddTaskView {
    if (!_manuallyAddTaskView) {
        _manuallyAddTaskView = [[UIView alloc] init];
        _manuallyAddTaskView.backgroundColor = [UIColor whiteColor];
        _manuallyAddTaskView.layer.cornerRadius = 10.0;
    }
    return _manuallyAddTaskView;
}

@end
