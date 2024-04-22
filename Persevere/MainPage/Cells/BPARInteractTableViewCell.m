//
//  BPARInteractTableViewCell.m
//  Persevere
//
//  Created by zhangbotian on 2024/4/18.
//

#import "BPARInteractTableViewCell.h"

#import <Masonry.h>

static const CGFloat padding = 10.0f;

@interface BPARInteractTableViewCell()

@property (nonatomic, strong) UIView *automaticallyAddTaskView;
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
    [self.contentView addSubview:self.automaticallyAddTaskView];
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
    [self.manuallyAddTaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.automaticallyAddTaskView);
        make.left.mas_equalTo(self.automaticallyAddTaskView.mas_right).offset(padding);
        make.right.mas_equalTo(self.contentView).offset(-padding);
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

- (UIView *)automaticallyAddTaskView {
    if (!_automaticallyAddTaskView) {
        _automaticallyAddTaskView = [[UIView alloc] init];
        _automaticallyAddTaskView.backgroundColor = [UIColor whiteColor];
        _automaticallyAddTaskView.layer.cornerRadius = 10.0;
    }
    return _automaticallyAddTaskView;
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
