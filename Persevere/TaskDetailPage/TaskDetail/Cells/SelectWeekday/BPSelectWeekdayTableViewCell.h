//
//  BPSelectWeekdayTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPTaskDetailBaseTableViewCell.h"
#import "BPWeekDayPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPSelectWeekdayTableViewCell : BPTaskDetailBaseTableViewCell

@property (nonatomic, strong) BPWeekDayPickerView *weekdayPickerView;

@end

NS_ASSUME_NONNULL_END
