//
//  BPSettingSwitchTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2024/4/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPSettingSwitchTableViewCellDelegate <NSObject>

- (void)switchValueChanged:(UITableViewCell *)cell value:(BOOL)value;

@end

@interface BPSettingSwitchTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BPSettingSwitchTableViewCellDelegate> delegate;

- (void)setSwitchStatus:(BOOL)isOn;

@end



NS_ASSUME_NONNULL_END
