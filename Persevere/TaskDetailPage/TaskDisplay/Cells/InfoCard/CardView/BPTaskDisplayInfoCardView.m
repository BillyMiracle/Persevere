//
//  BPTaskDisplayInfoCardView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import "BPTaskDisplayInfoCardView.h"
#import "BPInfoDisplayTableView.h"
#import "BPUIHelper.h"

@interface BPTaskDisplayInfoCardView()

@property (nonatomic, strong) BPInfoDisplayTableView *infoTableView;

@end

@implementation BPTaskDisplayInfoCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self addKeyValueObserving];
    
    [self addSubview:self.infoTableView];
    [self setUILayout];
    
    
    return self;
}

- (void)bindTask:(TaskModel *)task {
    [self.infoTableView reloadWithTask:task];
}

- (void)setUILayout {
    self.infoTableView.frame = CGRectMake(0, 0, self.bp_width * 0.6, self.bp_height);
}

- (void)dealloc {
    [self removeKeyValueObserving];
}

// MARK: KVO

- (void)addKeyValueObserving {
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKeyValueObserving {
    [self removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self setUILayout];
    }
}

// MARK: Getters

- (BPInfoDisplayTableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[BPInfoDisplayTableView alloc] init];
    }
    return _infoTableView;
}


@end
