//
//  BPTaskDisplayViewController.m
//  Persevere
//
//  Created by 张博添 on 2023/11/21.
//

#import "BPTaskDisplayViewController.h"

@interface BPTaskDisplayViewController ()

@end

@implementation BPTaskDisplayViewController
{
    /// 任务
    TaskModel *_task;
    
}

- (instancetype)initWithTask:(TaskModel *)task {
    if (self = [super init]) {
        _task = task;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
