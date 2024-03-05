//
//  BPInfoCardTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import "BPInfoCardTableViewCell.h"
#import "BPTaskDisplayInfoCardView.h"
#import "BPUIHelper.h"

@interface BPInfoCardTableViewCell()

@property (nonatomic, strong) BPTaskDisplayInfoCardView *infoCardView;

@end

@implementation BPInfoCardTableViewCell

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
        [self.bp_backgroundView addSubview:self.infoCardView];
    }
    return self;
}

// 绑定数据
- (void)bindTask:(TaskModel *)task {
    [self.infoCardView bindTask:task];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.infoCardView.frame = CGRectMake(0, 0, self.bp_backgroundView.bp_width, self.bp_backgroundView.bp_height);
}

// MARK: Getters

- (BPTaskDisplayInfoCardView *)infoCardView {
    if (!_infoCardView) {
        _infoCardView = [[BPTaskDisplayInfoCardView alloc] init];
    }
    return _infoCardView;
}

@end
