//
//  BPColorPickerView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPColorPickerDelegate <NSObject>

- (void)didChangeColor:(NSInteger)selectedColorIndex;

@end

@interface BPColorPickerView : UIView

@property (nonatomic, weak) id<BPColorPickerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andSelectedItem:(NSInteger)selectedItem;
- (void)refreshViewsWithSelectedItem:(NSInteger)selectedItem;

@end

NS_ASSUME_NONNULL_END
