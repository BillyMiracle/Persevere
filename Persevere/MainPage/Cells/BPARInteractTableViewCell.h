//
//  BPARInteractTableViewCell.h
//  Persevere
//
//  Created by zhangbotian on 2024/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPARInteractTableViewCellDelegate <NSObject>

- (void)didSelectAutoAddTask;
- (void)didSelectManualAddTask;

@end

@interface BPARInteractTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BPARInteractTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
