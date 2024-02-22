//
//  BPDateAndProgressTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/18.
//

#import <UIKit/UIKit.h>
#import "BPProgressLabel.h"
#import "BPDateView.h"

static const CGFloat timeAndProgressViewHeight = 80;

NS_ASSUME_NONNULL_BEGIN

@interface BPDateAndProgressTableViewCell : UITableViewCell

/// 日期view
@property (nonatomic, strong) BPDateView *dateView;
/// 进度label
@property (nonatomic, strong) BPProgressLabel *progressLabel;

@end

NS_ASSUME_NONNULL_END
