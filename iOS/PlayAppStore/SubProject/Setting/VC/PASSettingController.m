//
//  PASSettingController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASSettingController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PASSettingAdderssView.h"

@interface PASSettingController ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) PASSettingAdderssView *ipView;
@property (nonatomic, strong) PASSettingAdderssView *portView;


@end

@implementation PASSettingController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navLine.hidden = YES;
}






#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = @"Setting";
}

- (void)addSubviews {
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = RGBCodeColor(0xf2f2f2);
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.ipView];
    [self.scrollView addSubview:self.portView];
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [self layoutIPView];
    [self layoutPortView];
}

- (void)layoutIPView {
    [self.ipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@(88/2.0f));
        make.top.equalTo(self.view.mas_top).offset(80);
    }];

}

- (void)layoutPortView {
    [self.portView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@(88/2.0f));
        make.top.equalTo(self.ipView.mas_bottom).offset(10);
    }];
    
}

- (PASSettingAdderssView *)ipView {
    if (!_ipView) {
        _ipView = [[PASSettingAdderssView alloc] initWithFrame:CGRectZero title:@"IP Address:" placeHolder:@"请输入服务器IP地址" isNeedTopSpitLine:YES];
    }
    return _ipView;
}

- (PASSettingAdderssView *)portView {
    if (!_portView) {
        _portView = [[PASSettingAdderssView alloc] initWithFrame:CGRectZero title:@"Port:" placeHolder:@"请输入端口地址" isNeedTopSpitLine:NO];
    }
    return _portView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
