//
//  BPLoginViewController.m
//  Persevere
//
//  Created by 张博添 on 2024/4/23.
//

#import "BPLoginViewController.h"
#import "BPUIHelper.h"
#import <Masonry.h>

@interface PasswordTextField : UITextField
@end

@implementation PasswordTextField
// 密码输入框，不能够粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}
@end

static const int textFieldFontSize = 23; //字体大小
static const int PHONEMAXLENGTH = 11;    //电话号码长度
static const int CODEMAXLENGTH = 6;      //验证码长度
static int amountOfTimeLeft = 60;        //倒计时

@interface BPLoginViewController ()
<UITextFieldDelegate>

@property (assign, nonatomic, readonly) CGFloat textFieldHeight;
@property (nonatomic, strong) UIView *passwordView;
@property (nonatomic, strong) NSTimer *countDownTimer;

/// 切换按钮
@property (nonatomic, strong) UIButton *switchButton;
/// 标题Label
@property (nonatomic, strong) UILabel *titleLabel;
/// 电话号码和密码（验证码）输入框
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *passwordTextField;


@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *touristButton;

/// 发送验证码
@property (nonatomic, strong) UIButton *sendCodeButton;

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;

@end

@implementation BPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
}

- (void)buildUI {

    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice bp_statusBarHeight] + 100);
        make.left.mas_equalTo(40);
    }];
    
    UIView *accountView = [[UIView alloc] init];
    [self.view addSubview:accountView];
    [accountView addSubview:self.phoneNumberTextField];
    accountView.layer.masksToBounds = YES;
    accountView.layer.cornerRadius = self.textFieldHeight / 2;
    accountView.layer.borderWidth = 1;
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-self.textFieldHeight * 2);
        make.height.mas_equalTo(self.textFieldHeight);
        make.left.mas_equalTo(self.textFieldHeight / 2);
        make.right.mas_equalTo(-self.textFieldHeight / 2);
    }];
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountView.mas_left).offset(self.textFieldHeight / 2);
        make.right.mas_equalTo(accountView.mas_right).offset(-self.textFieldHeight / 2);
        make.top.bottom.mas_equalTo(accountView);
    }];
    
    [self.view addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountView.mas_bottom).offset(self.textFieldHeight / 6);
        make.height.mas_equalTo(self.textFieldHeight);
        make.left.right.mas_equalTo(accountView);
    }];
    
    [self useMessage];
    [self.passwordView addSubview:self.sendCodeButton];
    
    [self.passwordView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordView.mas_left).offset(self.textFieldHeight / 2);
        make.right.mas_equalTo(self.passwordView.mas_right).offset(-self.textFieldHeight / 2);
        make.top.mas_equalTo(self.passwordView.mas_top);
        make.bottom.mas_equalTo(self.passwordView.mas_bottom);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordView.mas_bottom).offset(self.textFieldHeight / 3);
        make.height.mas_equalTo(self.textFieldHeight);
        make.left.mas_equalTo(accountView.mas_left);
        make.right.mas_equalTo(accountView.mas_right);
    }];
    
    [self.view addSubview:self.touristButton];
    [self.touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(self.textFieldHeight / 6);
        make.centerX.mas_equalTo(self.view);
    }];
        
    [self.view addSubview:self.switchButton];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.touristButton.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
    }];
}
#pragma mark - 切换登录模式
- (void)pressSwitch {
    if ([self.switchButton.titleLabel.text isEqualToString:@"密码登录"]) {
        [self usePassword];
        self.sendCodeButton.hidden = YES;
        [self setSendButtonOn];
        [self.sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.countDownTimer invalidate];
    } else {
        [self useMessage];
        self.sendCodeButton.hidden = NO;
    }
    self.phoneNumberTextField.enabled = YES;
    self.phoneNumberTextField.text = @"";
    self.passwordTextField.text = @"";
}

#pragma mark - 验证码框输入
- (void)useMessage {
    [self setSendButtonOff];
    [self setLoginButtonOff];
    
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;

    [self.switchButton setTitle:@"密码登录" forState:UIControlStateNormal];
    [self.titleLabel setText:@"手机号登录/注册"];
    self.passwordTextField.placeholder = @"请输入验证码";
    [self.loginButton setTitle:@"一键登录/注册" forState:UIControlStateNormal];
}
#pragma mark - 密码框输入，禁止粘贴

- (void)usePassword {
    [self setLoginButtonOff];
    
    self.passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
    
    [self.switchButton setTitle:@"验证码登录" forState:UIControlStateNormal];
    [self.titleLabel setText:@"密码登录"];
    self.passwordTextField.placeholder = @"请输入密码";
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.passwordTextField.secureTextEntry = YES;
}
#pragma mark - 限制密码框输入内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    if (textField == _passwordTextField) {
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
    }
    return YES;
}
#pragma mark - 输入结束，更改按钮与输入框状态
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    //密码框在输入
    if (textField == self.passwordTextField) {
        //密码输入
        if ([self.titleLabel.text isEqualToString:@"密码登录"]) {
            //输入了密码
            if ([self CheckPhoneNumInput:self.phoneNumberTextField.text] && ![self.passwordTextField.text isEqualToString:@""]) {
                [self setLoginButtonOn];
            } else {
                [self setLoginButtonOff];
            }
        } else {//验证码输入
            if ([self CheckPhoneNumInput:self.phoneNumberTextField.text] && [self CheckVerificationCodeInput:self.passwordTextField.text]) {
                //验证码与手机的格式均正确
                [self setLoginButtonOn];
            } else {
                [self setLoginButtonOff];
            }
        }
    } else if (textField == self.phoneNumberTextField) {//电话号码框在输入
        if ([self CheckPhoneNumInput:textField.text]) {
            if (![self.titleLabel.text isEqualToString:@"密码登录"]) {
                // 输入电话号码后允许发送验证码
                [self setSendButtonOn];
            } else {
                // 使用密码登录允许输入密码
                self.passwordTextField.enabled = YES;
            }
        } else {
            self.passwordTextField.text = @"";
            self.passwordTextField.enabled = NO;
            [self setLoginButtonOff];
        }
    }
}

