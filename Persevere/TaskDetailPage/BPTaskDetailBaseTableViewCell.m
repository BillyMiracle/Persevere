//
//  BPTaskDetailBaseTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/8.
//

#import "BPTaskDetailBaseTableViewCell.h"
#import "BPUIHelper.h"

static const  CGFloat backgroundHPadding = 10.0f;
static const  CGFloat backgroundVPadding = 6.0f;
static const  CGFloat backgroundCornerRadis = 10.0f;

@interface BPTaskDetailBaseTableViewCell()

@end

@implementation BPTaskDetailBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.bp_indexPath = nil;
    self.isBottomBorder = NO;
    self.isTopBorder = NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor bp_backgroundThemeColor];
//    self.bp_backgroundView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bp_backgroundView];
    [self.bp_backgroundView addSubview:self.bp_titleLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置圆角
    if (self.isTopBorder || self.isBottomBorder) {
        UIRectCorner corner = 0;
        if (self.isTopBorder && !self.isBottomBorder) {
            corner = UIRectCornerTopLeft | UIRectCornerTopRight;
            self.bp_backgroundView.frame = CGRectMake(backgroundHPadding, backgroundVPadding, self.bp_width - 2 * backgroundHPadding, self.bp_height - backgroundVPadding);
        } else if (self.isBottomBorder && !self.isTopBorder) {
            corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            self.bp_backgroundView.frame = CGRectMake(backgroundHPadding, 0, self.bp_width - 2 * backgroundHPadding, self.bp_height - backgroundVPadding);
        } else {
            corner = UIRectCornerAllCorners;
            self.bp_backgroundView.frame = CGRectMake(backgroundHPadding, backgroundVPadding, self.bp_width - 2 * backgroundHPadding, self.bp_height - backgroundVPadding * 2);
        }
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bp_backgroundView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(backgroundCornerRadis, backgroundCornerRadis)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bp_backgroundView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bp_backgroundView.layer.mask = maskLayer;
    } else {// 不设置圆角
        self.bp_backgroundView.frame = CGRectMake(backgroundHPadding, 0, self.bp_width - 2 * backgroundHPadding, self.bp_height);
    }
}

// MARK: Getters

- (UILabel *)bp_titleLabel {
    if (!_bp_titleLabel) {
        _bp_titleLabel = [[UILabel alloc] init];
        _bp_titleLabel.font = [UIFont bp_taskDetailTitleFont];
        _bp_titleLabel.textColor = [UIColor blackColor];
        _bp_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bp_titleLabel;
}

- (UIView *)bp_backgroundView {
    if (!_bp_backgroundView) {
        _bp_backgroundView = [[UIView alloc] init];
        _bp_backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bp_backgroundView;
}

@end
