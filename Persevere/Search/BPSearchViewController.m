//
//  BPSearchViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import "BPSearchViewController.h"
#import "BPUIHelper.h"
#import "BPNavigationTitleView.h"

@interface BPSearchViewController ()
<UIGestureRecognizerDelegate>

/// title 标题
@property (nonatomic, strong) BPNavigationTitleView *settingNavigationTitleView;
/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;

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
    [self setupUI];
}

// MARK: UI setups

- (void)setupUI {
    self.view.backgroundColor = [UIColor bp_backgroundThemeColor];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.titleView = self.settingNavigationTitleView;
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: Getters

- (BPNavigationTitleView *)settingNavigationTitleView {
    if (!_settingNavigationTitleView) {
        _settingNavigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:@"搜索任务"];
    }
    return _settingNavigationTitleView;
}

- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(pressBackButton)];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

@end
