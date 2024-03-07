//
//  BPProgressTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/8.
//

#import "BPProgressTableViewCell.h"
#import "BPProgressLabel.h"
#import "BPUIHelper.h"

@implementation BPProgressTableViewCellModel

- (instancetype)initWithPunchedDayCount:(NSInteger)punchedDayCount totalDayCount:(NSInteger)totalDayCount {
    self = [super init];
    if (self) {
        self.punchedDayCount = punchedDayCount;
        self.totalDayCount = totalDayCount;
    }
    return self;
}

@end

@interface BPProgressTableViewCell()

@property (nonatomic, strong) BPProgressLabel *progressLabel;

@end


@implementation BPProgressTableViewCell

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
    if (self) {
        [self.bp_backgroundView addSubview:self.progressLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressLabel.frame = CGRectMake(0, 0, self.bp_backgroundView.bp_width, self.bp_backgroundView.bp_height);
}

- (void)bindModel:(BPProgressTableViewCellModel *)model {
    [self.progressLabel setProgressWithFinished:model.punchedDayCount andTotal:model.totalDayCount];
}

// MARK: Getters

- (BPProgressLabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[BPProgressLabel alloc] init];
        _progressLabel.font = [UIFont bp_progressViewSmallFont];
        _progressLabel.textColor = [UIColor bp_defaultThemeColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor whiteColor];
        _progressLabel.layer.cornerRadius = 10.0f;
    }
    return _progressLabel;
}

@end
