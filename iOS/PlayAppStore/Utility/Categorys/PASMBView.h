//
//  PASMBView.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/14.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASMBView : UIView
//弹框消失的时候回调
@property (copy, nonatomic) MBProgressHUDCompletionBlock completionBlock;
//背景颜色 (默认透明)
@property (strong, nonatomic) UIColor *backColor;
//弹框颜色（默认黑色透明度0.8）
@property (strong, nonatomic) UIColor *popViewColor;
//字体颜色（默认白色）
@property (strong, nonatomic) UIColor *textColor;
/**
 动画类似于UIActivityIndicatorView 不会自动消失，消失需拿当前对象调hideProgressView
 @param view               加载在视图view上
 @param message            提示信息
 */
+ (instancetype)showPVAddedTo:(UIView *)view
                      message:(NSString *)message;
/**
 动画类似于UIActivityIndicatorView,duration秒后消失
 @param view               加载在视图view上
 @param message            提示信息
 @param duration           几秒后消失
 */
+ (instancetype)showPVAddedTo:(UIView *)view
                      message:(NSString *)message
                     duration:(NSTimeInterval)duration;
/**
 提示错误信息
 提示图片为一个叉号 2秒后制动消失
 @param view               加载在视图view上
 @param message            提示信息
 */

+ (instancetype)showErrorPVAddedTo:(UIView *)view
                           message:(NSString *)message ;
/**
 提示成功信息
 提示图片为一个对号 3秒后制动消失
 @param view               加载在视图view上
 @param message            提示信息
 */
+ (instancetype)showSuccessPVAddedTo:(UIView *)view
                             message:(NSString *)message
;
/**
 提示成功信息
 @param view               加载在视图view上
 @param message            提示信息
 @param duration           几秒后消失
 */
+ (instancetype)showSuccessPVAddedTo:(UIView *)view
                             message:(NSString *)message
                            duration:(NSTimeInterval)duration;
/**
 提示信息
 @param view               加载在视图view上
 @param image              提示图片，如果传nil则为纯文本提示框
 @param message            提示信息
 @param duration           几秒后消失
 */
+ (instancetype)showPVAddedTo:(UIView *)view
                        image:(UIImage *)image
                      message:(NSString *)message
                     duration:(NSTimeInterval)duration;

/**
 提示成功信息加载在keyWindow上
 @param message            提示信息
 @param duration           几秒后消失
 */
+ (instancetype)showSuccessPVKeyWindowWithmessage:(NSString *)message
                                         duration:(NSTimeInterval)duration;


/**
 隐藏CYPProgressView
 */
- (void)hidden;
@end
