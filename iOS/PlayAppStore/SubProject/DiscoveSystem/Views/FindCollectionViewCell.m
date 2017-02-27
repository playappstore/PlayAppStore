//
//  FindCollectionViewCell.m
//  collectionView
//
//  Created by cheyipai.com on 2017/2/20.
//  Copyright © 2017年 kong. All rights reserved.
//

#import "FindCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"

@implementation FindCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self initWithSuber];
    }
    return self;
}
- (void)initWithSuber {

    //icon
    UIImage *topImage = [UIImage imageNamed:@"Icon-60.png"];
    CGFloat  multiple = self.frame.size.width/topImage.size.width;
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, topImage.size.height *multiple)];
     [_topImageView zy_cornerRadiusAdvance:5.0 rectCornerType:UIRectCornerAllCorners];
    _topImageView.image = topImage;
    [self.contentView addSubview:_topImageView];
    
    
    //收藏按钮
    _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(_topImageView.frame.size.width -30 , _topImageView.frame.size.height - 30, 22,22)];
    _checkBox.onAnimationType = BEMAnimationTypeBounce;
    _checkBox.offAnimationType = BEMAnimationTypeBounce;
    _checkBox.delegate = self;
    _checkBox.offFillColor = [UIColor colorWithRed:192/255.f green:192/255.f blue:192/255.f alpha:0.5];
    _checkBox.onTintColor = [UIColor whiteColor];
    _checkBox.onCheckColor = [UIColor whiteColor];
    _checkBox.tintColor = [UIColor whiteColor];
    [self.contentView addSubview:_checkBox];
    

    //应用名称
    _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topImageView.frame.size.height +_topImageView.frame.origin.y + 5 , self.frame.size.width, 20)];
    _botlabel.text = @"这是应用名称";
    _botlabel.textAlignment = NSTextAlignmentCenter;
    _botlabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_botlabel];

}
- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox {


    if (self.favoriteClicked) {
        NSLog(@"现在的状态：%d",checkBox.on);
        self.favoriteClicked(checkBox.on);
    }

}
@end
