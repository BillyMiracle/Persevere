//
//  BPSelectWeekdayTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPTaskDetailTitleTableViewCell.h"
#import "BPWeekDayPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPSelectWeekdayTableViewCell : BPTaskDetailTitleTableViewCell

@property (nonatomic, strong) BPWeekDayPickerView *weekdayPickerView;

@end

NS_ASSUME_NONNULL_END