#pragma mark - 按发送验证码按钮
- (void)pressSendCodeButton {
    [self creatTimerFunction];
    self.passwordTextField.enabled = YES;
    [self setSendButtonOff];
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%02ds", amountOfTimeLeft] forState:UIControlStateNormal];
    self.phoneNumberTextField.enabled = NO;
    self.phoneNumber = self.phoneNumberTextField.text;
    
}

#pragma mark - 生成计时器
- (void)creatTimerFunction {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    NSRunLoop* mainloop = [NSRunLoop mainRunLoop];
    [mainloop addTimer:timer forMode:NSRunLoopCommonModes];
    self.countDownTimer = timer;
}

- (void)timerCountDown {
    // 未到一分钟
    if (amountOfTimeLeft > 0) {
        amountOfTimeLeft--;
        [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%02ds", amountOfTimeLeft] forState:UIControlStateNormal];
    } else {// 时限已到
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        amountOfTimeLeft = 60;
        [self setSendButtonOn];
        [self.sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
        self.phoneNumberTextField.enabled = YES;
    }
}

#pragma mark- 判断手机号码
- (BOOL)CheckPhoneNumInput:(NSString *)phone {
    NSString *Regex = @"(13[0-9]|14[57]|15[012356789]|18[012356789])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:phone];
}

#pragma mark- 判断验证码
- (BOOL)CheckVerificationCodeInput:(NSString *)code {
    NSString *Regex = @"\\d{6}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:code];
}

#pragma mark- 更改登录按钮状态
- (void)setLoginButtonOn {
    self.loginButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [self.loginButton setTintColor:[UIColor blackColor]];
    self.loginButton.userInteractionEnabled = YES;
}

- (void)setLoginButtonOff {
    self.loginButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [self.loginButton setTintColor:[UIColor darkGrayColor]];
    self.loginButton.userInteractionEnabled = NO;
}

#pragma mark - 更改验证码按钮状态
- (void)setSendButtonOn {
    [self.sendCodeButton setTintColor:[UIColor blackColor]];
    self.sendCodeButton.userInteractionEnabled = YES;
}

- (void)setSendButtonOff {
    [self.sendCodeButton setTintColor:[UIColor darkGrayColor]];
    self.sendCodeButton.userInteractionEnabled = NO;
}

#pragma mark - 监听函数，控制电话框输入长度
//包括粘贴的长度也可以控制
- (void)limit:(UITextField *)textField {
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length > PHONEMAXLENGTH) {
            textField.text = [textField.text substringToIndex:PHONEMAXLENGTH];
        }
    } else if (textField == self.passwordTextField) {
        if (textField.text.length > CODEMAXLENGTH) {
            textField.text = [textField.text substringToIndex:CODEMAXLENGTH];
        }
    }
}

// MARK: Getters

- (CGFloat)textFieldHeight {
    return self.view.bp_height / 13;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_switchButton setTitle:@"密码登录" forState:UIControlStateNormal];
        _switchButton.tintColor = [UIColor blackColor];
        
        [_switchButton addTarget:self action:@selector(pressSwitch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"手机号登录/注册"];
        _titleLabel.font = [UIFont systemFontOfSize:30];
    }
    return _titleLabel;
}

- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] init];
        _phoneNumberTextField.borderStyle = UITextBorderStyleNone;
        _phoneNumberTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
        _phoneNumberTextField.placeholder = @"请输入手机号码";
        _phoneNumberTextField.delegate = self;
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        //设置监听
        [_phoneNumberTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
        //清除按钮
        _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneNumberTextField;
}

- (UIView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[UIView alloc] init];
        _passwordView.layer.masksToBounds = YES;
        _passwordView.layer.cornerRadius = self.textFieldHeight / 2;
        _passwordView.layer.borderWidth = 1;
    }
    return _passwordView;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[PasswordTextField alloc] init];
        _passwordTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.delegate = self;
        _passwordTextField.enabled = NO;
        [_passwordTextField addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize - 1];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.borderWidth = 0;
        _loginButton.layer.cornerRadius = self.textFieldHeight / 2;
        [_loginButton setTitle:@"一键登录/注册" forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UIButton *)touristButton {
    if (!_touristButton) {
        _touristButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_touristButton setTitle:@"随便逛逛" forState:UIControlStateNormal];
        [_touristButton setTintColor:[UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1]];
    }
    return _touristButton;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        double codeButtonWidth = self.textFieldHeight * 4 / 3;
        _sendCodeButton.frame = CGRectMake(self.bp_width - self.textFieldHeight - codeButtonWidth, 0, codeButtonWidth, self.textFieldHeight);
        [_sendCodeButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendCodeButton.layer.masksToBounds = YES;
        _sendCodeButton.layer.borderWidth = 1;
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:textFieldFontSize - 1];
        [_sendCodeButton addTarget:self action:@selector(pressSendCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}

@end
