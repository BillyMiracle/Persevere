//
//  BPPublishTabBar.h
//  Persevere
//
//  Created by 张博添 on 2023/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BPPublishTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBar:(UITabBar *_Nonnull)tabBar didTappedPublishButton:(UIButton *_Nonnull)publish;

@end

@interface BPPublishTabBar : UITabBar

@property (nonatomic, weak) id<BPPublishTabBarDelegate> publishDelegate;

@end

NS_ASSUME_NONNULL_END
