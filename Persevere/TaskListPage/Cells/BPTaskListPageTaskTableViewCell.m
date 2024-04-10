//
//  BPTaskListPageTaskTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/4/10.
//

#import "BPTaskListPageTaskTableViewCell.h"
#import "BPProgressView.h"
#import "TaskModel.h"
#import "BPUIHelper.h"
#import "BPWeekDayPickerView.h"
#import <Masonry.h>

@interface BPTaskListPageTaskTableViewCell()

@property (nonatomic, strong) UILabel *bp_titleLabel;
@property (nonatomic, strong) BPWeekDayPickerView *weekdayView;
@property (nonatomic, strong) UIImageView *colorImageView;
@property (nonatomic, strong) BPProgressView *progressView;
@property (nonatomic, strong) UIImageView *taskImageView;

@end

@implementation BPTaskListPageTaskTableViewCell

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
    [self.bp_backgroundView addSubview:self.bp_titleLabel];
    [self.bp_backgroundView addSubview:self.weekdayView];
    [self.bp_backgroundView addSubview:self.colorImageView];
    [self.bp_backgroundView addSubview:self.progressView];
    [self.bp_backgroundView addSubview:self.taskImageView];
    return self;
}

- (void)bindTask:(TaskModel *)task {
    self.bp_titleLabel.text = task.name;
    [self.progressView setProgress:task.progress animated:NO];
    UIImage *image = [UIImage imageWithData:task.imageData];
    if (image) {
        [self.taskImageView setImage:image];
        self.taskImageView.hidden = NO;
    } else {
        self.taskImageView.hidden = YES;
    }
    [self.weekdayView refreshViewsWithSelectedWeekDayArray:task.reminderDays];
    
    UIColor *tintColor = [UIColor bp_colorPickerColorWithIndex:task.type];
    if (tintColor) {
        self.colorImageView.tintColor = tintColor;
        self.colorImageView.hidden = NO;
    } else {
        self.colorImageView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hPadding);
        make.top.mas_equalTo(hPadding);
    }];
    
    [self.colorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(10);
        make.left.mas_equalTo(self.bp_titleLabel.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self.taskImageView.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.bp_titleLabel.mas_centerY);
    }];
    
    [self.weekdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hPadding);
        make.top.mas_equalTo(self.bp_titleLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(150);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.progressView.mas_left).offset(-hPadding);
        make.width.height.mas_equalTo(self.bp_backgroundView.bp_height - 2 * vPadding);
        make.top.mas_equalTo(vPadding);
        make.bottom.mas_equalTo(-vPadding);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-hPadding);
        make.width.height.mas_equalTo(self.bp_backgroundView.bp_height - 2 * vPadding);
        make.top.mas_equalTo(vPadding);
        make.bottom.mas_equalTo(-vPadding);
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

- (UIImageView *)colorImageView {
    if (!_colorImageView) {
        _colorImageView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"NavType"];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _colorImageView.image = img;
    }
    return _colorImageView;
}

- (BPWeekDayPickerView *)weekdayView {
    if (!_weekdayView) {
        _weekdayView = [[BPWeekDayPickerView alloc] init];
        _weekdayView.userInteractionEnabled = NO;
    }
    return _weekdayView;
}

- (UIImageView *)taskImageView {
    if (!_taskImageView) {
        _taskImageView = [[UIImageView alloc] init];
    }
    return _taskImageView;
}

- (BPProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[BPProgressView alloc] init];
    }
    return _progressView;
}

@end
