//
//  BPSelectColorTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPTaskDetailTitleTableViewCell.h"
#import "BPColorPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPSelectColorTableViewCell : BPTaskDetailTitleTableViewCell

@property (nonatomic, strong) BPColorPickerView *colorPickerView;

@end

NS_ASSUME_NONNULL_END
