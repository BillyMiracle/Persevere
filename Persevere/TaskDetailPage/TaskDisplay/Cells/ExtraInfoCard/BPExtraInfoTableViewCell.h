//
//  ExtraInfoTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/3/14.
//

#import "BPTaskDetailBaseTableViewCell.h"
#import "BPInfoTabView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BPExtraInfoTableViewCellDelegate <NSObject>

- (void)didSelectLink;
- (void)didSelectImage;
- (void)didSelectMemo;

@end

@interface BPExtraInfoTableViewCell : BPTaskDetailBaseTableViewCell

@property (nonatomic, weak) id<BPExtraInfoTableViewCellDelegate> delegate;

- (void)bindWithModel:(BPInfoTabViewModel *)model;

@end

NS_ASSUME_NONNULL_END
