//
//  BPMaskLabel.m
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import "BPMaskLabel.h"

@interface BPMaskLabel()

@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

@end

@implementation BPMaskLabel

- (instancetype)initWithFrame:(CGRect)frame andEdgeInset:(UIEdgeInsets)inset {
    self = [super initWithFrame:frame];
    if (self) {
        self.textEdgeInsets = inset;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}
- (void)refreshWithEdgeInset:(UIEdgeInsets)inset {
    self.textEdgeInsets = inset;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInsets)];
}
@end
