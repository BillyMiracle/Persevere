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
/// 是否取消上圆角，默认NO，展示圆角
@property (nonatomic, assign) BOOL hideTopCorners;
/// 是否取消下圆角，默认NO，展示圆角
@property (nonatomic, assign) BOOL hideBottomCorners;

@end

NS_ASSUME_NONNULL_END
