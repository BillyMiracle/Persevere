//
//  BPProgressView.m
//  Persevere
//
//  Created by 张博添 on 2024/3/6.
//

#import "BPProgressView.h"
#import "BPUIHelper.h"

#define kDuration 0.5
#define kDefaultLineWidth 2
#define kDefaultFontSize 16

@interface BPProgressView()

/// 背景
@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
/// 进度
@property (nonatomic,strong) CAShapeLayer *progressLayer;
/// 进度 Label
@property (nonatomic,strong) UILabel *progressLabel;
///
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation BPProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self createSubViews];
        
        // 初始化值
        self.backgroundLineWidth = kDefaultLineWidth;
        self.progressLineWidth = kDefaultLineWidth;
        self.percentage = 0;
        self.offset = 0;
        self.sumSteps = 0;
        self.step = 0.1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self createSubViews];
        
        // 初始化值
        self.backgroundLineWidth = kDefaultLineWidth;
        self.progressLineWidth = kDefaultLineWidth;
        self.percentage = 0;
        self.offset = 0;
        self.sumSteps = 0;
        self.step = 0.1;
        
        [self refreshWithFrame:frame];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.progressLabel];
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.progressLayer];
}

- (void)setFontWithSize:(CGFloat)size {
    self.progressLabel.font = [UIFont fontWithName:@"Futura" size:size];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshWithFrame:frame];
}

- (void)refreshWithFrame:(CGRect)frame {
    self.progressLabel.frame = CGRectMake((self.bp_width -100) / 2, (self.bp_height - 100) / 2, 100, 100);
    [self setBackgroundCircleLine];
    [self setProgressCircleLine];
}

// MARK: 绘制

- (void)setBackgroundCircleLine {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.bp_left, self.center.y - self.bp_top)
                                                        radius:(self.bp_width - self.backgroundLineWidth) / 2 - self.offset
                                                    startAngle:0
                                                      endAngle:M_PI * 2
                                                     clockwise:YES];
    
    self.backgroundLayer.path = path.CGPath;
}

- (void)setProgressCircleLine {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.bp_left, self.center.y - self.bp_top)
                                          radius:(self.bp_width - self.progressLineWidth) / 2 - self.offset
                                      startAngle:-M_PI_2
                                        endAngle:-M_PI_2 + M_PI * 2
                                       clockwise:YES];
    self.progressLayer.path = path.CGPath;
}

// MARK: Getters

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont fontWithName:@"Futura" size:kDefaultFontSize];
        _progressLabel.text = @"0%";
    }
    return _progressLabel;
}

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    }
    return _backgroundLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor bp_defaultThemeColor].CGColor;
    }
    return _progressLayer;
}

// MARK: Setters

- (void)setDigitTintColor:(UIColor *)digitTintColor {
    _digitTintColor = digitTintColor;
    self.progressLabel.textColor = digitTintColor;
}

- (void)setBackgroundLineWidth:(CGFloat)backgroundLineWidth {
    _backgroundLineWidth = backgroundLineWidth;
    self.backgroundLayer.lineWidth = backgroundLineWidth;
    [self setBackgroundCircleLine];
}

- (void)setProgressLineWidth:(CGFloat)progressLineWidth {
    _progressLineWidth = progressLineWidth;
    self.progressLayer.lineWidth = progressLineWidth;
    [self setProgressCircleLine];
}

- (void)setPercentage:(CGFloat)percentage {
    _percentage = percentage;
    self.sumSteps = 0;
}

- (void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor {
    _backgroundStrokeColor = backgroundStrokeColor;
    self.backgroundLayer.strokeColor = backgroundStrokeColor.CGColor;
}

- (void)setProgressStrokeColor:(UIColor *)progressStrokeColor {
    _progressStrokeColor = progressStrokeColor;
    self.progressLayer.strokeColor = _progressStrokeColor.CGColor;
}

// MARK: 设置进度

- (void)setProgress:(CGFloat)percentage animated:(BOOL)animated {
    self.percentage = percentage;
    self.progressLayer.strokeEnd = self.percentage;
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:_percentage];
        animation.duration = kDuration;
        //start timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.step
                                                      target:self
                                                    selector:@selector(numberAnimation)
                                                    userInfo:nil
                                                     repeats:YES];
        
        
        [self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.percentage * 100];
        [CATransaction commit];
    }
}

- (void)numberAnimation {
    self.sumSteps += self.step;
    float sumSteps = (self.percentage / kDuration) * self.sumSteps;
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", sumSteps * 100];
    if (self.sumSteps >= kDuration) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
}
@end
