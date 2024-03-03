//
//  BPTaskDisplayInfoCardView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import "BPTaskDisplayInfoCardView.h"
#import "BPInfoDisplayTableView.h"

@interface BPTaskDisplayInfoCardView()

@property (nonatomic, strong) BPInfoDisplayTableView *infoTableView;

@end

@implementation BPTaskDisplayInfoCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    
    
    return self;
}

- (void)bindTask:(TaskModel *)task {
    
}

- (void)setUILayout {
    
}

// MARK: Getters

- (BPInfoDisplayTableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[BPInfoDisplayTableView alloc] init];
    }
    return _infoTableView;
}


@end
