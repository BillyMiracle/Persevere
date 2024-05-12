//
//  BPRegisterViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/5/12.
//

#import "BPRegisterViewController.h"
#import "BPPasswordTextField.h"
#import "BPUIHelper.h"
#import "HXPhotoPicker.h"
#import <Masonry.h>
#import "BPRegisterViewModel.h"
#import "UserModel.h"
#import "BPMainTabBarController.h"

static const int NICKNAMEMAXLENGTH = 15;

static const NSString *passwordSetting = @"请设置登录密码";
static const NSString *headImageSetting = @"让大家更快记住你吧";
static const NSString *nicknameSetting = @"设置一个适合你的昵称吧";

@interface BPRegisterViewController ()
<UITextFieldDelegate, HXCustomNavigationControllerDelegate>

@property (assign, nonatomic, readonly) CGFloat textFieldHeight;
@property (assign, nonatomic, readonly) CGFloat largeTextFieldHeight;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *registerLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *passwordViewFirst;
@property (nonatomic, strong) BPPasswordTextField *passwordTextFieldFirst;
@property (nonatomic, strong) UIView *passwordViewConfirm;
@property (nonatomic, strong) BPPasswordTextField *passwordTextFieldConfirm;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *cautionLabel;
@property (nonatomic, strong) UILabel *cautionLabelSecond;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSData *imageData;

/// 相册页配置
@property (nonatomic, strong) HXPhotoManager *hxPhotoManager;
/// 相册页
@property (nonatomic, strong) HXCustomNavigationController *hxPhotoNavigationController;

@property (nonatomic, strong) BPRegisterViewModel *viewModel;

@end

@implementation BPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    self.titleLabel.text = [passwordSetting copy];
}

// MARK: 构建UI

- (void)buildUI {
    [self.view addSubview:self.registerLabel];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.passwordViewFirst];
    
    [self.view addSubview:self.passwordViewFirst];
    self.passwordViewFirst.frame = CGRectMake(self.textFieldHeight / 2, [UIDevice bp_statusBarHeight] + 110, self.bp_width - self.textFieldHeight, self.textFieldHeight);
    [self.passwordViewFirst addSubview:self.passwordTextFieldFirst];
    self.passwordTextFieldFirst.frame = CGRectMake(self.textFieldHeight / 2, 0, self.bp_width - self.textFieldHeight * 2, self.textFieldHeight);
    
    [self.view addSubview:self.passwordViewConfirm];
    self.passwordViewConfirm.frame = CGRectMake(self.textFieldHeight / 2, [UIDevice bp_statusBarHeight] + 110 + self.textFieldHeight * 7 / 6, self.bp_width   - self.textFieldHeight, self.textFieldHeight);
    [self.passwordViewConfirm addSubview:self.passwordTextFieldConfirm];
    self.passwordTextFieldConfirm.frame = CGRectMake(self.textFieldHeight / 2, 0, self.bp_width - self.textFieldHeight * 2, self.textFieldHeight);
    
    [self.view addSubview:self.confirmButton];
    [self setConfirmButtonOff];
    
    [self.view addSubview:self.cautionLabel];
    [self.cautionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordViewConfirm.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.cautionLabel.hidden = YES;

    [self.view addSubview:self.cautionLabelSecond];
    [self.cautionLabelSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cautionLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.cautionLabelSecond.hidden = YES;

    [self.view addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(self.largeTextFieldHeight);
        make.left.mas_equalTo(self.largeTextFieldHeight / 2);
        make.right.mas_equalTo(-self.largeTextFieldHeight / 2);
    }];
    self.nameView.hidden = YES;

    [self.nameView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.largeTextFieldHeight / 2);
        make.right.mas_equalTo(-self.largeTextFieldHeight / 2);
        make.top.bottom.mas_equalTo(self.nameView);
    }];
    
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(200);
    }];
    self.headImageView.hidden = YES;
}

// MARK: 关闭确认按钮

- (void)setConfirmButtonOff {
    self.confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [self.confirmButton setTintColor:[UIColor darkGrayColor]];
    self.confirmButton.userInteractionEnabled = NO;
}

// MARK: 激活确认按钮

- (void)setConfirmButtonOn {
    self.confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [self.confirmButton setTintColor:[UIColor blackColor]];
    self.confirmButton.userInteractionEnabled = YES;
}

// MARK: 正在输入，限制输入

