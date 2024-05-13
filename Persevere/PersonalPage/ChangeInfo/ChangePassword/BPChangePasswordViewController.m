//
//  BPChangePasswordViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "BPChangePasswordViewController.h"
#import "BPNavigationTitleView.h"

@interface BPChangePasswordViewController ()

@property (nonatomic, strong) BPNavigationTitleView *navigationTitleView;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

@implementation BPChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.titleView = self.navigationTitleView;

}


// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: Getters

- (BPNavigationTitleView *)navigationTitleView {
    if (!_navigationTitleView) {
        _navigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:@"修改个人信息"];
    }
    return _navigationTitleView;
}

- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(pressBackButton)];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

@end
