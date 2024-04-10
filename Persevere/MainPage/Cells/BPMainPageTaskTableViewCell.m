//
//  BPMainPageTaskTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/19.
//

#import "BPMainPageTaskTableViewCell.h"
#import "TaskModel.h"
#import "BPUIHelper.h"
#import "BEMCheckBox.h"
#import <Masonry.h>

static const CGFloat checkBoxWidth = 35.f;

@interface BPMainPageTaskTableViewCell()
<
BEMCheckBoxDelegate
>

@property (nonatomic, strong) UILabel *bp_titleLabel;
@property (nonatomic, strong) UIImageView *colorImageView;
@property (nonatomic, strong) BEMCheckBox *doneCheckBox;

@end

@implementation BPMainPageTaskTableViewCell

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
    [self.bp_backgroundView addSubview:self.colorImageView];
    [self.bp_backgroundView addSubview:self.doneCheckBox];
    return self;
}

- (void)bindTask:(TaskModel *)task {
    self.bp_titleLabel.text = task.name;
    UIColor *tintColor = [UIColor bp_colorPickerColorWithIndex:task.type];
    if (tintColor) {
        self.colorImageView.tintColor = tintColor;
        self.colorImageView.hidden = NO;
    } else {
        self.colorImageView.hidden = YES;
    }
}

- (void)setIsFinished:(BOOL)isFinished {
    [self.doneCheckBox setOn:isFinished];
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
        make.right.mas_lessThanOrEqualTo(self.doneCheckBox.mas_left).offset(-50);
        make.centerY.mas_equalTo(self.bp_titleLabel.mas_centerY);
    }];
    
    [self.doneCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-hPadding);
        make.width.height.mas_equalTo(checkBoxWidth);
        make.centerY.mas_equalTo(self);
    }];
}

// MARK: BEMCheckBoxDelegate

- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox {
    [self.checkDelegate checkTaskAtIndexPath:self.bp_indexPath];
}

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {

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

- (BEMCheckBox *)doneCheckBox {
    if (!_doneCheckBox) {
        _doneCheckBox = [[BEMCheckBox alloc] init];
        _doneCheckBox.delegate = self;
        _doneCheckBox.lineWidth = 2.5;
        [_doneCheckBox setOnAnimationType:BEMAnimationTypeFill];
        [_doneCheckBox setOffAnimationType:BEMAnimationTypeFill];
        
        [_doneCheckBox setOnTintColor:[UIColor bp_defaultThemeColor]];
        [_doneCheckBox setOnCheckColor:[UIColor bp_defaultThemeColor]];
        [_doneCheckBox setOnFillColor:[UIColor clearColor]];
    }
    return _doneCheckBox;
}

@end
