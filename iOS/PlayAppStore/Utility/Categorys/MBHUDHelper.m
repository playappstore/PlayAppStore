//
//  MBHUDHelper.m
//  iplaza
//
//  Created by Rush.D.Xzj on 4/27/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "MBHUDHelper.h"
#import "MBProgressHUD.h"

@implementation MBHUDHelper

+ (void)showWarningWithText:(NSString *)text
{
    [MBHUDHelper showWarningWithText:text imgStr:nil delay:2.0f delegate:nil];
}

+ (void)showWarningWithText:(NSString *)text delay:(NSTimeInterval)delay
{
    [MBHUDHelper showWarningWithText:text imgStr:nil delay:delay delegate:nil];
}

+ (void)showWarningWithText:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate
{
    [MBHUDHelper showWarningWithText:text imgStr:nil delay:2.0f delegate:delegate];
}

+ (void)showWarningWithText:(NSString *)text imgStr:(NSString*)imgStr delay:(NSTimeInterval)delay delegate:(id<MBProgressHUDDelegate>)delegate
{
    if (text &&[text isKindOfClass:[NSString class]] &&![text isEqualToString:@""]) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.delegate = delegate;
        if ([imgStr isKindOfClass:[NSString class]] && imgStr != nil && imgStr.length != 0) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [self getCustonViewWithImg:imgStr Text:text WithSuperView:hud];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = text;
        }
        hud.dimBackground = NO;
        [hud hide:YES afterDelay:delay];
    }

}

+ (UIView*)getCustonViewWithImg:(NSString*)imgStr Text:(NSString*)text WithSuperView:(UIView*)superView{
    
    UIView *customView = [[UIView alloc] init];

    UIImage *iconImg = [UIImage imageNamed:imgStr];
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconImg.size.width, iconImg.size.height)];
    iconImgView.image = iconImg;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text ? text : @"";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    NSDictionary * attributes = @{NSFontAttributeName : label.font};
    CGSize contentSize = [label.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT)
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:attributes
                                                  context:nil].size;
    label.frame = CGRectMake(0, iconImgView.frame.origin.y + iconImgView.frame.size.height + 7, contentSize.width, contentSize.height);
    
    
    customView.frame = CGRectMake(superView.center.x, superView.center.y, contentSize.width, label.frame.origin.y + label.frame.size.height);
    CGRect rect = iconImgView.frame;
    rect.origin.x = (customView.frame.size.width - iconImgView.frame.size.width)/2;
    rect.origin.y = 0;
    iconImgView.frame = rect;
    [customView addSubview:iconImgView];
    [customView addSubview:label];
    
    return customView;
}

+ (void)showWarningWithText:(NSString *)text delay:(NSTimeInterval)delay onView:(UIView *)view {
    if (text.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = text;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:delay];
    }
}

@end
