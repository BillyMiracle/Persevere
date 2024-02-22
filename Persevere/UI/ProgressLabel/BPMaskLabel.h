//
//  BPMaskLabel.h
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPMaskLabel : UILabel

- (void)refreshWithEdgeInset:(UIEdgeInsets)inset;
- (instancetype _Nonnull)initWithFrame:(CGRect)frame andEdgeInset:(UIEdgeInsets)inset;

@end

NS_ASSUME_NONNULL_END
