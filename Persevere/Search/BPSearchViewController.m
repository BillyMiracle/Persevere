//
//  BPSearchViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import "BPSearchViewController.h"

@interface BPSearchViewController ()
<UIGestureRecognizerDelegate>

@end

@implementation BPSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
