//
//  BPTaskListPageTaskTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/4/10.
//

#import "BPTaskListPageTaskTableViewCell.h"
#import "BPProgressLabel.h"

@interface BPTaskListPageTaskTableViewCell()

@property (nonatomic, strong) UILabel *bp_titleLabel;
@property (nonatomic, strong) UIImageView *colorImageView;
@property (nonatomic, strong) BPProgressLabel *progressView;
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

@end
