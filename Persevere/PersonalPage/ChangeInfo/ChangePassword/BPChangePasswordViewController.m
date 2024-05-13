//
//  BPChangePasswordViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "BPChangePasswordViewController.h"
#import "BPNavigationTitleView.h"
#import "BPPasswordTextField.h"
#import "BPUIHelper.h"
#import "LocalUserDataManager.h"
#import <Masonry.h>


@interface BPChangePasswordViewController ()

@property (nonatomic, strong) BPNavigationTitleView *navigationTitleView;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (nonatomic, assign, readonly) CGFloat textFieldHeight;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIView *previousPasswordView;
@property (nonatomic, strong) BPPasswordTextField *previousPasswordTextField;
@property (nonatomic, strong) UIView *confirmPasswordView;
@property (nonatomic, strong) BPPasswordTextField *confirmPasswordTextField;

@property (nonatomic, strong) UILabel *cautionLabel;
@property (nonatomic, strong) UILabel *cautionLabelSecond;

@end

@implementation BPChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.titleView = self.navigationTitleView;
    
    self.view.backgroundColor = [UIColor bp_backgroundThemeColor];

    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice bp_navigationFullHeight] + 20);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    [self.view addSubview:self.previousPasswordView];
    [self.previousPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(self.textFieldHeight);
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
    }];
    
    [self.previousPasswordView addSubview:self.previousPasswordTextField];
    [self.previousPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
        make.top.bottom.mas_equalTo(self.previousPasswordView);
    }];
    
    [self.view addSubview:self.confirmPasswordView];
    [self.confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.previousPasswordView.mas_bottom).offset(20);
        make.height.mas_equalTo(self.textFieldHeight);
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
    }];
    self.confirmPasswordView.hidden = YES;
    
    [self.confirmPasswordView addSubview:self.confirmPasswordTextField];
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
        make.top.bottom.mas_equalTo(self.confirmPasswordView);
    }];
    
    [self.view addSubview:self.cautionLabel];
    [self.cautionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmPasswordView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.cautionLabelSecond];
    [self.cautionLabelSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cautionLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.confirmButton];
    self.confirmButton.frame = CGRectMake(self.textFieldHeight / 2, self.bp_height * 13 / 15 - self.textFieldHeight, self.bp_width - self.textFieldHeight, self.textFieldHeight);
    [self setConfirmButtonOff];
}

- (void)gotoConfirmMode {
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self setConfirmButtonOff];
    self.confirmPasswordView.hidden = NO;
    self.previousPasswordTextField.text = nil;
    self.previousPasswordTextField.placeholder = @"请输入新密码";
}

- (void)setConfirmButtonOff {
    self.confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [self.confirmButton setTintColor:[UIColor darkGrayColor]];
    self.confirmButton.userInteractionEnabled = NO;
}

- (void)setConfirmButtonOn {
    self.confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [self.confirmButton setTintColor:[UIColor blackColor]];
    self.confirmButton.userInteractionEnabled = YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.previousPasswordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}


// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressConfirm {
    if ([self.confirmButton.titleLabel.text isEqualToString:@"下一步"]) {
        UserModel *currentUser = [[LocalUserDataManager sharedInstance] currentUser];
        NSString *oldPassword = currentUser.password;
        if ([self.previousPasswordTextField.text isEqualToString:oldPassword]) {
            [self gotoConfirmMode];
        } else {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"密码有误" message:nil preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        NSString *password = self.confirmPasswordTextField.text;
        [[LocalUserDataManager sharedInstance] updateUserPassword:password finished:^(BOOL succeeded) {
            if (succeeded) {
                NSLog(@"修改密码成功：%@", [[LocalUserDataManager sharedInstance] currentUser]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                // 更新失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    if (textField == self.previousPasswordTextField || textField == self.confirmPasswordTextField) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex];
            //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
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

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == self.previousPasswordTextField) {
        if ([self.confirmButton.titleLabel.text isEqualToString:@"下一步"]) {
            if (textField.text.length > 0) {
                [self setConfirmButtonOn];
            } else {
                [self setConfirmButtonOff];
            }
        } else {
            if (self.previousPasswordTextField.text.length < 6 || _previousPasswordTextField.text.length > 16) {
                self.cautionLabel.hidden = NO;
                [self setConfirmButtonOff];
            } else {
                self.cautionLabelSecond.hidden = YES;
            }
            if ([self.confirmPasswordTextField.text isEqualToString:self.previousPasswordTextField.text] && ![self.previousPasswordTextField.text isEqualToString:@""]) {
                [self setConfirmButtonOn];
                self.cautionLabel.hidden = YES;
            } else {
                if (![self.confirmPasswordTextField.text isEqualToString:@""]) {
                    self.cautionLabel.hidden = NO;
                }
                [self setConfirmButtonOff];
            }
        }
    } else {
        if ([self.confirmPasswordTextField.text isEqualToString:_previousPasswordTextField.text] && ![self.previousPasswordTextField.text isEqualToString:@""]) {
            [self setConfirmButtonOn];
            self.cautionLabel.hidden = YES;
        } else {
            self.cautionLabel.hidden = NO;
            [self setConfirmButtonOff];
        }
    }
}

// MARK: Getters

- (CGFloat)textFieldHeight {
    return self.bp_height / 13;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"更改密码"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:28];
    }
    return _titleLabel;
}

- (UIView *)previousPasswordView {
    if (!_previousPasswordView) {
        _previousPasswordView = [[UIView alloc] init];
        _previousPasswordView.layer.masksToBounds = YES;
        _previousPasswordView.layer.cornerRadius = self.textFieldHeight / 2;
        _previousPasswordView.layer.borderWidth = 1;
    }
    return _previousPasswordView;
}

- (BPPasswordTextField *)previousPasswordTextField {
    if (!_previousPasswordTextField) {
        _previousPasswordTextField = [[BPPasswordTextField alloc] init];
        _previousPasswordTextField.borderStyle = UITextBorderStyleNone;
        _previousPasswordTextField.font = [UIFont systemFontOfSize:23];
        _previousPasswordTextField.placeholder = @"请确认旧密码";
        _previousPasswordTextField.delegate = self;
        _previousPasswordTextField.keyboardType = UIKeyboardTypeDefault;
        _previousPasswordTextField.secureTextEntry = YES;
    }
    return _previousPasswordTextField;
}

- (UIView *)confirmPasswordView {
    if (!_confirmPasswordView) {
        _confirmPasswordView = [[UIView alloc] init];
        _confirmPasswordView.layer.masksToBounds = YES;
        _confirmPasswordView.layer.cornerRadius = self.textFieldHeight / 2;
        _confirmPasswordView.layer.borderWidth = 1;
    }
    return _confirmPasswordView;
}

- (BPPasswordTextField *)confirmPasswordTextField {
    if (!_confirmPasswordTextField) {
        _confirmPasswordTextField = [[BPPasswordTextField alloc] init];
        _confirmPasswordTextField.borderStyle = UITextBorderStyleNone;
        _confirmPasswordTextField.font = [UIFont systemFontOfSize:23];
        _confirmPasswordTextField.placeholder = @"请确认新密码";
        _confirmPasswordTextField.delegate = self;
        _confirmPasswordTextField.keyboardType = UIKeyboardTypeDefault;
        _confirmPasswordTextField.secureTextEntry = YES;
    }
    return _confirmPasswordTextField;
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

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton.layer setMasksToBounds:YES];
        _confirmButton.layer.cornerRadius = self.textFieldHeight / 2;
        _confirmButton.layer.borderWidth = 0;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:23];
        [_confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (BPNavigationTitleView *)navigationTitleView {
    if (!_navigationTitleView) {
        _navigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:@"修改密码"];
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
