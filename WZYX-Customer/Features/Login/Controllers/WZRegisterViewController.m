//
//  WZRegisterViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZRegisterViewController.h"
#import "WZLogin.h"
#import "WZDataFormatChecker.h"
#import "WZLoginTableView.h"
#import "WZLoginTableViewCell.h"
#import "UIButton+WZCountDownButton.h"

#import "Masonry.h"
#import "MBProgressHUD.h"

@interface WZRegisterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (weak, nonatomic) UIButton *countryCodeButton;
@property (weak, nonatomic) UITextField *phoneNumberTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UITextField *verificationCodeTextField;
@property (weak, nonatomic) UIButton *verifyButton;
@property (weak, nonatomic) UIButton *registerButton;
@property (weak, nonatomic) UIButton *policyButton;

@end

@implementation WZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.loginButton];
    [self.loginButton setTitle:@"已有账号" forState:UIControlStateNormal];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-60);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.loginButton addTarget:self action:@selector(pressesLoginButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForLabel];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForLabel];
        }
        cell.label.text = @"注册";
        return cell;
    } else if (indexPath.row == 1) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForPhoneNumber];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForPhoneNumber];
        }
        self.countryCodeButton = cell.button;
        [self.countryCodeButton setTitle:@"+86" forState:UIControlStateNormal];
        [self.countryCodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.countryCodeButton addTarget:self action:@selector(pressesCountryCodeButton:) forControlEvents:UIControlEventTouchUpInside];
        self.phoneNumberTextField = cell.textField;
        [self.phoneNumberTextField addTarget:self action:@selector(editingChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    } else if (indexPath.row == 2) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForPassword];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForPassword];
        }
        self.passwordTextField = cell.textField;
        [self.passwordTextField addTarget:self action:@selector(editingChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    } else if (indexPath.row == 3) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForVerification];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForVerification];
        }
        self.verificationCodeTextField = cell.textField;
        [self.verificationCodeTextField addTarget:self action:@selector(editingChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
        self.verifyButton = cell.button;
        [self.verifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.verifyButton addTarget:self action:@selector(pressesVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.row == 4) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForSubmitButton];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForSubmitButton];
        }
        self.registerButton = cell.submitButton;
        [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerButton addTarget:self action:@selector(pressesRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        [self registerButtonCanPressed:NO];
        return cell;
    } else {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForLabelAndButton];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForLabelAndButton];
        }
        cell.label.text = @"点击注册即表示同意";
        self.policyButton = cell.button;
        [self.policyButton setTitle:@"《万众艺兴》服务条款" forState:UIControlStateNormal];
        [self.policyButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.policyButton addTarget:self action:@selector(pressesPolicyButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView endEditing:YES];
}

#pragma mark - EventHandlers

- (void)editingChangedInTextField:(UITextField *)textField {
    if (![self.phoneNumberTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""] && ![self.verificationCodeTextField.text isEqualToString:@""]) {
        [self registerButtonCanPressed:YES];
    } else {
        [self registerButtonCanPressed:NO];
    }
}

- (void)pressesCountryCodeButton:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前只支持中国大陆手机号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pressesVerifyButton:(UIButton *)button {
    if ([WZDataFormatChecker isPhoneNumberString:self.phoneNumberTextField.text]) {
        [self.progressHUD showAnimated:YES];
        [WZLogin sendVerificationCodeToPhoneNumber:self.phoneNumberTextField.text success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressHUD hideAnimated:YES];
                [button countDownWithDuration:60 interval:1 countDownTitle:@"秒后重发" canInteraction:NO finishedBlock:^{
                    [self.verifyButton setTitle:@"重发验证码" forState:UIControlStateNormal];
                    self.verifyButton.enabled = YES;
                }];
            });
        } failure:^(NSString *userInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressHUD hideAnimated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请填写正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.phoneNumberTextField.text = @"";
            self.passwordTextField.text = @"";
            self.verificationCodeTextField.text = @"";
            [self.phoneNumberTextField becomeFirstResponder];
            [self registerButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)pressesRegisterButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    if (![WZDataFormatChecker isPhoneNumberString:self.phoneNumberTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请填写正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.phoneNumberTextField.text = @"";
            self.passwordTextField.text = @"";
            self.verificationCodeTextField.text = @"";
            [self.phoneNumberTextField becomeFirstResponder];
            [self registerButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (![WZDataFormatChecker isVerificationCodeString:self.verificationCodeTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请填写正确的验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.verificationCodeTextField.text = @"";
            [self.verificationCodeTextField becomeFirstResponder];
            [self registerButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.progressHUD showAnimated:YES];
    [WZLogin registerWithPhoneNumber:self.phoneNumberTextField.text password:self.passwordTextField.text verificationCode:self.verificationCodeTextField.text success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHUD hideAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSString *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHUD hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.phoneNumberTextField.text = @"";
                self.passwordTextField.text = @"";
                self.verificationCodeTextField.text = @"";
                [self registerButtonCanPressed:NO];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

- (void)pressesPolicyButton:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂未实现用户协议" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pressesLoginButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LazyLoad

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[WZLoginTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

#pragma mark - PrivateMethods

- (void)registerButtonCanPressed:(BOOL)canPressed {
    if (canPressed) {
        self.registerButton.enabled = YES;
        self.registerButton.alpha = 1.0;
    } else {
        self.registerButton.enabled = NO;
        self.registerButton.alpha = 0.5;
    }
}

@end
