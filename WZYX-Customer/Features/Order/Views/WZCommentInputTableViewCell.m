//
//  WZCommentInputTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/7.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZCommentInputTableViewCell.h"

#import "Masonry.h"

#define kWZCommentInputTableViewCellEdgeInsets                 UIEdgeInsetsMake(10, 6, 10, 6)

@interface WZCommentInputTableViewCell () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *placeholderTextView;

@end

@implementation WZCommentInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.commentTextView];
        [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(kWZCommentInputTableViewCellEdgeInsets);
            make.height.mas_equalTo(200).priorityHigh();
        }];
        [self showPlaceholder];
    }
    return self;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self showPlaceholder];
    } else {
        [self hiddenPlaceholder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - PrivateMethods

- (void)showPlaceholder {
    [self.contentView addSubview:self.placeholderTextView];
    [self.placeholderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commentTextView);
    }];
}

- (void)hiddenPlaceholder {
    [self.placeholderTextView removeFromSuperview];
    self.placeholderTextView = nil;
}

#pragma mark - LazyLoad

- (UITextView *)commentTextView {
    if (!_commentTextView) {
        _commentTextView = [[UITextView alloc] init];
        _commentTextView.font = [UIFont systemFontOfSize:16];
        _commentTextView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
        _commentTextView.returnKeyType = UIReturnKeyDone;
        _commentTextView.delegate = self;
    }
    return _commentTextView;
}

- (UITextView *)placeholderTextView {
    if (!_placeholderTextView) {
        _placeholderTextView = [[UITextView alloc] init];
        _placeholderTextView.userInteractionEnabled = NO;
        _placeholderTextView.font = [UIFont systemFontOfSize:16];
        _placeholderTextView.text = @"为活动添加您的评价～";
        _placeholderTextView.textColor = [UIColor lightGrayColor];
        _placeholderTextView.backgroundColor = [UIColor clearColor];
    }
    return _placeholderTextView;
}

@end
