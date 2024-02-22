//
//  BPProgressLabel.h
//  Persevere
//
//  Created by 张博添 on 2023/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPProgressLabel : UILabel

- (void)setProgressWithFinished:(NSUInteger)finished andTotal:(NSUInteger)total;

@end

NS_ASSUME_NONNULL_END
