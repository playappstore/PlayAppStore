//
//  PASSettingAdderssView.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/28.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASSettingAdderssView : UIView

@property (nonatomic, readonly, strong) UITextField *cardNumTextField;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title placeHolder:(NSString*)placeHolder isNeedTopSpitLine:(BOOL)isNeedTopSpitLine;

@end
