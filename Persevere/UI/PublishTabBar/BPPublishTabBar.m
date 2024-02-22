//
//  BPPublishTabBar.m
//  Persevere
//
//  Created by 张博添 on 2023/11/3.
//

#import "BPPublishTabBar.h"
#import "BPUIHelper.h"

static const CGFloat publishButtonWidth = 50.0;

@interface BPPublishTabBar ()

@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation BPPublishTabBar

@dynamic delegate;

- (void)publishClick:(id)sender {
    if ([self.publishDelegate respondsToSelector:@selector(tabBar:didTappedPublishButton:)]) {
        [self.publishDelegate tabBar:self didTappedPublishButton:sender];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bp_width;
    // 添加发布按钮
    [self addSubview:self.publishButton];
    self.publishButton.center = CGPointMake(width * 0.5, 0);
    // 按钮索引
    int index = 0;
    // tabBar上按钮的尺寸
    CGFloat tabBarButtonW = (width - publishButtonWidth) / 2;
    CGFloat tabBarButtonH = [UIDevice bp_tabBarHeight];
    CGFloat tabBarButtonY = 0;
    // 设置TabBarButton的frame
    for (UIView *tabBarButton in self.subviews) {
        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) {
            continue;
        }
        // 计算按钮的X值
        CGFloat tabBarButtonX = index * tabBarButtonW;
        if (index == 1) { // 给下一个个button增加一个publushButton宽度的x值
            tabBarButtonX += publishButtonWidth;
        }
        // 设置按钮的frame
        tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);
        // 增加索引
        index++;
    }
}

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishButton.backgroundColor = [UIColor whiteColor];
        [_publishButton setImage:[UIImage imageNamed:@"TabAdd"] forState:UIControlStateNormal];
//        [_publishButton setImage:[UIImage imageNamed:@"TabAdd"] forState:UIControlStateHighlighted];
        _publishButton.layer.cornerRadius = publishButtonWidth / 2;
        [_publishButton addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
        _publishButton.bounds = CGRectMake(0, 0, publishButtonWidth, publishButtonWidth);
    }
    return _publishButton;
}

// 重写扩大响应范围
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
   if (self.isHidden == NO) {
       CGPoint newPoint = [self convertPoint:point toView:self.publishButton];
       if ([self.publishButton pointInside:newPoint withEvent:event]) {
           return self.publishButton;
       }
   }
    return [super hitTest:point withEvent:event];
}

@end
