//
//  BPSelectTaskViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import "BPSelectTaskViewController.h"
#import "BPSelectTaskViewModel.h"
#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"
#import "Persevere-Swift.h"
#import "BPSelectTaskTableViewCell.h"

@interface BPSelectTaskViewController ()
<UISearchBarDelegate, BPNavigationTitleViewDelegate, BPSelectTaskViewModelDelegate>

@property (nonatomic, assign) BPARType type;

@property (nonatomic, strong) BPNavigationTitleView *navTiteView;
/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;
/// 完成按钮
@property (nonatomic, strong) UIBarButtonItem *doneButton;
/// viewModel
@property (nonatomic, strong) BPSelectTaskViewModel *selectTaskViewModel;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *selectTaskTableView;

@end

@implementation BPSelectTaskViewController

- (instancetype)initWithType:(BPARType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = BPARTypeAutomatically;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectTaskViewModel loadTasksFinished:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.selectTaskTableView reloadData];
            });
        }
    }];
}

- (void)setupUI {
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.titleView = self.navTiteView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.selectTaskTableView];
    self.selectTaskTableView.frame = CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight]);
    self.selectTaskTableView.tableHeaderView = self.searchBar;
    self.searchBar.frame = CGRectMake(0, 0, self.bp_width, 50);
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressDoneButton {
    if (self.selectTaskViewModel.selectedTasksArray.count == 0) {
        [self presentErrorAlert];
        return;
    }
    if (self.type == BPARTypeAutomatically) {
        BPARImageRecognizeViewController *imageRecognizeViewController = [[BPARImageRecognizeViewController alloc] initWithTaskArray:self.selectTaskViewModel.selectedTasksArray];
        [self.navigationController pushViewController:imageRecognizeViewController animated:YES];
    } else if (self.type == BPARTypeManually) {
        
    }
}

- (void)presentErrorAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择任务" message:@"选中任务不能为空" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.parentViewController presentViewController:alertController animated:YES completion:nil];
}

// MARK: BPSelectTaskViewModelDelegate

- (void)didSelectTaskAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectTaskTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (self.type == BPARTypeManually
        && self.selectTaskViewModel.selectedTasksArray.count == 1) {
        BPARShowTaskViewController *showTaskViewController = [[BPARShowTaskViewController alloc] initWithTaskArray:self.selectTaskViewModel.selectedTasksArray];
        [self.navigationController pushViewController:showTaskViewController animated:YES];
    }
}

// MARK: UISearchBarDelegate


// MARK: BPNavigationTitleViewDelegate

- (void)navigationTitleViewTapped {
    [self.selectTaskTableView scrollsToTop];
}

// MARK: Getters

- (BPNavigationTitleView *)navTiteView {
    if (!_navTiteView) {
        _navTiteView = [[BPNavigationTitleView alloc] initWithTitle:@"请选择任务" andColor:nil andShouldShowType:NO];
        _navTiteView.navigationTitleDelegate = self;
    }
    return _navTiteView;
}

- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(pressBackButton)];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavDone"] style:UIBarButtonItemStylePlain target:self action:@selector(pressDoneButton)];
        _doneButton.tintColor = [UIColor whiteColor];
    }
    return _doneButton;
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

- (UITableView *)selectTaskTableView {
    if (!_selectTaskTableView) {
        _selectTaskTableView = [[UITableView alloc] init];
        _selectTaskTableView.sectionFooterHeight = 0;
        _selectTaskTableView.sectionHeaderHeight = 0;
        _selectTaskTableView.delegate = self.selectTaskViewModel;
        _selectTaskTableView.dataSource = self.selectTaskViewModel;
        _selectTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectTaskTableView.backgroundColor = [UIColor bp_backgroundThemeColor];
        [_selectTaskTableView registerClass:[BPSelectTaskTableViewCell class] forCellReuseIdentifier:@"task"];
    }
    return _selectTaskTableView;
}

- (BPSelectTaskViewModel *)selectTaskViewModel {
    if (!_selectTaskViewModel) {
        _selectTaskViewModel = [[BPSelectTaskViewModel alloc] init];
        _selectTaskViewModel.delegate = self;
        _selectTaskViewModel.type = self.type;
    }
    return _selectTaskViewModel;
}

@end
