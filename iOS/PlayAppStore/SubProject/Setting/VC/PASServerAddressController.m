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
#import "PASNetwrokManager.h"
#import "QMUIButton.h"




@interface PASServerAddressController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) PASSettingAdderssView *ipView;
@property (nonatomic, strong) PASSettingAdderssView *portView;
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) UITextField *ipTextField;
@property (nonatomic, strong) UITextField *portTextField;
@property (nonatomic, strong) UIButton *testCAButton;

@property (nonatomic) NSInteger hadTested;


@end

@implementation PASServerAddressController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
    [self judegeWhetherHadValue];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[PASNetwrokManager defaultManager] cancelRequest];
}

#pragma mark - Actions
- (void)testTheCAAvailabilitableImmidately {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
    PASNetwrokManager *manager = [PASNetwrokManager defaultManager];
    [manager getWithUrlString:str success:^(id response) {
        NSLog(@"response is %@", response);
        self.hadTested = YES;
    } failure:^(NSError *error) {
        NSLog(@"error is %@", error);
#warning 怎么知道安装了新证书
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"You should Install CA first", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
            alert.tag = 999;
            [alert show];
    }];
}

- (void)exitButtonClicked:(UITextField *)textField {
    if (self.ipTextField.text.length > 6 && self.portTextField.text.length >0) {
        
        [self validURLStringWithIPAddress:self.ipTextField.text];
        
        if (self.hadTested) {
            [self dismissViewControllerAnimated:YES completion:nil];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"You Test your CA first", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
            alert.tag = 888;
            [alert show];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"Please fill in the full IP address with the port", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
        [alert show];
    }
}

- (void)textFieldEndEdit {
    if (self.ipTextField.text.length > 6 && self.portTextField.text.length >0) {
        self.testCAButton.enabled = YES;
        [self updateTestButtonState];
    } else {
        self.testCAButton.enabled = NO;
        [self updateTestButtonState];
    }
}

- (void)validURLStringWithIPAddress:(NSString *)ipAddress {
    
    ipAddress = [ipAddress stringByReplacingOccurrencesOfString:@"/" withString:@""];
    ipAddress = [ipAddress stringByReplacingOccurrencesOfString:@"http:" withString:@""];
    ipAddress = [ipAddress stringByReplacingOccurrencesOfString:@"http" withString:@""];
    ipAddress = [ipAddress stringByReplacingOccurrencesOfString:@"s:" withString:@""];
    ipAddress = [ipAddress stringByReplacingOccurrencesOfString:@"s" withString:@""];
   
    [[NSUserDefaults standardUserDefaults] setObject:ipAddress forKey:kNSUserDefaultMainAddress];
    [[NSUserDefaults standardUserDefaults] setObject:self.portView.cardNumTextField.text forKey:kNSUserDefaultMainPort];
    NSString *str = [NSString stringWithFormat:@"https://%@:%@/", ipAddress, self.portTextField.text];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kNSUserDefaultMainHost];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999 && buttonIndex == 1) {
        [self openScheme:@"https://45.77.13.248:1337/public/diy"];
        self.hadTested = YES;
    }
    if (alertView.tag == 888 && buttonIndex == 1) {
        [self testTheCAAvailabilitableImmidately];
    }
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];

    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
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
    
    //closeButton
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(33);
        make.leading.mas_equalTo(self.view.mas_leading).offset(15);
        make.width.equalTo(@13);
        make.height.equalTo(@21);
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
    if (ip.length > 6 && port.length > 0) {
        self.ipTextField.text = ip;
        self.portTextField.text = port;
        self.testCAButton.enabled = YES;
        [self updateTestButtonState];
    } else {
        self.testCAButton.enabled = NO;
        [self updateTestButtonState];
    }
}

- (void)updateTestButtonState {
    if (self.testCAButton.enabled) {
        self.testCAButton.backgroundColor = RGBCodeColor(0x2abfff);
    } else {
        self.testCAButton.backgroundColor = RGBCodeColor(0xcccccc);
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

- (UIButton *)testCAButton {
    
    if (!_testCAButton) {
        _testCAButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testCAButton setTitle:PASLocalizedString(@"Test your CA certificate immediately", nil) forState:UIControlStateNormal];
        [_testCAButton setTitleColor:ButtonTintColor forState:UIControlStateNormal];
        _testCAButton.titleLabel.font = UIFontMake(18);
        _testCAButton.backgroundColor = RGBCodeColor(0xcccccc);
        _testCAButton.layer.cornerRadius = 5;
        _testCAButton.enabled = NO;
        [_testCAButton addTarget:self action:@selector(testTheCAAvailabilitableImmidately) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testCAButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
