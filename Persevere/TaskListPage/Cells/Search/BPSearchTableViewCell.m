//
//  BPSearchTableViewCell.m
//  Persevere
//
//  Created by 张博添 on 2024/4/12.
//

#import "BPSearchTableViewCell.h"
#import "BPSearchView.h"
#import <Masonry.h>

@interface BPSearchTableViewCell()

@property (nonatomic, strong) BPSearchView *searchView;

@end

@implementation BPSearchTableViewCell

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
    
    [self.contentView addSubview:self.searchView];
    self.searchView.userInteractionEnabled = NO;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(10);
        make.bottom.right.mas_equalTo(self.contentView).offset(-10);
    }];
}

- (BPSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[BPSearchView alloc] init];
    }
    return _searchView;
}

@end
