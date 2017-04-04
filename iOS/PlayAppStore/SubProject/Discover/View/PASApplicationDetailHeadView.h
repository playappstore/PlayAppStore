//
//  PASApplicationDetailHeadView.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASApplicationDetailHeadView : UIView

//icon of Application
@property (nonatomic, readonly, strong) UIImageView *titleImageView;
//title of Application
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UIImageView *wholeImageView;

@end
