//
//  BPTaskDetailViewController.m
//  Persevere
//
//  Created by 张博添 on 2023/11/4.
//

#import "BPTaskDetailViewController.h"
#import "BPTaskDetailView.h"
#import "BPNavigationTitleView.h"
#import "TaskModel.h"
#import "LocalTaskDataManager.h"

#import "BPUIHelper.h"

@interface BPTaskDetailViewController ()
<BPTaskDetailViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BPTaskDetailView *taskDetailPageView;
@property (nonatomic, strong) BPNavigationTitleView *detailTitleView;

/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;
/// 完成按钮
@property (nonatomic, strong) UIBarButtonItem *doneButton;


/// 无名称弹窗
@property (nonatomic, strong) UIAlertController *noNameAlert;
/// 无完成时间弹窗
@property (nonatomic, strong) UIAlertController *noWeekdayAlert;

@end

@implementation BPTaskDetailViewController
{
    /// 任务
    TaskModel *_task;
    /// 收否是添加
    BOOL _isAddMode;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (instancetype)initWithTask:(TaskModel *_Nullable)task {
    if (self = [super init]) {
        _task = task;
        if (task == nil) {
            _isAddMode = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.titleView = self.detailTitleView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.taskDetailPageView.dataSource = self;
    self.taskDetailPageView.parentViewController = self;
    [self.view addSubview:self.taskDetailPageView];
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressDoneButton {
    TaskModel *task = [self.taskDetailPageView getCurrentTaskInfo];
    if (task.name == nil || [task.name isEqualToString:@""]) {
        [self presentViewController:self.noNameAlert animated:YES completion:nil];
    } else if (!task.reminderDays || task.reminderDays.count == 0) {
        [self presentViewController:self.noWeekdayAlert animated:YES completion:nil];
    } else {
        NSLog(@"%@", task);
        if (self.isAddMode) {
            task.punchDateArray = [[NSMutableArray alloc] init];
            task.punchMemoArray = [[NSMutableArray alloc] init];
            [[LocalTaskDataManager shareInstance] addTask:task finished:^(BOOL succeeded) {
                if (succeeded) {// 添加成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
        } else {
            
        }
        
    }
}

// MARK: BPTaskDetailViewDataSource

@synthesize isAddMode = _isAddMode;
@synthesize task = _task;

- (TaskModel *)task {
    return _task;
}

- (BOOL)isAddMode {
    return _isAddMode;
}

// MARK: Getters

- (UIAlertController *)noNameAlert {
    if (!_noNameAlert) {
        _noNameAlert = [UIAlertController alertControllerWithTitle:@"任务名称不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];// style 为 sheet
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [_noNameAlert addAction:confirm];
    }
    return _noNameAlert;
}

- (UIAlertController *)noWeekdayAlert {
    if (!_noWeekdayAlert) {
        _noWeekdayAlert = [UIAlertController alertControllerWithTitle:@"请选择完成时间" message:nil preferredStyle:UIAlertControllerStyleAlert];// style 为 sheet
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [_noWeekdayAlert addAction:confirm];
    }
    return _noWeekdayAlert;
}

- (BPTaskDetailView *)taskDetailPageView {
    if (!_taskDetailPageView) {
        _taskDetailPageView = [[BPTaskDetailView alloc] initWithFrame:CGRectMake(0, [UIDevice bp_navigationFullHeight], self.bp_width, self.bp_height - [UIDevice bp_navigationFullHeight])];
    }
    return _taskDetailPageView;
}

- (BPNavigationTitleView *)detailTitleView {
    if (!_detailTitleView) {
        NSString *title;
        if (self.isAddMode) {
            title = @"新增任务";
        } else {
            title = @"任务详情";
        }
        _detailTitleView = [[BPNavigationTitleView alloc] initWithTitle:title andColor:nil andShouldShowType:NO];
    }
    return _detailTitleView;
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

@end
