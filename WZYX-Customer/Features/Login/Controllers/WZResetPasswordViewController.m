//
//  WZResetPasswordViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/25.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZResetPasswordViewController.h"
#import "WZLogin.h"
#import "WZDataFormatChecker.h"
#import "WZLoginTableView.h"
#import "WZLoginTableViewCell.h"
#import "UIButton+WZCountDownButton.h"

#import "Masonry.h"
#import "MBProgressHUD.h"

@interface WZResetPasswordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (weak, nonatomic) UIButton *countryCodeButton;
@property (weak, nonatomic) UITextField *phoneNumberTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UITextField *verificationCodeTextField;
@property (weak, nonatomic) UIButton *verifyButton;
@property (weak, nonatomic) UIButton *submitButton;

@end

@implementation WZResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForLabel];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForLabel];
        }
        cell.label.text = @"重置密码";
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
        self.passwordTextField.placeholder = @"新密码";
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
    } else {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForSubmitButton];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForSubmitButton];
        }
        self.submitButton = cell.submitButton;
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(pressesSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
        [self submitButtonCanPressed:NO];
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
        [self submitButtonCanPressed:YES];
    } else {
        [self submitButtonCanPressed:NO];
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
            [self.progressHUD hideAnimated:YES];
            [button countDownWithDuration:60 interval:1 countDownTitle:@"秒后重发" canInteraction:NO finishedBlock:^{
                [self.verifyButton setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.verifyButton.enabled = YES;
            }];
        } failure:^(NSString *userInfo) {
            [self.progressHUD hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请填写正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.phoneNumberTextField.text = @"";
            self.passwordTextField.text = @"";
            self.verificationCodeTextField.text = @"";
            [self.phoneNumberTextField becomeFirstResponder];
            [self submitButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)pressesSubmitButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    if (![WZDataFormatChecker isPhoneNumberString:self.phoneNumberTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请填写正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.phoneNumberTextField.text = @"";
            self.passwordTextField.text = @"";
            self.verificationCodeTextField.text = @"";
            [self.phoneNumberTextField becomeFirstResponder];
            [self submitButtonCanPressed:NO];
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
            [self submitButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.progressHUD showAnimated:YES];
    [WZLogin resetPasswordWithPhoneNumber:self.phoneNumberTextField.text verificationCode:self.verificationCodeTextField.text newPassword:self.passwordTextField.text success:^{
        [self.progressHUD hideAnimated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"信息" message:@"密码重置成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(NSString *userInfo) {
        [self.progressHUD hideAnimated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.phoneNumberTextField.text = @"";
            self.passwordTextField.text = @"";
            self.verificationCodeTextField.text = @"";
            [self submitButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
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

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

#pragma mark - PrivateMethods

- (void)submitButtonCanPressed:(BOOL)canPressed {
    if (canPressed) {
        self.submitButton.enabled = YES;
        self.submitButton.alpha = 1.0;
    } else {
        self.submitButton.enabled = NO;
        self.submitButton.alpha = 0.5;
    }
}

@end
