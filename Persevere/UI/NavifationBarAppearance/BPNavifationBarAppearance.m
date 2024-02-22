//
//  BPNavifationBarAppearance.m
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import "BPNavifationBarAppearance.h"
#import "BPUIHelper.h"

@implementation BPNavifationBarAppearance

- (instancetype)init {
    self = [super init];
    self.backgroundColor = [UIColor bp_defaultThemeColor];
    self.shadowImage = [[UIImage alloc]init];
    self.shadowColor = nil;
    
    return self;
}

@end
