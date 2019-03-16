//
//  WZModifyPasswordViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/25.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZModifyPasswordViewController.h"
#import "WZLogin.h"
#import "WZLoginTableView.h"
#import "WZLoginTableViewCell.h"
#import "WZResetPasswordViewController.h"

#import "Masonry.h"
#import "MBProgressHUD.h"

@interface WZModifyPasswordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (weak, nonatomic) UITextField *oldPasswordTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UIButton *forgetPasswordButton;
@property (weak, nonatomic) UIButton *submitButton;

@end

@implementation WZModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
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
        cell.label.text = @"修改密码";
        return cell;
    } else if (indexPath.row == 1) {
        WZLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWZLoginTableViewCellForPassword];
        if (!cell) {
            cell = [[WZLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZLoginTableViewCellForPassword];
        }
        self.oldPasswordTextField = cell.textField;
        self.oldPasswordTextField.placeholder = @"原密码";
        [self.oldPasswordTextField addTarget:self action:@selector(editingChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
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
    if (![self.oldPasswordTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        [self submitButtonCanPressed:YES];
    } else {
        [self submitButtonCanPressed:NO];
    }
}

- (void)pressesForgetPasswordButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    WZResetPasswordViewController *resetPasswordVC = [[WZResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

- (void)pressesSubmitButton:(UIButton *)button {
    [self.tableView endEditing:YES];
    
    if ([self.oldPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"新密码与旧密码相同" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.oldPasswordTextField.text = @"";
            self.passwordTextField.text = @"";
            [self.oldPasswordTextField becomeFirstResponder];
            [self submitButtonCanPressed:NO];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.progressHUD showAnimated:YES];
    [WZLogin modifyPassword:self.oldPasswordTextField.text toNewPassword:self.passwordTextField.text success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHUD hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"信息" message:@"密码修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    } failure:^(NSString *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHUD hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.oldPasswordTextField.text = @"";
                self.passwordTextField.text = @"";
                [self submitButtonCanPressed:NO];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

- (void)pressesNavDismissButton:(UIBarButtonItem *)button {
    [self.tableView endEditing:YES];
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
