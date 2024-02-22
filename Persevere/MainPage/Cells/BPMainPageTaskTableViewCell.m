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
    [self.bp_backgroundView addSubview:self.doneCheckBox];
    return self;
}

- (void)configureWithTask:(TaskModel *)task {
    self.bp_titleLabel.text = task.name;
}

- (void)setIsFinished:(BOOL)isFinished {
    [self.doneCheckBox setOn:isFinished];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize textSize = [self.bp_titleLabel.text textSizeWithFont:self.bp_titleLabel.font];
    self.bp_titleLabel.frame = CGRectMake(hPadding, (self.bp_backgroundView.bp_height - textSize.height) / 2, textSize.width, textSize.height);
    self.doneCheckBox.frame = CGRectMake(0, 0, checkBoxWidth, checkBoxWidth);
    self.doneCheckBox.center = CGPointMake(self.bp_backgroundView.bp_width - checkBoxWidth / 2 - hPadding, self.bp_backgroundView.bp_height / 2);
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
