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

@interface BPMainViewController ()
<BPNavigationTitleViewDelegate,BPMainViewDelegate>
@property (nonatomic, strong) BPMainView *mainPageView;
@property (nonatomic, strong) BPNavigationTitleView *mainNavigationTitleView;

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


@end
