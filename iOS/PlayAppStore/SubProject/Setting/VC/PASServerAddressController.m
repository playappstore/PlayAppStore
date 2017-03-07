//
//  PASServerAddressController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASServerAddressController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PASSettingAdderssView.h"
#import "PASConfiguration.h"
#import <QMUIKit/QMUIKit.h>


@interface PASServerAddressController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) PASSettingAdderssView *ipView;
@property (nonatomic, strong) PASSettingAdderssView *portView;
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) UITextField *ipTextField;
@property (nonatomic, strong) UITextField *portTextField;
@property (nonatomic, strong) QMUIButton *testCAButton;


@end

@implementation PASServerAddressController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
    [self judegeWhetherHadValue];
}

#pragma mark - Actions
- (void)testTheCAAvailabilitableImmidately {
    NSLog(@"ddddd");
}

- (void)textFieldEndEditing:(UITextField *)textField {
    if (self.ipTextField.text.length > 6 && self.portTextField.text.length >0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.ipView.cardNumTextField.text forKey:kNSUserDefaultMainAddress];
        [[NSUserDefaults standardUserDefaults] setObject:self.portView.cardNumTextField.text forKey:kNSUserDefaultMainPort];
        NSString *str = [NSString stringWithFormat:@"http://%@:%@/", self.ipTextField.text, self.portTextField.text];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:kNSUserDefaultMainHost];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"Please fill in the full IP address with the port", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
        [alert show];
    }
}

- (void)textFieldEndEdit {
    if (self.ipTextField.text.length > 6 && self.portTextField.text.length >0) {
        self.testCAButton.highlighted = YES;
        self.testCAButton.userInteractionEnabled = YES;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Setter && Getter
- (void)loadNav {
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = PASLocalizedString(@"Server address", nil);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(33);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pas_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(33);
        make.leading.mas_equalTo(self.view.mas_leading).offset(15);
        make.width.equalTo(@7);
        make.height.equalTo(@16);
    }];
}

- (void)addSubviews {
    
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = RGBCodeColor(0xf2f2f2);
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.ipView];
    [self.scrollView addSubview:self.portView];
    
    self.ipTextField = _ipView.cardNumTextField;
    self.portTextField = _portView.cardNumTextField;
    [self.ipTextField addTarget:self action:@selector(textFieldEndEdit) forControlEvents:UIControlEventEditingChanged];
    [self.portTextField addTarget:self action:@selector(textFieldEndEdit) forControlEvents:UIControlEventEditingChanged];
    
    
    [self.scrollView addSubview:self.testCAButton];
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [self layoutIPView];
    [self layoutPortView];
    [self layoutTestButton];
}

- (void)judegeWhetherHadValue {
    NSString *ip =  [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainAddress];
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainPort];
    if (ip.length > 6) {
        self.ipTextField.text = ip;
    }
    if (port.length > 0) {
        self.portTextField.text = port;
    }
}

- (void)layoutIPView {
    [self.ipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(88/2.0f));
        make.top.equalTo(self.view.mas_top).offset(80);
    }];
}

- (void)layoutPortView {
    [self.portView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(88/2.0f));
        make.top.equalTo(self.ipView.mas_bottom).offset(10);
    }];
}

- (void)layoutTestButton {
    [self.testCAButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(88/2.0f));
        make.top.equalTo(self.portView.mas_bottom).offset(30);
    }];
}
- (PASSettingAdderssView *)ipView {
    if (!_ipView) {
        _ipView = [[PASSettingAdderssView alloc] initWithFrame:CGRectZero title:PASLocalizedString(@"IP Address:", nil) placeHolder:PASLocalizedString(@"Please enter the server IP address", nil) isNeedTopSpitLine:YES];
    }
    return _ipView;
}

- (PASSettingAdderssView *)portView {
    if (!_portView) {
        _portView = [[PASSettingAdderssView alloc] initWithFrame:CGRectZero title:PASLocalizedString(@"Port:", nil) placeHolder:PASLocalizedString(@"Please enter the port address", nil) isNeedTopSpitLine:NO];
    }
    return _portView;
}

- (QMUIButton *)testCAButton {
    
    if (!_testCAButton) {
        _testCAButton = [[QMUIButton alloc] init];
        [_testCAButton setTitle:PASLocalizedString(@"Test your CA certificate immediately", nil) forState:UIControlStateNormal];
        _testCAButton.adjustsButtonWhenHighlighted = YES;
        [_testCAButton setTitleColor:ButtonTintColor forState:UIControlStateNormal];
        _testCAButton.titleLabel.font = UIFontMake(18);
        _testCAButton.backgroundColor = RGBCodeColor(0xcccccc);
        _testCAButton.highlightedBackgroundColor = RGBCodeColor(0x2abfff);
        _testCAButton.layer.cornerRadius = 5;
        _testCAButton.userInteractionEnabled = NO;
        [_testCAButton addTarget:self action:@selector(testTheCAAvailabilitableImmidately) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testCAButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
