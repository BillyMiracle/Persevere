//
//  BPSelectTaskTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/4/22.
//

#import "BPSelectTaskTableViewCell.h"
#import "BPSelectTableViewCellModel.h"
#import "BPUIHelper.h"
#import "BEMCheckBox.h"
#import <Masonry.h>

static const CGFloat hPadding = 10.0f;
static const CGFloat vPadding = 5.0f;
static const CGFloat checkBoxWidth = 35.f;

@interface BPSelectTaskTableViewCell()

@property (nonatomic, strong) UILabel *bp_titleLabel;
@property (nonatomic, strong) UIImageView *colorImageView;
@property (nonatomic, strong) BEMCheckBox *doneCheckBox;

@end

@implementation BPSelectTaskTableViewCell

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
    [self.contentView addSubview:self.colorImageView];
    [self.contentView addSubview:self.doneCheckBox];
    return self;
}

- (void)bindModel:(BPSelectTableViewCellModel *)model {
    TaskModel *task = model.task;
    self.bp_titleLabel.text = task.name;
    UIColor *tintColor = [UIColor bp_colorPickerColorWithIndex:task.type];
    if (tintColor) {
        self.colorImageView.tintColor = tintColor;
        self.colorImageView.hidden = NO;
    } else {
        self.colorImageView.hidden = YES;
    }
    [self.doneCheckBox setOn:model.selected];
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
        _doneCheckBox.lineWidth = 2.5;
        [_doneCheckBox setOnAnimationType:BEMAnimationTypeFill];
        [_doneCheckBox setOffAnimationType:BEMAnimationTypeFill];
        
        _doneCheckBox.userInteractionEnabled = NO;
        
        [_doneCheckBox setOnTintColor:[UIColor bp_defaultThemeColor]];
        [_doneCheckBox setOnCheckColor:[UIColor bp_defaultThemeColor]];
        [_doneCheckBox setOnFillColor:[UIColor clearColor]];
    }
    return _doneCheckBox;
}

@end
