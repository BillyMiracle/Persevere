//
//  UIViewController+BPUIHelper.m
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import "UIViewController+BPUIHelper.h"

@implementation UIViewController (BPUIHelper)

- (CGFloat)bp_width {
    return self.view.frame.size.width;
}

- (CGFloat)bp_height {
    return self.view.frame.size.height;
}

@end
