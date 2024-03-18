//
//  ExtraInfoTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/3/14.
//

#import "BPExtraInfoTableViewCell.h"
#import "BPUIHelper.h"

@interface BPExtraInfoTableViewCell()
<BPInfoTabViewDelegate>

@property (nonatomic, strong) BPInfoTabView *infoTabView;

@end

@implementation BPExtraInfoTableViewCell

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
        [self.bp_backgroundView addSubview:self.infoTabView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.infoTabView.frame = CGRectMake(0, 0, self.bp_backgroundView.bp_width, self.bp_backgroundView.bp_height);
}

- (void)bindWithModel:(BPInfoTabViewModel *)model {
    [self.infoTabView refreshWithModel:model];
}

// MARK: BPInfoTabViewDelegate

- (void)didSelectLink {
    
}

- (void)didSelectImage {
    
}

- (void)didSelectMemo {
    
}

// MARK: Getters

- (BPInfoTabView *)infoTabView {
    if (!_infoTabView) {
        _infoTabView = [[BPInfoTabView alloc] init];
        _infoTabView.delegate = self;
    }
    return _infoTabView;
}

@end
