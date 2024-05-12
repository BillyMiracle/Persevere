//
//  BPPasswordTextField.m
//  Persevere
//
//  Created by 张博添 on 2024/5/12.
//

#import "BPPasswordTextField.h"

@implementation BPPasswordTextField

// 密码输入框，不能够粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end
