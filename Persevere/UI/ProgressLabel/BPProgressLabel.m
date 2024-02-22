//
//  BPProgressLabel.m
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import "BPProgressLabel.h"
#import "BPMaskLabel.h"
#import "BPUIHelper.h"

@interface BPProgressLabel()

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) BPMaskLabel *maskLabel;

@end

@implementation BPProgressLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskLabel];
    }
    return self;
}

- (void)setProgressWithFinished:(NSUInteger)finished andTotal:(NSUInteger)total {
    if (total == 0) {
        self.progress = 0.0;
//        [self setText:@"0 / 0"];
        [self setText:@"没有任务"];
        self.maskLabel.hidden = YES;
    } else {
        self.progress = (float)finished / (float)total;
        [self setText:[NSString stringWithFormat:@"%lu / %lu", (unsigned long)finished, (unsigned long)total]];
        self.maskLabel.hidden = NO;
    }
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.clipsToBounds = YES;
    
    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]];
    CGFloat maskWidth = CGRectGetWidth(self.frame) * self.progress;
    CGFloat startX = (CGRectGetWidth(self.frame) - size.width) / 2.0;
    
    self.maskLabel.frame = CGRectMake(0, 0, maskWidth, CGRectGetHeight(self.bounds));
    [self.maskLabel refreshWithEdgeInset:UIEdgeInsetsMake(0, startX, 0, 0)];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.maskLabel.text = text;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.maskLabel.font = font;
}

- (BPMaskLabel *)maskLabel {
    if (!_maskLabel) {
        _maskLabel = [[BPMaskLabel alloc] init];
        _maskLabel.backgroundColor = [UIColor bp_defaultThemeColor];
        _maskLabel.textColor = [UIColor whiteColor];
        _maskLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _maskLabel.textAlignment = NSTextAlignmentLeft;
        _maskLabel.layer.cornerRadius = 0.0;
        _maskLabel.clipsToBounds = YES;
    }
    return _maskLabel;
}

@end
