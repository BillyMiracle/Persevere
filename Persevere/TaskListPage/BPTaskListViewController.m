//
//  BPTaskListPageViewController.m
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import "BPTaskListViewController.h"
#import "BPTaskListView.h"
#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"
#import "BPSettingViewController.h"
#import "DateTools.h"
#import "BPSearchViewController.h"
#import "BPTaskDisplayViewController.h"

@interface BPTaskListViewController ()
<BPNavigationTitleViewDelegate, BPTaskListViewDelegate>

@property (nonatomic, strong) BPNavigationTitleView *taskNavigationTitleView;
@property (nonatomic, strong) BPTaskListView *taskListPageView;
/// 设置按钮
@property (nonatomic, strong) UIBarButtonItem *settingButton;

@end

@implementation BPTaskListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.taskListPageView refreshAndLoadTasksWithDate:[NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.taskNavigationTitleView;
    self.navigationItem.rightBarButtonItem= self.settingButton;
    
    [self.view addSubview:self.taskListPageView];
}

// MARK: BPNavigationTitleViewDelegate
- (void)navigationTitleViewTapped {
    [self.taskListPageView navigationTitleViewTapped];
}

// MARK: Button Actions

- (void)pressSortButton {
    
}

- (void)pressSettingButton {
    BPSettingViewController *settingPage = [[BPSettingViewController alloc] init];
    settingPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingPage animated:YES];
}

// MARK: BPTaskListViewDelegate

- (void)pushToSearchPage {
    BPSearchViewController *searchPage = [[BPSearchViewController alloc] init];
    searchPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchPage animated:YES];
}

- (void)displayTask:(TaskModel *)task {
    BPTaskDisplayViewController *displayViewController = [[BPTaskDisplayViewController alloc] initWithTask:task];
    displayViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:displayViewController animated:YES];
}


// MARK: Getters

- (BPNavigationTitleView *)taskNavigationTitleView {
    if (!_taskNavigationTitleView) {
        _taskNavigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:NSLocalizedString(@"任务", nil) andColor:nil andShouldShowType:YES];
        _taskNavigationTitleView.navigationTitleDelegate = self;
    }
    return _taskNavigationTitleView;
}

- (BPTaskListView *)taskListPageView {
    if (!_taskListPageView) {
        _taskListPageView = [[BPTaskListView alloc] initWithFrame:CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight] - [UIDevice bp_tabBarFullHeight])];
        _taskListPageView.delegate = self;
    }
    return _taskListPageView;
}

- (UIBarButtonItem *)settingButton {
    if (!_settingButton) {
        _settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavSetting"] style:UIBarButtonItemStylePlain target:self action:@selector(pressSettingButton)];
        _settingButton.tintColor = [UIColor whiteColor];
    }
    return _settingButton;
}

@end
