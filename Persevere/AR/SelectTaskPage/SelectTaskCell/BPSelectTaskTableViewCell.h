//
//  BPSelectTaskTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BPSelectTableViewCellModel;

@interface BPSelectTaskTableViewCell : UITableViewCell

- (void)bindModel:(BPSelectTableViewCellModel *)model;

@end

NS_ASSUME_NONNULL_END
