//
//  PASApplicationDetailHeadView.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASApplicationDetailHeadView.h"
#import "Masonry.h"

@interface PASApplicationDetailHeadView ()

//icon of Application
@property (nonatomic, strong) UIImageView *titleImageView;
//title of Application
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *wholeImageView;

@end

@implementation PASApplicationDetailHeadView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self addSubviews];
    return self;
}

#pragma mark - lazy load
- (UIView *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"This is title!";
    }
    return _titleLabel;
}
- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        UIImage *titleImg = [UIImage imageNamed:@"pas_160"]; 
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _titleImageView.image = titleImg;
    }
    return _titleImageView;
}
- (UIImageView *)wholeImageView
{
    if (!_wholeImageView) {
        _wholeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _wholeImageView;
}

#pragma mark - private
- (void)addSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.wholeImageView];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.bounds;
    [effectView.contentView addSubview:self.titleImageView];
    [effectView.contentView addSubview:self.titleLabel];
    [self addSubview:effectView];
    self.wholeImageView.image = self.titleImageView.image;
//    effectView.alpha = 1;
    [self addConstraintsOfSubviews];
}

- (void)addConstraintsOfSubviews {
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.width.mas_equalTo(100.0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImageView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.mas_left).with.offset(20);
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
        make.height.mas_equalTo(17.0);
    }];
    
    [self.wholeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

@end
