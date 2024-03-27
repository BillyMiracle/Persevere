//
//  MainPageViewController.m
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import "BPMainViewController.h"
#import "BPMainView.h"
#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"
#import "DateTools.h"
#import "BPTaskDisplayViewController.h"
#import "BPSettingViewController.h"

@interface BPMainViewController ()
<BPNavigationTitleViewDelegate,BPMainViewDelegate>
@property (nonatomic, strong) BPMainView *mainPageView;
@property (nonatomic, strong) BPNavigationTitleView *mainNavigationTitleView;
/// 排序按钮
@property (nonatomic, strong) UIBarButtonItem *sortButton;
/// 设置按钮
@property (nonatomic, strong) UIBarButtonItem *settingButton;

@end

@implementation BPMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainPageView refreshAndLoadTasksWithDate:[NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loadingN the view.
    
    self.navigationItem.titleView = self.mainNavigationTitleView;
    self.navigationItem.rightBarButtonItem= self.settingButton;
    
    [self.view addSubview:self.mainPageView];
    
//    [self.mainPageView refreshAndLoadTasksWithDate:[NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]]];
}

// MARK: BPMainViewDelegate

- (void)changeColor:(NSInteger)colorId {
    [self.mainNavigationTitleView changeColor:[UIColor bp_colorPickerColorWithIndex:colorId]];
}

- (void)displayTask:(TaskModel *)task {
    BPTaskDisplayViewController *displayViewController = [[BPTaskDisplayViewController alloc] initWithTask:task];
    displayViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:displayViewController animated:YES];
}

// MARK: BPNavigationTitleViewDelegate

- (void)navigationTitleViewTapped {
    [self.mainPageView navigationTitleViewTapped];
}

// MARK: Button Actions

- (void)pressSortButton {
    
}

- (void)pressSettingButton {
    BPSettingViewController *settingPage = [[BPSettingViewController alloc] init];
    settingPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingPage animated:YES];
}

// MARK: Getter

- (BPNavigationTitleView *)mainNavigationTitleView {
    if (!_mainNavigationTitleView) {
        _mainNavigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:NSLocalizedString(@"今日", nil) andColor:nil andShouldShowType:YES];
        _mainNavigationTitleView.navigationTitleDelegate = self;
    }
    return _mainNavigationTitleView;
}

- (BPMainView *)mainPageView {
    if (!_mainPageView) {
        _mainPageView = [[BPMainView alloc] initWithFrame:CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight] - [UIDevice bp_tabBarFullHeight])];
        _mainPageView.delegate = self;
        _mainPageView.parentViewController = self;
    }
    return _mainPageView;
}

- (UIBarButtonItem *)sortButton {
    if (!_sortButton) {
        _sortButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(pressSortButton)];
        _sortButton.tintColor = [UIColor whiteColor];
    }
    return _sortButton;
}

- (UIBarButtonItem *)settingButton {
    if (!_settingButton) {
        _settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavSetting"] style:UIBarButtonItemStylePlain target:self action:@selector(pressSettingButton)];
        _settingButton.tintColor = [UIColor whiteColor];
    }
    return _settingButton;
}

@end
