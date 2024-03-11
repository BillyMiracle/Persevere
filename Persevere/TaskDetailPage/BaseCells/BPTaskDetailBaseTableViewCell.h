//
//  BPTaskDetailBaseTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/8.
//

#import <UIKit/UIKit.h>

static const CGFloat hPadding = 15.0f;
static const CGFloat vPadding = 10.0f;

NS_ASSUME_NONNULL_BEGIN

@interface BPTaskDetailBaseTableViewCell : UITableViewCell

@property (nonatomic, strong, nullable) NSIndexPath *bp_indexPath;

@property (nonatomic, strong) UIView *bp_backgroundView;
@property (nonatomic, assign) BOOL isTopBorder;
@property (nonatomic, assign) BOOL isBottomBorder;

@end

NS_ASSUME_NONNULL_END
