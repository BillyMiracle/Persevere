//
//  BPMainTabBarController.m
//  Persevere
//
//  Created by 张博添 on 2023/11/2.
//

#import "BPMainTabBarController.h"
#import "BPMainViewController.h"
#import "BPTaskListViewController.h"
#import "BPPublishTabBar.h"
#import "BPUIHelper.h"
#import "BPNavifationBarAppearance.h"
#import "BPTaskDetailViewController.h"
#import "IQKeyboardManager.h"

@interface BPMainTabBarController ()
<
BPPublishTabBarDelegate
>

@property (nonatomic, strong) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *taskNavigationController;

@property (nonatomic, strong) BPMainViewController *mainViewController;
@property (nonatomic, strong) BPTaskListViewController *taskListViewController;

@property (nonatomic, strong) BPPublishTabBar *publishTabBar;

@property (nonatomic, strong)  id<BPPublishTabBarDelegate> currViewController;

@end

@implementation BPMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setValue:self.publishTabBar forKey:@"tabBar"];
    self.delegate = self;
    self.publishTabBar.publishDelegate = self;
    self.viewControllers = @[self.mainNavigationController, self.taskNavigationController];
    
    // 使用智能键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldShowToolbarPlaceholder = YES;
    manager.toolbarTintColor = [UIColor bp_defaultThemeColor];
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
}

// MARK: BPPublishTabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didTappedPublishButton:(UIButton *)publish {
    BPTaskDetailViewController *taskViewController = [[BPTaskDetailViewController alloc] initWithTask:nil];
    taskViewController.hidesBottomBarWhenPushed = YES;
    [self.selectedViewController pushViewController:taskViewController animated:YES];
}

// MARK: getters

- (BPPublishTabBar *)publishTabBar {
    if (!_publishTabBar) {
        _publishTabBar = [[BPPublishTabBar alloc] init];
        _publishTabBar.tintColor = [UIColor bp_defaultThemeColor];
    }
    return _publishTabBar;
}

- (UINavigationController *)mainNavigationController {
    if (!_mainNavigationController) {
        _mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
        _mainNavigationController.title = @"今日";
        _mainNavigationController.tabBarItem.image = [UIImage imageNamed:@"TabToday"];
        _mainNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabTodaySelected"];
        _mainNavigationController.navigationBar.standardAppearance = [[BPNavifationBarAppearance alloc] init];
        _mainNavigationController.navigationBar.scrollEdgeAppearance = [[BPNavifationBarAppearance alloc] init];
        [_mainNavigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
    return _mainNavigationController;
}

- (UINavigationController *)taskNavigationController {
    if (!_taskNavigationController) {
        _taskNavigationController = [[UINavigationController alloc] initWithRootViewController:self.taskListViewController];
        _taskNavigationController.title = @"任务";
        _taskNavigationController.tabBarItem.image = [UIImage imageNamed:@"TabList"];
        _taskNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabListSelected"];
        _taskNavigationController.navigationBar.standardAppearance = [[BPNavifationBarAppearance alloc] init];
        _taskNavigationController.navigationBar.scrollEdgeAppearance = [[BPNavifationBarAppearance alloc] init];
        [_taskNavigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
    return _taskNavigationController;
}

- (BPMainViewController *)mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[BPMainViewController alloc] init];
    }
    return _mainViewController;
}

- (BPTaskListViewController *)taskListViewController {
    if (!_taskListViewController) {
        _taskListViewController = [[BPTaskListViewController alloc] init];
    }
    return _taskListViewController;
}

- (id<BPPublishTabBarDelegate>)currViewController {
    if (!_currViewController) {
        _currViewController = self.mainViewController;
    }
    return _currViewController;
}

@end
