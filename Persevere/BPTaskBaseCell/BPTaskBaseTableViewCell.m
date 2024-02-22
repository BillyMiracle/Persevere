//
//  BPTaskBaseTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2023/11/19.
//

#import "BPTaskBaseTableViewCell.h"
#import "BPUIHelper.h"

static const  CGFloat backgroundCornerRadis = 10.0f;
static const  CGFloat backgroundHPadding = 10.0f;
static const  CGFloat backgroundVPadding = 5.0f;

@interface BPTaskBaseTableViewCell()

@property (nonatomic, strong) MGSwipeButton *infoButton;
@property (nonatomic, strong) MGSwipeButton *deleteButton;
@property (nonatomic, strong) MGSwipeExpansionSettings *setting;


@end

@implementation BPTaskBaseTableViewCell

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
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bp_backgroundView];
    self.leftExpansion = self.setting;
    self.rightExpansion = self.setting;
    self.leftButtons = @[self.infoButton];
    self.rightButtons = @[self.deleteButton];
//    self.leftSwipeSettings.transition = MGSwipeTransitionStatic;
//    self.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bp_backgroundView.frame = CGRectMake(backgroundHPadding, backgroundVPadding, self.bp_width - 2 * backgroundHPadding, self.bp_height - 2 * backgroundVPadding);
}

- (UIView *)bp_backgroundView {
    if (!_bp_backgroundView) {
        _bp_backgroundView = [[UIView alloc] init];
        _bp_backgroundView.backgroundColor = [UIColor whiteColor];
        _bp_backgroundView.layer.cornerRadius = backgroundCornerRadis;
    }
    return _bp_backgroundView;
}

- (MGSwipeButton *)infoButton {
    if (!_infoButton) {
        _infoButton = [MGSwipeButton buttonWithTitle:@"" icon:[[UIImage imageNamed:@"CellInfo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] backgroundColor:[UIColor clearColor]];
        _infoButton.tintColor = [UIColor bp_defaultThemeColor];
    }
    return _infoButton;
}

- (MGSwipeButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [MGSwipeButton buttonWithTitle:@"" icon:[[UIImage imageNamed:@"CellDelete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] backgroundColor:[UIColor clearColor]];
        _deleteButton.tintColor = [UIColor redColor];
        
    }
    return _deleteButton;
}

- (MGSwipeExpansionSettings *)setting {
    if (!_setting) {
        _setting = [[MGSwipeExpansionSettings alloc] init];
        _setting.buttonIndex = 0;
        _setting.fillOnTrigger = YES;
        
//        _setting.threshold = 2.5;
        _setting.threshold = CGFLOAT_MAX;
    }
    return _setting;
}

@end
