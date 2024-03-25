//
//  BPTaskDisplayViewController.m
//  Persevere
//
//  Created by 张博添 on 2023/11/21.
//

#import "BPTaskDisplayViewController.h"
#import "BPTaskDisplayView.h"
#import "BPTaskDetailViewController.h"
#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"
#import "LocalTaskDataManager.h"
#import "Persevere-Swift.h"

@interface BPTaskDisplayViewController ()
<
BPTaskDisplayViewDataSource,
BPTaskDisplayViewDelegate,
UIGestureRecognizerDelegate
>
/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;
/// 编辑按钮
@property (nonatomic, strong) UIBarButtonItem *editButton;
/// view
@property (nonatomic, strong) BPTaskDisplayView *taskDisplayPageView;
/// 任务标题
@property (nonatomic, strong) BPNavigationTitleView *taskNameTitleView;

@end

@implementation BPTaskDisplayViewController
{
    /// 任务
    TaskModel *_task;
}

- (instancetype)initWithTask:(TaskModel *)task {
    if (self = [super init]) {
        _task = task;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self refreshNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.rightBarButtonItem = self.editButton;
    self.navigationItem.titleView = self.taskNameTitleView;
    
    [self.view addSubview:self.taskDisplayPageView];
}

- (void)refreshNavigationBarView {
    [self.taskNameTitleView refreshWithTitle:self.task.name andColor:[UIColor bp_colorPickerColorWithIndex:self.task.type] andShouldShowType:YES];
}

// MARK: delete task

- (void)deleteCurrentTask {
    [[LocalTaskDataManager shareInstance] deleteTask:self.task finished:^(BOOL succeeded) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

// MARK: interact with ar

- (void)currentTaskInteractWithAR {
    BPARImageRecognizeViewController *arViewController = [[BPARImageRecognizeViewController alloc] initWithTaskArray:@[self.task]];
    [self.navigationController pushViewController:arViewController animated:YES];
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressEditButton {
    BPTaskDetailViewController *detailViewController = [[BPTaskDetailViewController alloc] initWithTask:_task];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

// MARK: BPTaskDetailViewDataSource

@synthesize task = _task;

- (TaskModel *)task {
    return _task;
}


// MARK: Getters

- (BPTaskDisplayView *)taskDisplayPageView {
    if (!_taskDisplayPageView) {
        _taskDisplayPageView = [[BPTaskDisplayView alloc] initWithFrame:CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight])];
        _taskDisplayPageView.delegate = self;
        _taskDisplayPageView.dataSource = self;
        _taskDisplayPageView.parentViewController = self;
    }
    return _taskDisplayPageView;
}

- (BPNavigationTitleView *)taskNameTitleView {
    if (!_taskNameTitleView) {
        _taskNameTitleView = [[BPNavigationTitleView alloc] initWithTitle:self.task.name andColor:[UIColor bp_colorPickerColorWithIndex:self.task.type] andShouldShowType:YES];
    }
    return _taskNameTitleView;
}


- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(pressBackButton)];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

- (UIBarButtonItem *)editButton {
    if (!_editButton) {
        _editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavEdit"] style:UIBarButtonItemStylePlain target:self action:@selector(pressEditButton)];
        _editButton.tintColor = [UIColor whiteColor];
    }
    return _editButton;
}

@end
