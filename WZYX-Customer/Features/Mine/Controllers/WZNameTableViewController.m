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

@interface WZNameTableViewController ()

@property (strong, nonatomic) NSString *originalName;

@property (weak, nonatomic) UITextField *textField;

@end

@implementation WZNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(setNameButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)setNameButtonPressed:(UIButton *)sender {
    NSString *newName = self.textField.text;
    if (![newName isEqualToString:self.originalName]) {
        if (newName.length <= 3 || newName.length >= 10) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名非法" message:@"用户名长度应在3到10个字符之间" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
#warning POST请求
            // self.user.name = [NSString stringWithString:newName];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
    cell.textField.text = @"测试";
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
    NSLog(@"touch begins");
    [self.tableView endEditing: YES];
}

@end
