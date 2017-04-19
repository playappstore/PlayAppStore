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
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) UITextField *ipTextField;
@property (nonatomic, strong) UITextField *portTextField;
@property (nonatomic, strong) UIButton *testCAButton;
@property (nonatomic ,copy) NSString *orIpStr;


@end

@implementation PASServerAddressController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = PASLocalizedString(@"Server address", nil);
    self.navigationItem.leftBarButtonItem = [QMUINavigationButton closeBarButtonItemWithTarget:self action:@selector(exitButtonClicked) tintColor:[UIColor whiteColor]];
    [self addSubviews];
    [self judegeWhetherHadValue];
    _orIpStr = self.ipTextField.text;
    
}
- (void)handleCloseButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [[PASNetwrokManager defaultManager] cancelRequest];
}

#pragma mark - Actions
- (void)testTheCAAvailabilitableImmidately {
    [self.ipTextField resignFirstResponder];
    [self testTheCAAvailabilitableImmidatelyClose:NO];
    [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
   
}
- (void)testTheCAAvailabilitableImmidatelyClose:(BOOL)close {
    NSString *str = [NSString stringWithFormat:@"%@records/ios",[self validURLStringWithIPAddress:self.ipTextField.text]] ;
    PASNetwrokManager *manager = [PASNetwrokManager defaultManager];
    [manager getWithUrlString:str success:^(id response) {
        NSLog(@"response is %@", response);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
        PASMBView *pv = [PASMBView showSuccessPVAddedTo:self.scrollView message:@"success" ];
        pv.completionBlock = ^{
            if (close) {
                [self handleCloseButtonEvent];
            }
        };
        [self saveIpDressWithStr:[self validURLStringWithIPAddress:self.ipTextField.text]];
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"You should Install CA first", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
        alert.tag = 999;
        [alert show];
    }];
}
- (void)exitButtonClicked {
    if (self.ipTextField.text.length <= 6) {
        //没有填写完整的ip
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"Please fill in the full IP address with the port", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
        [alert show];

    }else if ([_orIpStr isEqualToString:self.ipTextField.text]){
   
        //没有编辑过，且原先地址验证通过过
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }else if (![_orIpStr isEqualToString:self.ipTextField.text]) {
    
        //当前ip地址没有验证过
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"You Test your CA first", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
        alert.tag = 888;
        [alert show];

    
    }
}

- (void)textFieldEndEdit {
    if (self.ipTextField.text.length > 6 ) {
//    if (self.ipTextField.text.length > 6 && self.portTextField.text.length >0) {
        self.testCAButton.enabled = YES;
        [self updateTestButtonState];
    } else {
        self.testCAButton.enabled = NO;
        [self updateTestButtonState];
    }
}

- (NSString *)validURLStringWithIPAddress:(NSString *)ipAddress {
    
    NSURL *isValidatIP = [self smartURLForString:ipAddress];
    ipAddress = [NSString stringWithFormat:@"%@",isValidatIP];
   
    NSString *str;
    if ([ipAddress hasSuffix:@"/"]) {
            
        str = [NSString stringWithFormat:@"%@", ipAddress];
       
    }else {
        
        str = [NSString stringWithFormat:@"%@/", ipAddress];
        
    }
    return str;
        
}
- (void)saveIpDressWithStr:(NSString *)str {
 
    _orIpStr = self.ipTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kNSUserDefaultMainHost];
    [[NSUserDefaults standardUserDefaults] synchronize];
    


}
- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999 && buttonIndex == 1) {
        NSString *openString =[NSString stringWithFormat:@"%@diy",[[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost]] ;
        [self openScheme:openString];
    }
    if (alertView.tag == 888 && buttonIndex == 1) {
        [self testTheCAAvailabilitableImmidatelyClose:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
        
        [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
        [hud.button addTarget:self action:@selector(handleCloseButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    if (buttonIndex == 0) {
        [self handleCloseButtonEvent];
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

- (void)addSubviews {
    
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = RGBCodeColor(0xf2f2f2);
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.ipView];
    
    self.ipTextField = _ipView.cardNumTextField;
    [self.ipTextField addTarget:self action:@selector(textFieldEndEdit) forControlEvents:UIControlEventEditingChanged];
    
    [self.scrollView addSubview:self.testCAButton];
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [self layoutIPView];
    [self layoutTestButton];
}

- (void)judegeWhetherHadValue {
    NSString *ip =  [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
    if (ip.length > 6 ) {
        self.ipTextField.text = ip;
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


- (void)layoutTestButton {
    [self.testCAButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(88/2.0f));
        make.top.equalTo(self.ipView.mas_bottom).offset(30);
    }];
}
- (PASSettingAdderssView *)ipView {
    if (!_ipView) {
        _ipView = [[PASSettingAdderssView alloc] initWithFrame:CGRectZero title:PASLocalizedString(@"IP Address:", nil) placeHolder:PASLocalizedString(@"Please enter the server IP address", nil) isNeedTopSpitLine:YES];
    }
    return _ipView;
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
