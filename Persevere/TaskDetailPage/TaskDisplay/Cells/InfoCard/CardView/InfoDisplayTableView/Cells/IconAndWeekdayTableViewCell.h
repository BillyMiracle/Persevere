//
//  IconAndWeekdayTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/3/7.
//

#import <UIKit/UIKit.h>
#import "BPWeekDayPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IconAndWeekdayTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) BPWeekDayPickerView *weekdayPickerView;

@end

NS_ASSUME_NONNULL_END
