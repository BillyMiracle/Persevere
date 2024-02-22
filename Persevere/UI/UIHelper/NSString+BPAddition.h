//
//  NSString+BPAddition.h
//  Persevere
//
//  Created by 张博添 on 2023/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BPAddition)

- (CGSize)textSizeWithFont:(UIFont*)font;

- (CGSize)textSizeWithFont:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
               lineSpacing:(CGFloat)lineSpacing
          constrainedWidth:(CGFloat)constrainedWidth
          isLimitedToLines:(BOOL *)isLimitedToLines;
@end

NS_ASSUME_NONNULL_END
