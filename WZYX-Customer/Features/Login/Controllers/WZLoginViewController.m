//
//  WZLoginViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZLoginViewController.h"
#import "WZLogin.h"
#import "WZDataFormatChecker.h"
#import "WZLoginTableView.h"
#import "WZLoginTableViewCell.h"
#import "WZRegisterViewController.h"
#import "WZResetPasswordViewController.h"

#import "Masonry.h"
#import "MBProgressHUD.h"

@interface WZLoginViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (weak, nonatomic) UIButton *countryCodeButton;
@property (weak, nonatomic) UITextField *phoneNumberTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UIButton *forgetPasswordButton;
@property (weak, nonatomic) UIButton *loginButton;

@end

@implementation WZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.registerButton];
    [self.registerButton setTitle:@"注册新账号" forState:UIControlStateNormal];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-60);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.registerButton addTarget:self action:@selector(pressesRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navDismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(pressesNavDismissButton:)];
    self.navigationItem.leftBarButtonItems = @[navDismissButton];
    UIBarButtonItem *navBackBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = navBackBtn;
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
        cell.label.text = @"登录";
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
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForButton];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForButton];
        }
        self.forgetPasswordButton = cell.button;
        [self.forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [self.forgetPasswordButton addTarget:self action:@selector(pressesForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForSubmitButton];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForSubmitButton];
        }
        self.loginButton = cell.submitButton;
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(pressesLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [self loginButtonCanPressed:NO];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView endEditing:YES];
}

#pragma mark - EventHandlers

- (void)editingChangedInTextField:(UITextField *)textField {
    if (![self.phoneNumberTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        [self loginButtonCanPressed:YES];
    } else {
        [self loginButtonCanPressed:NO];
    }
}

- (void)pressesCountryCodeButton:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前只支持中国大陆手机号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pressesForgetPasswordButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    WZResetPasswordViewController *resetPasswordVC = [[WZResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

- (void)pressesLoginButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    if ([WZDataFormatChecker isPhoneNumberString:self.phoneNumberTextField.text]) {
        [self.progressHUD showAnimated:YES];
        [WZLogin loginWithPhoneNumber:self.phoneNumberTextField.text password:self.passwordTextField.text success:^{
            [self.progressHUD hideAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *userInfo) {
            [self.progressHUD hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.phoneNumberTextField.text = @"";
                self.passwordTextField.text = @"";
                [self.phoneNumberTextField becomeFirstResponder];
                [self loginButtonCanPressed:NO];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请填写正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.phoneNumberTextField.text = @"";
            self.passwordTextField.text = @"";
            [self.phoneNumberTextField becomeFirstResponder];
            [self loginButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)pressesRegisterButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    WZRegisterViewController *registerVC = [[WZRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)pressesNavDismissButton:(UIBarButtonItem *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _registerButton;
}

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

#pragma mark - PrivateMethods

- (void)loginButtonCanPressed:(BOOL)canPressed {
    if (canPressed) {
        self.loginButton.enabled = YES;
        self.loginButton.alpha = 1.0;
    } else {
        self.loginButton.enabled = NO;
        self.loginButton.alpha = 0.5;
    }
}

@end