// 限制密码框输入长度与内容
// 限制昵称框输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    if (textField == self.passwordTextFieldFirst || textField == self.passwordTextFieldConfirm) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex];
            // 将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) {
                return NO; // 48 unichar for 0
            } else if (character > 57 && character < 65) {
                return NO;
            } else if (character > 90 && character < 97) {
                return NO;
            } else if (character > 122) {
                return NO;
            }
        }
        NSUInteger newlength = textField.text.length + string.length - range.length;
        return newlength <= 16;
    }
    return YES;
}

// MARK: 输入结束，控制提示Label
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == self.passwordTextFieldConfirm) {
        if ([self.passwordTextFieldConfirm.text isEqualToString:self.passwordTextFieldFirst.text] && ![self.passwordTextFieldFirst.text isEqualToString:@""]) {
            [self setConfirmButtonOn];
            self.cautionLabel.hidden = YES;
        } else {
            self.cautionLabel.hidden = NO;
            [self setConfirmButtonOff];
        }
    } else if (textField == self.passwordTextFieldFirst) {
        //控制长度
        if (self.passwordTextFieldFirst.text.length < 6 || self.passwordTextFieldFirst.text.length > 16) {
            self.cautionLabelSecond.hidden = NO;
            [self setConfirmButtonOff];
        } else {
            self.cautionLabelSecond.hidden = YES;
            [self setConfirmButtonOn];
        }
        if ([self.passwordTextFieldConfirm.text isEqualToString:_passwordTextFieldFirst.text] && ![self.passwordTextFieldFirst.text isEqualToString:@""]) {
            [self setConfirmButtonOn];
            self.cautionLabel.hidden = YES;
        } else {
            if (![self.passwordTextFieldConfirm.text isEqualToString:@""]) {
                self.cautionLabel.hidden = NO;
            }
            [self setConfirmButtonOff];
        }
    }
}

// MARK: 监听函数，控制昵称框输入长度
//包括粘贴的长度也可以控制
- (void)limit:(UITextField *)textField {
    if (textField == self.nameTextField) {
        if ([textField markedTextRange]) {
            //有选中区域比如打拼音时，只限制最终的字数，不限制拼音长度
        } else if (textField.text.length > NICKNAMEMAXLENGTH) {
            textField.text = [textField.text substringToIndex:NICKNAMEMAXLENGTH];
        } else if (textField.text.length >= 1) {
            //长度大于一可以点确定
            [self setConfirmButtonOn];
        } else if (textField.text.length == 0) {
            //长度为0不可以点确定
            [self setConfirmButtonOff];
        }
    }
}

// MARK: 点击确认按钮

- (void)pressConfirm {
    if ([self.titleLabel.text isEqualToString:[passwordSetting copy]]) {
        self.password = [self.passwordTextFieldFirst.text copy];
        [self setNickname];
    } else if ([self.titleLabel.text isEqualToString:[nicknameSetting copy]]) {
        self.nickName = [self.nameTextField.text copy];
        [self setHeadImage];
    } else if ([self.titleLabel.text isEqualToString:[headImageSetting copy]]) {
        [self setConfirmButtonOff];
        UserModel *user = [[UserModel alloc] init];
        user.phoneNumber = self.phoneNumber;
        user.passWord = self.password;
        user.nickName = self.nickName;
        user.imageData = self.imageData;
        [self.viewModel registerWithUser:user finished:^(BOOL succeeded) {
            if (succeeded) {
                [self presentMainPage];
            }
        }];
    }
}

- (void)presentMainPage {
    BPMainTabBarController *main = [[BPMainTabBarController alloc] init];
    main.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:main animated:YES completion:nil];
}

// MARK: 设置昵称

- (void)setNickname {
    self.registerLabel.text = @"初来乍到";
    self.titleLabel.text = [nicknameSetting copy];
    
    // 清除密码控件
    self.passwordViewFirst.hidden = YES;
    self.passwordViewConfirm.hidden = YES;
    
    // 设置确认按钮
    [self setConfirmButtonOff];
    
    self.nameView.hidden = NO;
}

// MARK: 设置头像

- (void)setHeadImage {
    self.nameView.hidden = YES;
    self.registerLabel.text = @"挑选头像";
    self.titleLabel.text = [headImageSetting copy];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    //设置确认按钮
    [self setConfirmButtonOff];
    self.headImageView.hidden = NO;
}

// MARK: 选取头像相关

- (void)singerTap:(UITapGestureRecognizer *)gesture {
    //UIAlertControllerStyleActionSheet弹窗在屏幕下面
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
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
        self.imageData = imageData;
        self.headImageView.image = image;
        [self setConfirmButtonOn];
    }
}

- (void)photoNavigationViewControllerDidCancel:(HXCustomNavigationController *)photoNavigationViewController {
    
}

// MARK: Getters

