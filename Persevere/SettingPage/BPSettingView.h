//
//  BPSettingView.h
//  Persevere
//
//  Created by 张博添 on 2024/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPSettingViewDelegate <NSObject>

- (void)pushToPersonalPage;

@end

@interface BPSettingView : UIView

@property (nonatomic, weak) id<BPSettingViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *parentViewController;

- (void)reloadList;

@end

NS_ASSUME_NONNULL_END
