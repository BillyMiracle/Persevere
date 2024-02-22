//
//  BPTableViewHoverView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPTableViewHoverView : UIView

@property (nonatomic, nonnull) UIScrollView *headerScrollView;
@property (nonatomic, assign) BOOL isShow;

- (instancetype)initWithFrame:(CGRect)frame andVerticalBorderWidth:(CGFloat)borderWidth;

- (void)show;
- (void)hide;


@end

NS_ASSUME_NONNULL_END
