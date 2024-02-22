//
//  UITextField+BPIndexPath.m
//  Persevere
//
//  Created by 张博添 on 2023/11/13.
//

#import <objc/runtime.h>

#import "UITextField+BPIndexPath.h"

@implementation UITextField (BPIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, @selector(indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, _cmd);
}

@end
