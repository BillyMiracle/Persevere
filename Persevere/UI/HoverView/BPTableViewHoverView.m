//
//  BPTableViewHoverView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/16.
//

#import "BPTableViewHoverView.h"
#import "BPUIHelper.h"

typedef NS_ENUM(NSUInteger, BPHoverHeaderState) {
    KPHoverHeaderStateIdle,         //闲置状态
    KPHoverHeaderStatePulling,      //松开就可以进行刷新的状态
    KPHoverHeaderStateRefreshing    //正在刷新中的状态
};

@interface BPTableViewHoverView ()

@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) NSUInteger headerState;
@property (nonatomic, assign) CGFloat lastOffsetY;

@end


@implementation BPTableViewHoverView

- (instancetype)initWithFrame:(CGRect)frame andVerticalBorderWidth:(CGFloat)borderWidth {
    self.borderWidth = borderWidth;
    return [self initWithFrame:CGRectMake(frame.origin.x,
                                          frame.origin.y - borderWidth,
                                          frame.size.width,
                                          frame.size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isShow = NO;
        self.backgroundColor = [UIColor bp_defaultThemeColor];
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        self.headerState = KPHoverHeaderStateIdle;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isShow) {
        [self show];
    }
}

- (void)show {
    self.isShow = YES;
    [self.headerScrollView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.headerScrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height + self.borderWidth, 0, 0, 0);
        self.frame = CGRectMake(self.frame.origin.x,
                                -self.frame.size.height - self.borderWidth / 2,
                                self.frame.size.width,
                                self.frame.size.height);
        // 设置结束contentOffset避免无法完全展示bug
        self.headerScrollView.contentOffset = CGPointMake(0, -self.frame.size.height - self.borderWidth);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.headerScrollView setUserInteractionEnabled:YES];
        }
    }];
}

- (void)hide {
    self.isShow = NO;
    [self.headerScrollView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [self.headerScrollView setContentOffset:CGPointZero];
        self.headerScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.frame = CGRectMake(self.bp_left,
                                - self.bp_height - self.borderWidth / 2,
                                self.bp_width,
                                self.bp_height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.headerScrollView setUserInteractionEnabled:YES];
        }
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(change[NSKeyValueChangeNewKey] != nil){
        NSValue *value = (NSValue *)change[NSKeyValueChangeNewKey];
        CGPoint point = value.CGPointValue;
        [self adjustStateWithContentOffset:point.y];
    }
}

- (void)adjustStateWithContentOffset:(CGFloat)offsety {
    self.lastOffsetY = offsety;
    //当前的偏移量
    CGFloat contentOffsetY = self.headerScrollView.contentOffset.y;
    
    //header 完全出现时的contentOffset.y
    CGFloat headerCompleteDisplayContentOffsetY = -(self.frame.size.height + self.borderWidth) / 4.0;
    if (self.headerScrollView.isDragging == YES) {//如果正在拖拽
        //如果当前状态是 KPHoverStateIdle(闲置状态或者叫正常状态) && header 已经全部显示
        if (self.headerState == KPHoverHeaderStateIdle && contentOffsetY < headerCompleteDisplayContentOffsetY) {
            //将状态设置为松开就可以进行刷新的状态
            _headerState = KPHoverHeaderStatePulling;
        } else if (self.headerState == KPHoverHeaderStatePulling && contentOffsetY > headerCompleteDisplayContentOffsetY) {
            //如果当前状态是 KPHoverStatePulling(松开就可以进行刷新的状态) && header只显示了一部分(用户往上滑动了)
            self.headerState = KPHoverHeaderStateIdle;
        } else if (self.headerState == KPHoverHeaderStateRefreshing && contentOffsetY > headerCompleteDisplayContentOffsetY * 4.0) {
            self.headerState = KPHoverHeaderStateIdle;
            [self hide];
        }
    } else {//如果松开了手
        if (self.headerState == KPHoverHeaderStatePulling) {//如果是下拉状态.让它进入刷新状态
            self.headerState = KPHoverHeaderStateRefreshing;
            [self show];
        }
    }
}

@end
