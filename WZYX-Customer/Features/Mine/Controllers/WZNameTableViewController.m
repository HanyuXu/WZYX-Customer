//
//  WZNameTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/24.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZNameTableViewController.h"
#import "WZUserPortraitTableViewCell.h"
#import "WZTextFieldTableViewCell.h"
#import "WZUserInfoManager.h"
#import "WZUser.h"

@interface WZNameTableViewController ()

@property (strong, nonatomic) NSString *originalName;

@property (weak, nonatomic) UITextField *textField;

@end

@implementation WZNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *changeNameButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(changeNameButtonPressed:)];
    self.navigationItem.rightBarButtonItem = changeNameButton;
}

- (void)changeNameButtonPressed:(UIButton *)sender {
    NSString *newName = self.textField.text;
    if (![newName isEqualToString:self.originalName]) {
        if (newName.length < 3 || newName.length > 21) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名非法" message:@"用户名长度应在3到20个字符之间" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *param = @{@"authToken" : [userDefaults objectForKey:@"authToken"], @"userName" : newName};
            [WZUserInfoManager updateUserInfoWithPrameters:param success:^{
                [WZUser sharedUser].userName = newName;
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull userInfo) {
                self.textField.text = [userDefaults objectForKey:@"userName"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZTextFieldTableViewCell *cell = [[WZTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nameField"];
    cell.textField.text = [WZUser sharedUser].userName;
    [cell.textField becomeFirstResponder];
    cell.textField.delegate = self;
    self.textField = cell.textField;
    self.originalName = [NSString stringWithString:self.textField.text];
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.tableView endEditing: YES];
}

@end
