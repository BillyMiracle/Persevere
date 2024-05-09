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
#import "BPSelectTaskViewController.h"
#import "BPSearchViewController.h"
#import "TaskDataHelper.h"

@interface BPMainViewController ()
<BPNavigationTitleViewDelegate,BPMainViewDelegate>
@property (nonatomic, strong) BPMainView *mainPageView;
@property (nonatomic, strong) BPNavigationTitleView *mainNavigationTitleView;
/// 更多按钮
@property (nonatomic, strong) UIBarButtonItem *moreButton;
/// 设置按钮
@property (nonatomic, strong) UIBarButtonItem *settingButton;

@property (nonatomic, strong, nonnull) NSString *sortFactor;
@property (nonatomic, assign) BOOL isAscend;

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
    self.navigationItem.rightBarButtonItem = self.settingButton;
    self.navigationItem.leftBarButtonItem = self.moreButton;
    
    [self.view addSubview:self.mainPageView];
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

/// 跳转到AR
- (void)interactWithARwithType:(BPARType)type {
    BPSelectTaskViewController *selectViewController = [[BPSelectTaskViewController alloc] initWithType:type];
    selectViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectViewController animated:YES];
}

// MARK: BPNavigationTitleViewDelegate

- (void)navigationTitleViewTapped {
    [self.mainPageView navigationTitleViewTapped];
}

// MARK: Button Actions

- (void)pressMoreButton {
    [self presentMoreSheetAlert];
}

- (void)presentMoreSheetAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:@"搜索任务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushToSearchPage];
    }];
    [alert addAction:searchAction];
    UIAlertAction *sortAction = [UIAlertAction actionWithTitle:@"改变任务排序方式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentSortSheetAlert];
    }];
    [alert addAction:sortAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pushToSearchPage {
    BPSearchViewController *searchPage = [[BPSearchViewController alloc] init];
    searchPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchPage animated:YES];
}

- (void)presentSortSheetAlert {
    
    NSDictionary *sortDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"sort"];
    self.sortFactor = sortDict.allKeys[0];
    NSNumber *isAscend = sortDict.allValues[0];
    self.isAscend = isAscend.boolValue;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择排序方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSDictionary *dict = [TaskDataHelper getTaskSortArray];
    for (NSString *key in dict.allKeys) {
        NSMutableString *displayKey = key.mutableCopy;
        if ([self.sortFactor isEqualToString:dict[displayKey]]) {
            if (self.isAscend) {
                [displayKey appendString:@" ↑"];
            } else {
                [displayKey appendString:@" ↓"];
            }
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:displayKey style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self.sortFactor isEqualToString:dict[key]]) {
                // 反转
                self.isAscend = !self.isAscend;
            } else {
                self.sortFactor = dict[key];
                self.isAscend = true;
            }
            [[NSUserDefaults standardUserDefaults] setValue:@{
                self.sortFactor : @(self.isAscend)
            } forKey:@"sort"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 刷新列表
            [self.mainPageView sortTasksAndReloadTableView];
        }];
        [alert addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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

- (UIBarButtonItem *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavMore"] style:UIBarButtonItemStylePlain target:self action:@selector(pressMoreButton)];
        _moreButton.tintColor = [UIColor whiteColor];
    }
    return _moreButton;
}

- (UIBarButtonItem *)settingButton {
    if (!_settingButton) {
        _settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavSetting"] style:UIBarButtonItemStylePlain target:self action:@selector(pressSettingButton)];
        _settingButton.tintColor = [UIColor whiteColor];
    }
    return _settingButton;
}

@end
