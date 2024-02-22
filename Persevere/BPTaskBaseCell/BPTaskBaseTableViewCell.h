//
//  BPTaskBaseTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/19.
//

#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat hPadding = 10.0f;
static const CGFloat vPadding = 5.0f;

@interface BPTaskBaseTableViewCell : MGSwipeTableCell

@property (nonatomic, strong, nullable) NSIndexPath *bp_indexPath;
@property (nonatomic, strong) UIView *bp_backgroundView;

@end

NS_ASSUME_NONNULL_END
