//
//  BPTaskDisplayInfoCardView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/1.
//

#import "BPTaskDisplayInfoCardView.h"
#import "BPInfoDisplayTableView.h"
#import "BPProgressView.h"
#import "TaskModel.h"
#import "BPUIHelper.h"

static const CGFloat verticalPadding = 20.0f;
static const CGFloat horizontalPadding = 20.0f;

static const CGFloat progressViewLineWidth = 5.0f;

@interface BPTaskDisplayInfoCardView()

@property (nonatomic, strong) BPInfoDisplayTableView *infoTableView;
@property (nonatomic, strong) BPProgressView *progressView;

@end

@implementation BPTaskDisplayInfoCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addKeyValueObserving];
        [self addSubview:self.infoTableView];
        [self addSubview:self.progressView];
        [self setUILayout];
    }
    return self;
}

- (void)bindTask:(TaskModel *)task {
    [self.infoTableView reloadWithTask:task];
    [self.progressView setProgress:task.progress animated:NO];
}

- (void)setUILayout {
    CGFloat progressViewLength = MIN(self.bp_width * 0.4 - 2 * horizontalPadding, self.bp_height - 2 * verticalPadding);
    self.progressView.frame = CGRectMake(0, 0, progressViewLength, progressViewLength);
    self.progressView.center = CGPointMake(self.bp_width - progressViewLength / 2 - horizontalPadding, self.bp_height / 2);
    self.infoTableView.frame = CGRectMake(0, 0, self.progressView.bp_left - horizontalPadding, self.bp_height);
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

- (BPProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[BPProgressView alloc] init];
        [_progressView setProgress:0 animated:NO];
        _progressView.progressLineWidth = progressViewLineWidth;
        _progressView.backgroundLineWidth = progressViewLineWidth;
    }
    return _progressView;
}

@end
