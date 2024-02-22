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

@interface BPTaskListViewController ()
<BPNavigationTitleViewDelegate>
@property (nonatomic, strong) BPNavigationTitleView *taskNavigationTitleView;
@property (nonatomic, strong) BPTaskListView *taskListPageView;

@end

@implementation BPTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.taskNavigationTitleView;
    
    [self.view addSubview:self.taskListPageView];
}

// MARK: BPNavigationTitleViewDelegate
- (void)navigationTitleViewTapped {
    [self.taskListPageView navigationTitleViewTapped];
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
    }
    return _taskListPageView;
}

@end
