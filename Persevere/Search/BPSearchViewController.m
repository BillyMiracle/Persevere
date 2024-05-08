//
//  BPSearchViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import "BPSearchViewController.h"
#import "BPUIHelper.h"
#import "BPNavigationTitleView.h"
#import "BPSearchTaskTableViewCell.h"
#import "BPSearchViewModel.h"
#import "BPTaskDisplayViewController.h"

@interface BPSearchViewController ()
<UIGestureRecognizerDelegate, UISearchBarDelegate, BPSearchViewModelProtocol>

/// title 标题
@property (nonatomic, strong) BPNavigationTitleView *settingNavigationTitleView;
/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;
/// viewModel
@property (nonatomic, strong) BPSearchViewModel *viewModel;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *searchTaskTableView;

@end

@implementation BPSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.viewModel loadTasksFinished:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTaskTableView reloadData];
            });
        }
    }];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchTaskTableView];
    self.searchTaskTableView.frame = CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight]);
    self.searchTaskTableView.tableHeaderView = self.searchBar;
    self.searchBar.frame = CGRectMake(0, 0, self.bp_width, 50);
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // text did end editing
    [self.viewModel searchTasksWithText:searchBar.text finished:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTaskTableView reloadData];
            });
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // text did change
}

// MARK: BPSearchViewModelProtocol

- (void)didSelectTask:(TaskModel *)task {
    BPTaskDisplayViewController *displayViewController = [[BPTaskDisplayViewController alloc] initWithTask:task];
    displayViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:displayViewController animated:YES];
}

// MARK: BPNavigationTitleViewDelegate

- (void)navigationTitleViewTapped {
    [self.searchTaskTableView scrollsToTop];
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

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.tintColor = [UIColor bp_defaultThemeColor];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)searchTaskTableView {
    if (!_searchTaskTableView) {
        _searchTaskTableView = [[UITableView alloc] init];
        _searchTaskTableView.sectionFooterHeight = 0;
        _searchTaskTableView.sectionHeaderHeight = 0;
        _searchTaskTableView.delegate = self.viewModel;
        _searchTaskTableView.dataSource = self.viewModel;
        _searchTaskTableView.backgroundColor = [UIColor bp_backgroundThemeColor];
        [_searchTaskTableView registerClass:[BPSearchTaskTableViewCell class] forCellReuseIdentifier:@"task"];
    }
    return _searchTaskTableView;
}

- (BPSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BPSearchViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}


@end
