//
//  BPSearchView.m
//  Persevere
//
//  Created by 张博添 on 2024/4/14.
//

#import "BPSearchView.h"
#import "BPUIHelper.h"
#import <Masonry.h>

@interface BPSearchView()

@property (nonatomic, strong) UIView *leftBlankView;
@property (nonatomic, strong) UIImageView *searchIcon;

@end

@implementation BPSearchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    self.placeholder = @"搜索任务";
    
    [self.leftBlankView addSubview:self.searchIcon];
    self.leftView = self.leftBlankView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.clipsToBounds = true;
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 10.0;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftBlankView.frame = CGRectMake(0, 0, self.bp_height, self.bp_height);
    self.searchIcon.frame = CGRectMake(10, 10, self.leftBlankView.bp_height - 20, self.leftBlankView.bp_height - 20);
}

// MARK: Getter

- (UIView *)leftBlankView {
    if (!_leftBlankView) {
        _leftBlankView = [[UIView alloc] init];
        _leftBlankView.backgroundColor = [UIColor clearColor];
    }
    return _leftBlankView;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavSearch"]];
    }
    return _searchIcon;
}

@end
