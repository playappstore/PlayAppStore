//
//  PASMBView.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/14.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASMBView.h"
#import "MBProgressHUD.h"
#define delay 2
#define balpha 0.8

@interface PASMBView ()
@property (nonatomic ,strong) MBProgressHUD *hud;
@end
@implementation PASMBView
#pragma - public
+ (instancetype)showPVAddedTo:(UIView *)view
                      message:(NSString *)message {
    
    PASMBView *pView = [[PASMBView alloc] progressViewWithView:view];
    MBProgressHUD *hud = [pView creatMBProgressHUDAddto:pView];;
    hud.label.text = message;
    return pView;
}

+ (instancetype)showPVAddedTo:(UIView *)view
                      message:(NSString *)message
                     duration:(NSTimeInterval)duration {
    
    PASMBView *pView = [[PASMBView alloc] progressViewWithView:view];
    MBProgressHUD *hud = [pView creatMBProgressHUDAddto:pView];
    [hud hideAnimated:YES afterDelay:duration];
    hud.label.text = message;
    return pView;
}
+ (instancetype)showSuccessPVKeyWindowWithmessage:(NSString *)message
                                         duration:(NSTimeInterval)duration {
    
    UIWindow *keyw = [UIApplication sharedApplication].keyWindow;
    return [PASMBView showPVAddedTo:keyw status:message image:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] delays:duration];
    
    
}
+ (instancetype)showSuccessPVAddedTo:(UIView *)view message:(NSString *)message {
    
    return [PASMBView showPVAddedTo:view status:message image:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] delays:delay];
    
}
+ (instancetype)showSuccessPVAddedTo:(UIView *)view
                             message:(NSString *)message
                            duration:(NSTimeInterval)duration {
    
    return [PASMBView showPVAddedTo:view status:message image:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]delays:duration];
}
+ (instancetype)showErrorPVAddedTo:(UIView *)view message:(NSString *)message  {
    
    return [PASMBView showPVAddedTo:view status:message image:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] delays:delay];
}
+ (instancetype)showPVAddedTo:(UIView *)view
                        image:(UIImage *)image
                      message:(NSString *)message
                     duration:(NSTimeInterval)duration {
    
    return [PASMBView showPVAddedTo:view status:message image:image delays:duration];
    
}
#pragma mark - Private
+ (instancetype)showPVAddedTo:(UIView *)view status:(NSString *)status  image:(UIImage *)image  delays:(NSTimeInterval)dela{
    
    PASMBView *pView = [[PASMBView alloc] progressViewWithView:view];
    MBProgressHUD *hud = [pView creatMBProgressHUDAddto:pView];
    
    if (image != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.square = YES;
    }else {
        hud.mode = MBProgressHUDModeText;
        hud.offset = CGPointMake(0.f, 0.f);
        
    }
    
    hud.label.text = status;
    [hud hideAnimated:YES afterDelay:dela];
    return pView;
    
}
- (MBProgressHUD *)creatMBProgressHUDAddto:(UIView *)pView {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:pView animated:YES];
    hud.label.numberOfLines = 0;
    _hud = hud;
    [self backView:hud];
    hud.userInteractionEnabled = NO;
    __weak PASMBView* weakPView = self;
    hud.completionBlock = ^{
        [weakPView hidden];
        
    };
    return hud;
}
- (void)backView:(MBProgressHUD *)hud {
    
//    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:balpha];
//    hud.contentColor = [UIColor whiteColor];
//    self.backColor = [UIColor clearColor];
    
}
- (PASMBView *)progressViewWithView:(UIView*)view {
    
    PASMBView *pView = [[PASMBView alloc] initWithFrame:view.bounds];
    pView.backgroundColor = [UIColor clearColor];
    pView.userInteractionEnabled = NO;
    [view addSubview:pView];
    return pView;
}
- (void)hidden {
    if (self.completionBlock) {
        self.completionBlock();
    }
    [MBProgressHUD hideHUDForView:self animated:NO];
    [self removeFromSuperview];
}
#pragma mark - set
- (void)setBackColor:(UIColor *)backColor {
    
    _backColor = backColor;
    self.backgroundColor = self.backColor;
    
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _hud.contentColor = self.textColor;
}
- (void)setPopViewColor:(UIColor *)popViewColor {
    _popViewColor = popViewColor;
    _hud.bezelView.backgroundColor = popViewColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
