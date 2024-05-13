//
//  BPChangeNameViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/5/13.
//

#import "BPChangeNameViewController.h"
#import "BPNavigationTitleView.h"
#import "BPUIHelper.h"
#import "LocalUserDataManager.h"
#import <Masonry.h>

static const int NICKNAMEMAXLENGTH = 15;

@interface BPChangeNameViewController ()

@property (assign, nonatomic, readonly) CGFloat textFieldHeight;

@property (nonatomic, strong) BPNavigationTitleView *navigationTitleView;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation BPChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor bp_backgroundThemeColor];
    
    self.navigationItem.titleView = self.navigationTitleView;
    self.navigationItem.leftBarButtonItem = self.backButton;

    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice bp_navigationFullHeight] + 20);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    [self.view addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(self.textFieldHeight);
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
    }];
    
    [self.nameView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
        make.top.bottom.mas_equalTo(self.nameView);
    }];
    
    [self.view addSubview:self.confirmButton];
    self.confirmButton.frame = CGRectMake(self.textFieldHeight / 2, self.bp_height * 13 / 15 - self.textFieldHeight, self.bp_width - self.textFieldHeight, self.textFieldHeight);
    [self setConfirmButtonOff];
}

// 包括粘贴的长度也可以控制

- (void)limit:(UITextField *)textField {
    if (textField == _nameTextField) {
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

- (void)setConfirmButtonOff {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [_confirmButton setTintColor:[UIColor darkGrayColor]];
    _confirmButton.userInteractionEnabled = NO;
}

- (void)setConfirmButtonOn {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [_confirmButton setTintColor:[UIColor blackColor]];
    _confirmButton.userInteractionEnabled = YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nameTextField resignFirstResponder];
}

// MARK: Button Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressConfirm {
    [self setConfirmButtonOff];
    [[LocalUserDataManager sharedInstance] updateUserName:self.nameTextField.text finished:^(BOOL succeeded) {
        if (succeeded) {
            NSLog(@"修改用户名成功：%@", [[LocalUserDataManager sharedInstance] currentUser]);
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

// MARK: Getters

- (CGFloat)textFieldHeight {
    return self.bp_height / 13;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"更改昵称"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:28];
    }
    return _titleLabel;
}

- (UIView *)nameView {
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        _nameView.layer.masksToBounds = YES;
        _nameView.layer.cornerRadius = self.textFieldHeight / 2;
        _nameView.layer.borderWidth = 1;
    }
    return _nameView;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.font = [UIFont systemFontOfSize:24];
        _nameTextField.placeholder = @"请设置昵称";
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_nameTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
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
        _navigationTitleView = [[BPNavigationTitleView alloc] initWithTitle:@"修改个人信息"];
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