- (CGFloat)textFieldHeight {
    return self.view.bp_height / 14;
}

- (CGFloat)largeTextFieldHeight {
    return self.view.bp_height / 13;
}

- (UILabel *)registerLabel {
    if (!_registerLabel) {
        _registerLabel = [[UILabel alloc] init];
        _registerLabel.frame = CGRectMake(20, [UIDevice bp_statusBarHeight] + 15, self.bp_width - 40, 40);
        _registerLabel.font = [UIFont systemFontOfSize:27];
        _registerLabel.textAlignment = NSTextAlignmentCenter;
        _registerLabel.text = @"首次注册";
    }
    return _registerLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(20, [UIDevice bp_statusBarHeight] + 55, self.bp_width - 40, 40);
        _titleLabel.font = [UIFont systemFontOfSize:25];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)passwordViewFirst {
    if (!_passwordViewFirst) {
        _passwordViewFirst = [[UIView alloc] init];
        _passwordTextFieldFirst.frame = CGRectMake(self.textFieldHeight / 2, 0, self.bp_width - self.textFieldHeight * 2, self.textFieldHeight);
        _passwordViewFirst.layer.masksToBounds = YES;
        _passwordViewFirst.layer.cornerRadius = self.textFieldHeight / 2;
        _passwordViewFirst.layer.borderWidth = 1;
    }
    return _passwordViewFirst;
}

- (UITextField *)passwordTextFieldFirst {
    if (!_passwordTextFieldFirst) {
        _passwordTextFieldFirst = [[BPPasswordTextField alloc] init];
        _passwordTextFieldFirst.font = [UIFont systemFontOfSize:20];
        _passwordTextFieldFirst.placeholder = @"请设置密码";
        _passwordTextFieldFirst.delegate = self;
        _passwordTextFieldFirst.secureTextEntry = YES;
        _passwordTextFieldFirst.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _passwordTextFieldFirst;
}

- (UIView *)passwordViewConfirm {
    if (!_passwordViewConfirm) {
        _passwordViewConfirm = [[UIView alloc] init];
        _passwordViewConfirm.layer.masksToBounds = YES;
        _passwordViewConfirm.layer.cornerRadius = self.textFieldHeight / 2;
        _passwordViewConfirm.layer.borderWidth = 1;
    }
    return _passwordViewConfirm;
}

- (BPPasswordTextField *)passwordTextFieldConfirm {
    if (!_passwordTextFieldConfirm) {
        _passwordTextFieldConfirm = [[BPPasswordTextField alloc] init];
        _passwordTextFieldConfirm.font = [UIFont systemFontOfSize:20];
        _passwordTextFieldConfirm.placeholder = @"请确认密码";
        _passwordTextFieldConfirm.delegate = self;
        _passwordTextFieldConfirm.secureTextEntry = YES;
        _passwordTextFieldConfirm.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _passwordTextFieldConfirm;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _confirmButton.frame = CGRectMake(self.textFieldHeight / 2, self.bp_height * 14 / 15 - self.textFieldHeight, self.bp_width - self.textFieldHeight, self.textFieldHeight);
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton.layer setMasksToBounds:YES];
        _confirmButton.layer.cornerRadius = self.textFieldHeight / 2;
        _confirmButton.layer.borderWidth = 0;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];

    }
    return _confirmButton;
}

- (UILabel *)cautionLabel {
    if (!_cautionLabel) {
        _cautionLabel = [[UILabel alloc] init];
        _cautionLabel.text = @"请确认两次输入的密码一致";
        _cautionLabel.textColor = [UIColor systemRedColor];
        _cautionLabel.hidden = YES;
    }
    return _cautionLabel;
}

- (UILabel *)cautionLabelSecond {
    if (!_cautionLabelSecond) {
        _cautionLabelSecond = [[UILabel alloc] init];
        _cautionLabelSecond.text = @"密码长度应为6～16";
        _cautionLabelSecond.textColor = [UIColor systemRedColor];
        _cautionLabelSecond.hidden = YES;
    }
    return _cautionLabelSecond;
}

- (UIView *)nameView {
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        _nameView.layer.masksToBounds = YES;
        _nameView.layer.cornerRadius = self.largeTextFieldHeight / 2;
        _nameView.layer.borderWidth = 1;
    }
    return _nameView;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.font = [UIFont systemFontOfSize:21];
        _nameTextField.placeholder = @"请设置昵称";
        _nameTextField.delegate = self;
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        //清除按钮
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_nameTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextField;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor grayColor];
        _headImageView.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singerTap:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
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

- (BPRegisterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BPRegisterViewModel alloc] init];
    }
    return _viewModel;
}

@end
