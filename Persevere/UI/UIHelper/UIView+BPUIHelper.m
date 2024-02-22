//
//  UIView+BPUIHelper.m
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import "UIView+BPUIHelper.h"

@implementation UIView (BPUIHelper)

- (void)setBp_width:(CGFloat)bp_width {
    if (self) {
        self.frame = CGRectMake(self.bp_left, self.bp_top, bp_width, self.bp_height);
    }
}

- (CGFloat)bp_width {
    if (!self) {
        return 0.0;
    }
    return self.bounds.size.width;
}

- (void)setBp_height:(CGFloat)bp_height {
    if (self) {
        self.frame = CGRectMake(self.bp_left, self.bp_top, self.bp_width, bp_height);
    }
}


- (CGFloat)bp_height {
    if (!self) {
        return 0.0;
    }
    return self.bounds.size.height;
}

- (void)setBp_top:(CGFloat)bp_top {
    if (self) {
        self.frame = CGRectMake(self.bp_left, bp_top, self.bp_width, self.bp_height);
    }
}


- (CGFloat)bp_top {
    if (!self) {
        return 0.0;
    }
    return self.frame.origin.y;
}

- (void)setBp_bottom:(CGFloat)bp_bottom {
    if (self) {
        self.frame = CGRectMake(self.bp_left, self.bp_bottom - self.bp_height, self.bp_width, self.bp_height);
    }
}


- (CGFloat)bp_bottom {
    if (!self) {
        return 0.0;
    }
    return self.frame.origin.y + self.bp_height;
}


- (void)setBp_left:(CGFloat)bp_left {
    if (self) {
        self.frame = CGRectMake(bp_left, self.bp_top, self.bp_width, self.bp_height);
    }
}

- (CGFloat)bp_left {
    if (!self) {
        return 0.0;
    }
    return self.frame.origin.x;
}

- (void)setBp_right:(CGFloat)bp_right {
    if (self) {
        self.frame = CGRectMake(bp_right - self.bp_width, self.bp_top, self.bp_width, self.bp_height);
    }
}


- (CGFloat)bp_right {
    if (!self) {
        return 0.0;
    }
    return self.frame.origin.x + self.bp_width;
}

@end
