//
//  PASDiscoverCollectionViewCell.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiscoverCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "PASDiscoverModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface PASDiscoverCollectionViewCell ()



@end

@implementation PASDiscoverCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initWithSuber];
    }
    return self;
}
- (void)initWithSuber {
    
    //icon
    //    UIImage *topImage = [UIImage imageNamed:@"images-2.jpeg"];
    CGFloat  multiple = self.frame.size.width/60;
    _PAS_AppLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60 *multiple)];
    [_PAS_AppLogoImageView zy_cornerRadiusAdvance:5.0 rectCornerType:UIRectCornerAllCorners];
    [self.contentView addSubview:_PAS_AppLogoImageView];
    
    
    //收藏按钮
    _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(_PAS_AppLogoImageView.frame.size.width -30 , _PAS_AppLogoImageView.frame.size.height - 30, 22,22)];
    _checkBox.onAnimationType = BEMAnimationTypeBounce;
    _checkBox.offAnimationType = BEMAnimationTypeBounce;
    _checkBox.delegate = self;
    _checkBox.offFillColor = [UIColor colorWithRed:192/255.f green:192/255.f blue:192/255.f alpha:0.5];
    _checkBox.onTintColor = [UIColor whiteColor];
    _checkBox.onCheckColor = [UIColor whiteColor];
    _checkBox.tintColor = [UIColor whiteColor];
    [self.contentView addSubview:_checkBox];
    
    
    //应用名称
    _PAS_AppNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _PAS_AppLogoImageView.frame.size.height +_PAS_AppLogoImageView.frame.origin.y + 5 , self.frame.size.width, 20)];
    _PAS_AppNameLabel.text = @"这是应用名称";
    _PAS_AppNameLabel.textAlignment = NSTextAlignmentCenter;
    _PAS_AppNameLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_PAS_AppNameLabel];
    
}

//- (void)configViewWithData:(PASDiscoverModel *)model {
//    [self.PAS_AppLogoImageView sd_setImageWithURL:[NSURL URLWithString:model.PAS_AppLogo] placeholderImage:[UIImage imageNamed:@"images-2.jpeg"] options:SDWebImageRefreshCached];
//    self.PAS_AppNameLabel.text = model.PAS_AppName;
//}
- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox {
    
    
    if (self.favoriteClicked) {
        NSLog(@"现在的状态：%d",checkBox.on);
        self.favoriteClicked(checkBox.on);
    }
    
}
@end
