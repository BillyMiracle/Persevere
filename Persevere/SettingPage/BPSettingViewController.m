//
//  BPSettingViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/3/28.
//

#import "BPSettingViewController.h"
#import "BPSettingView.h"
#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"
#import "BPPersonalViewController.h"

@interface BPSettingViewController ()
<UIGestureRecognizerDelegate, BPSettingViewDelegate>

@property (nonatomic, strong) BPSettingView *settingView;
@property (nonatomic, strong) BPNavigationTitleView *settingNavigationTitleView;
/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

@implementation BPSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.settingView reloadList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.titleView = self.settingNavigationTitleView;
    
    [self.view addSubview:self.settingView];
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: BPSettingViewDelegate

- (void)pushToPersonalPage {
    BPPersonalViewController *personalViewController = [[BPPersonalViewController alloc] init];
    [self.navigationController pushViewController:personalViewController animated:YES];
}

// MARK: Getters

- (BPSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[BPSettingView alloc] initWithFrame:CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight])];
        _settingView.delegate = self;
    }
    return _settingView;
}

- (BPNavigationTitleView *)settingNavigationTitleView {
    if (!_settingNavigationTitleView) {
        _settingNavigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:@"设置"];
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
