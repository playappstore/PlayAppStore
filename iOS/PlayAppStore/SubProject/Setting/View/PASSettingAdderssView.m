//
//  PASSettingAdderssView.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/28.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASSettingAdderssView.h"

@interface PASSettingAdderssView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextField *cardNumTextField;
@property (nonatomic, strong) UIView *splitLineTop;
@property (nonatomic, strong) UIView *splitLineBottom;

@end

@implementation PASSettingAdderssView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeHolder:(NSString *)placeHolder isNeedTopSpitLine:(BOOL)isNeedTopSpitLine
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubTitle:title];
        [self addSubTextField:placeHolder];
        [self addSplitLine:isNeedTopSpitLine];
    }
    return self;
}


#pragma add subviews
-(void)addSubTitle:(NSString*)title
{
    [self addSubview:self.title];
    _title.text = title;
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.width.equalTo(@80);
        make.height.equalTo(@17);
    }];
}

-(void)addSubTextField:(NSString*)placeHolder
{
    [self addSubview:self.cardNumTextField];
    _cardNumTextField.placeholder = placeHolder;
    [self layoutTextField];
}

-(void)addSplitLine:(BOOL)isNeedTopSpitLine
{
    if(isNeedTopSpitLine)
    {
        [self addSubview:self.splitLineTop];
        [self.splitLineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.height.equalTo(@0.5);
            make.right.mas_equalTo(self.mas_right);
        }];
    }
    [self addSubview:self.splitLineBottom];
    [self.splitLineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
        make.right.mas_equalTo(self.mas_right);
    }];
}

#pragma auto layout subviews
-(void)layoutTextField
{
    [self.cardNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.title.mas_trailing).offset(10);
        make.height.equalTo(@17);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
    }];
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}

- (UITextField *)cardNumTextField
{
    if (!_cardNumTextField) {
        _cardNumTextField = [[UITextField alloc] init];
        _cardNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cardNumTextField.font = [UIFont systemFontOfSize:14];
    }
    return _cardNumTextField;
}

- (UIView *)splitLineTop
{
    if (_splitLineTop == nil) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBColor(230, 230, 230);
        _splitLineTop = lineView;
    }
    return _splitLineTop;
}

- (UIView *)splitLineBottom
{
    if (_splitLineBottom == nil) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBColor(230, 230, 230);
        _splitLineBottom = lineView;
    }
    return _splitLineBottom;
}

@end
