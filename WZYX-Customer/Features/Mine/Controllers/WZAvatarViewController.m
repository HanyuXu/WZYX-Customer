//
//  WZAvatarViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/26.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZAvatarViewController.h"
#import <Masonry.h>
#import "WZUserInfoManager.h"
#import <MBProgressHUD.h>

#define kWZAvatorViewImageSize  (self.view.bounds.size.height-self.view.bounds.size.width-10)/2
#define kWZAvatorViewEdgeInsets UIEdgeInsetsMake(kWZAvatorViewImageSize, 5, kWZAvatorViewImageSize, 5)
#define kWZAvatorViewNewImageSize CGSizeMake(60,60)


@interface WZAvatarViewController ()
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@end

@implementation WZAvatarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView.image = [WZUserInfoManager userPortrait];
    [self.view addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.top.left.bottom.right.equalTo(self.view).insets(kWZAvatorViewEdgeInsets);
    }];
    self.imageView.layer.borderWidth = 1.5f;//边框宽度
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    
    UIBarButtonItem *changeAvatorButton = [[UIBarButtonItem alloc] initWithTitle:@"更换" style:UIBarButtonItemStylePlain target:self action:@selector(changeAvatorButtonPressed:)];
    self.navigationItem.rightBarButtonItem = changeAvatorButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - event handler

-(void) changeAvatorButtonPressed:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // Pick avator from album
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    // Pick avator from camera
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    // Cancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *newImage = [self scaleToSize:newPhoto size:kWZAvatorViewNewImageSize];
    NSDictionary *params = @{@"authToken":[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]};
    [self.progressHUD showAnimated:YES];
    [WZUserInfoManager uploadImage:newImage withParamters:params success:^{
        [self.progressHUD hideAnimated:YES];
        self.imageView.image = newPhoto;
    } failure:^(NSString * _Nonnull msg) {
        NSLog(@"fail");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        [self.progressHUD  hideAnimated:YES];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

@end
