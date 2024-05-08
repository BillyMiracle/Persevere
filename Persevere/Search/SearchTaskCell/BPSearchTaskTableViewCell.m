//
//  BPSearchTaskTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/5/8.
//

#import "BPSearchTaskTableViewCell.h"
#import "BPUIHelper.h"
#import "TaskModel.h"
#import <Masonry.h>

static const CGFloat hPadding = 10.0f;
static const CGFloat vPadding = 5.0f;
static const CGFloat checkBoxWidth = 35.f;

@interface BPSearchTaskTableViewCell()

@property (nonatomic, strong) UILabel *bp_titleLabel;
@property (nonatomic, strong) UILabel *bp_memoLabel;
@property (nonatomic, strong) UIImageView *colorImageView;
@property (nonatomic, strong) UIImageView *taskImageView;

@end

@implementation BPSearchTaskTableViewCell

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
    [self.contentView addSubview:self.bp_titleLabel];
    [self.contentView addSubview:self.colorImageView];
    [self.contentView addSubview:self.bp_memoLabel];
    [self.contentView addSubview:self.taskImageView];
    return self;
}

- (void)bindTask:(TaskModel *)task {
    self.bp_titleLabel.text = task.name;
    UIColor *tintColor = [UIColor bp_colorPickerColorWithIndex:task.type];
    if (tintColor) {
        self.colorImageView.tintColor = tintColor;
        self.colorImageView.hidden = NO;
    }
    UIImage *image = [UIImage imageWithData:task.imageData];
    if (image) {
        [self.taskImageView setImage:image];
        self.taskImageView.hidden = NO;
    }
    if (task.memo && ![task.memo isEqualToString:@""]) {
        self.bp_memoLabel.text = task.memo;
        self.bp_memoLabel.hidden = NO;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.taskImageView.hidden = YES;
    self.colorImageView.hidden = YES;
    self.bp_memoLabel.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hPadding);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.colorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(10);
        make.left.mas_equalTo(self.bp_titleLabel.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self).offset(-50);
        make.centerY.mas_equalTo(self.bp_titleLabel.mas_centerY);
    }];
    
    [self.taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-hPadding);
        make.width.height.mas_equalTo(self.contentView.bp_height - 2 * vPadding);
        make.top.mas_equalTo(vPadding);
        make.bottom.mas_equalTo(-vPadding);
    }];
    
    [self.bp_memoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.colorImageView.mas_right).offset(hPadding);
        make.right.mas_lessThanOrEqualTo(self.taskImageView.mas_left).offset(-hPadding);
        make.centerY.mas_equalTo(self);
    }];
}

// MARK: Getters

- (UILabel *)bp_titleLabel {
    if (!_bp_titleLabel) {
        _bp_titleLabel = [[UILabel alloc] init];
        _bp_titleLabel.font = [UIFont bp_taskListFont];
        _bp_titleLabel.textColor = [UIColor blackColor];
        _bp_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bp_titleLabel;
}

- (UIImageView *)colorImageView {
    if (!_colorImageView) {
        _colorImageView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"NavType"];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _colorImageView.image = img;
    }
    return _colorImageView;
}

- (UILabel *)bp_memoLabel {
    if (!_bp_memoLabel) {
        _bp_memoLabel = [[UILabel alloc] init];
        _bp_memoLabel.font = [UIFont systemFontOfSize:15.0];;
        _bp_memoLabel.textColor = [UIColor grayColor];
        _bp_memoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bp_memoLabel;
}

- (UIImageView *)taskImageView {
    if (!_taskImageView) {
        _taskImageView = [[UIImageView alloc] init];
    }
    return _taskImageView;
}

@end
