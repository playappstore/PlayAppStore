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


@interface PASServerAddressController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) PASSettingAdderssView *ipView;
@property (nonatomic, strong) PASSettingAdderssView *portView;
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) UITextField *ipTextField;
@property (nonatomic, strong) UITextField *portTextField;

@end

@implementation PASServerAddressController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
    [self judegeWhetherHadValue];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navLine.hidden = YES;
//    self.navigationController.navigationBarHidden = YES;
//}


- (void)textFieldEndEditing:(UITextField *)textField {
    if (self.ipTextField.text.length > 6 && self.portTextField.text.length >0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.ipView.cardNumTextField.text forKey:kNSUserDefaultMainAddress];
        [[NSUserDefaults standardUserDefaults] setObject:self.portView.cardNumTextField.text forKey:kNSUserDefaultMainPort];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [PASConfiguration shareInstance].baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/", self.ipTextField.text, self.portTextField.text]];
        NSLog(@"address is %@",[NSString stringWithFormat:@"http://%@:%@/", self.ipTextField.text, self.portTextField.text]);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"Please fill in the full IP address with the port", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = PASLocalizedString(@"Server address", nil);
    //self.navigationItem.leftBarButtonItem = nil;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"pas_back"];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *billItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:billItem, nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldEndEditing:)];

}

- (void)addSubviews {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pas_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(7);
        make.leading.mas_equalTo(self.view.mas_leading).offset(15);
        make.width.equalTo(@7);
        make.height.equalTo(@16);
    }];
    
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = RGBCodeColor(0xf2f2f2);
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.ipView];
    [self.scrollView addSubview:self.portView];
    
    self.ipTextField = _ipView.cardNumTextField;
    self.portTextField = _portView.cardNumTextField;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [self layoutIPView];
    [self layoutPortView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
