//
//  BPPersonalViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "BPPersonalViewController.h"
#import "BPUIHelper.h"
#import "BPNavigationTitleView.h"
#import "BPPersonalBaseTableViewCell.h"
#import "BPSettingSectionView.h"
#import "BPChangeNameViewController.h"
#import "BPChangePhoneNumberViewController.h"
#import "BPChangePasswordViewController.h"
#import "HXPhotoPicker.h"
#import "LocalUserDataManager.h"

static const CGFloat sectionHeaderViewHeight = 40.0f;

@interface BPPersonalViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
HXCustomNavigationControllerDelegate
>

@property (nonatomic, strong) BPNavigationTitleView *navigationTitleView;
/// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSArray *sectionHeaderTitleArray;

/// 相册页配置
@property (nonatomic, strong) HXPhotoManager *hxPhotoManager;
/// 相册页
@property (nonatomic, strong) HXCustomNavigationController *hxPhotoNavigationController;

@end

@implementation BPPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.titleView = self.navigationTitleView;
    
    self.view.backgroundColor = [UIColor bp_backgroundThemeColor];
    [self.view addSubview:self.settingTableView];
}

// MARK: Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return sectionHeaderViewHeight;
        default:
            return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return [self sectionHeaderViewWithTitle:self.sectionHeaderTitleArray[section]];
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        // 修改用户名
        [self pushToChangeNameViewController];
    } else if (section == 0 && row == 1) {
        // 更换头像
        [self selectNewHeadImage];
    } else if (section == 1 && row == 0) {
        // 更换手机号
        [self pushToChangePhoneViewController];
    } else if (section == 1 && row == 1) {
        // 修改密码
        [self pushToChangePasswordViewController];
    } else if (section == 1 && row == 2) {
        // 注销账号
        
    } else if (section == 2 && row == 0) {
        // 退出登录
        
    }
}

- (UIView *)sectionHeaderViewWithTitle:(NSString *)title {
    return [[BPSettingSectionView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderViewHeight) title:title];
}

// MARK: 返回cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        // 修改用户名
        BPPersonalBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"修改用户名"];
        return cell;
    } else if (section == 0 && row == 1) {
        // 更换头像
        BPPersonalBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"更换头像"];
        return cell;
    } else if (section == 1 && row == 0) {
        // 更换手机号
        BPPersonalBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"更换手机号"];
        return cell;
    } else if (section == 1 && row == 1) {
        // 修改密码
        BPPersonalBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"修改密码"];
        return cell;
    } else if (section == 1 && row == 2) {
        // 注销账号
        BPPersonalBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setText:@"注销账号"];
        return cell;
    } else if (section == 2 && row == 0) {
        // 退出登录
        BPPersonalBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.textLabel setText:@"退出登录"];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

// MARK: 界面跳转与处理

- (void)pushToChangeNameViewController {
    BPChangeNameViewController *viewController = [[BPChangeNameViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToChangePasswordViewController {
    BPChangePasswordViewController *viewController = [[BPChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToChangePhoneViewController {
    BPChangePhoneNumberViewController *viewController = [[BPChangePhoneNumberViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)selectNewHeadImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
    }];
    UIAlertAction *photosAlbumAction = [UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAlbumAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectImageFromAlbum {
    [self presentViewController:self.hxPhotoNavigationController animated:YES completion:nil];
}

- (void)selectImageFromCamera {
    
}

// 选择照片后

- (void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    if (photoList.count == 1) {
        UIImage *image = photoList.firstObject.previewPhoto;
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [[LocalUserDataManager sharedInstance] updateUserHeadImage:imageData finished:^(BOOL succeeded) {
            if (succeeded) {
                NSLog(@"更新成功");
            } else {
                NSLog(@"更新失败");
            }
        }];
    }
}

- (void)photoNavigationViewControllerDidCancel:(HXCustomNavigationController *)photoNavigationViewController {
    
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: Getters

- (UITableView *)settingTableView {
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, self.bp_height) style:UITableViewStyleGrouped];
        _settingTableView.sectionFooterHeight = 0;
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        
        [_settingTableView registerClass:[BPPersonalBaseTableViewCell class] forCellReuseIdentifier:@"base"];
    }
    return _settingTableView;
}

- (HXPhotoManager *)hxPhotoManager {
    if (!_hxPhotoManager) {
        _hxPhotoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _hxPhotoManager.configuration.singleSelected = YES;
        _hxPhotoManager.configuration.singleJumpEdit = YES;
        _hxPhotoManager.configuration.photoEditConfigur.onlyCliping = YES;
        _hxPhotoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_1x1;
        _hxPhotoManager.configuration.themeColor = [UIColor bp_defaultThemeColor];
        _hxPhotoManager.configuration.navBarBackgroudColor = [UIColor whiteColor];
    }
    return _hxPhotoManager;
}

- (HXCustomNavigationController *)hxPhotoNavigationController {
    if (!_hxPhotoNavigationController) {
        _hxPhotoNavigationController = [[HXCustomNavigationController alloc] initWithManager:self.hxPhotoManager delegate:self];
    }
    return _hxPhotoNavigationController;
}

- (NSArray *)sectionHeaderTitleArray {
    return @[
        @"个人信息",
        @"账号安全"
    ];
}

- (BPNavigationTitleView *)navigationTitleView {
    if (!_navigationTitleView) {
        _navigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:@"个人中心"];
    }
    return _navigationTitleView;
}

- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(pressBackButton)];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

@end
