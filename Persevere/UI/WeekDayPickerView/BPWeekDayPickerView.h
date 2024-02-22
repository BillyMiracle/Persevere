//
//  BPWeekDayPickerView.h
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPWeekdayPickerDelegate <NSObject>

- (void)didChangeWeekdays:(NSArray *_Nonnull)selectedWeekdays;

@end


@interface BPWeekDayPickerView : UIView

@property (nonatomic, weak) id<BPWeekdayPickerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andShowSelectAllButton:(BOOL)shouldShow;
- (instancetype)initWithFrame:(CGRect)frame andShowSelectAllButton:(BOOL)shouldShow andSelectedWeekDayArray:(NSArray *_Nonnull)selectedWeekdaysArray;
- (void)refreshViewsWithSelectedWeekDayArray:(NSArray *_Nonnull)selectedWeekdaysArray;
//- (void)refreshWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
