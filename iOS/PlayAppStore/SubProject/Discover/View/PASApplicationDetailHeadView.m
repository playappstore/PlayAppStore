//
//  PASApplicationDetailHeadView.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASApplicationDetailHeadView.h"
#import "Masonry.h"


#define kDefaultNavTitleViewHeight 44
#define kDefaultStatusBarHeight 20


@interface PASApplicationDetailHeadView ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
//icon of Application
@property (nonatomic, strong) UIImageView *titleImageView;
//title of Application
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) BOOL isCollapsed;//是否收起
@property (nonatomic, assign) CGRect scrollViewOriginalFrame;
@end

@implementation PASApplicationDetailHeadView
#pragma mark - life cycle
- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
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
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 150 - 8 -10, SCREEN_WIDTH - 2 * 15, 20)];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"This is title!";
    }
    return _titleLabel;
}
- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        UIImage *titleImg = [UIImage imageNamed:@"pas_160"]; 
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-titleImg.size.width/2,kDefaultStatusBarHeight+(self.bounds.size.height - titleImg.size.height)/2, titleImg.size.width, titleImg.size.height)];
        _titleImageView.image = titleImg;
    }
    return _titleImageView;
}
- (UIButton *)backButton
{
    if (!_backButton) {
        CGFloat pointX = 15;
        if(SCREEN_WIDTH > 375) {
            pointX += 5;
        }
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(pointX,kDefaultStatusBarHeight, 44, kDefaultNavTitleViewHeight);
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.backgroundColor = [UIColor orangeColor];
        [_backButton setImage:[UIImage imageNamed:@"pas_back"] forState:UIControlStateNormal];
            }
    return _backButton;
}
- (UIButton *)shareButton
{
    if (!_shareButton) {
        UIImage *img = [UIImage imageNamed:@"pas_share"];
        CGSize buttonSize = CGSizeMake(44, 44);//增大点击区域
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat pointX = SCREEN_WIDTH-15- ((buttonSize.width - img.size.width) /2) -img.size.width;
        CGFloat pointY = kDefaultStatusBarHeight+(kDefaultNavTitleViewHeight - buttonSize.height)/2;
        
        if (SCREEN_WIDTH == 375) {
            pointX -= 1;
        }else if (SCREEN_WIDTH > 375){
            pointX -= 5;
            pointY -= 1;
        }
        _shareButton.frame = CGRectMake(pointX,pointY,buttonSize.width,buttonSize.width);
        [_shareButton setImage:img forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.backgroundColor = [UIColor orangeColor];
    }
    return _shareButton;
}

#pragma mark - TapDelegate
- (void)backButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonDidTap:)]) {
        [self.delegate backButtonDidTap:sender];
    }
}

- (void)shareButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonDidTap:)]) {
        [self.delegate shareButtonDidTap:sender];
    }
}


#pragma mark - private
- (void)addSubviews
{
    self.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:self.titleImageView];
    [self addSubview:self.backButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.titleLabel];
    
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.scrollViewOriginalFrame = _scrollView.frame;
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //如果向下滚动到scrollView最底部，就不做任何改变。防止屏幕抖动
    if (self.scrollView.contentSize.height <= self.scrollView.frame.size.height + self.scrollView.contentOffset.y) {
        return;
    }
    CGFloat moveHeight = self.scrollView.contentOffset.y - self.lastContentOffset.y;
    //值是否是增加的(上拉或者下拉)
    BOOL isIncreased = (self.scrollView.contentOffset.y - self.lastContentOffset.y > 0);
    self.lastContentOffset = self.scrollView.contentOffset;
    //
    CGFloat distance = 150 - 64;
    //searchBar参数
    CGFloat searchBarEndPointX = SCREEN_WIDTH > 375 ? 45 : 40;
    CGFloat searchBarMinWidth = SCREEN_WIDTH - (SCREEN_WIDTH > 375 ? 53 : 48) - searchBarEndPointX;
    CGFloat searchBarEndPointY = 64 - self.titleLabel.frame.size.height - 8 -1.5;
    CGFloat searchBarWidthDecreaseRatio = SCREEN_WIDTH > 375 ? 3.0 : 2.5;
    CGFloat searchBarPointXIncreaseRatio = SCREEN_WIDTH > 375 ? 2.2 : 1.8;
    //titleImageView参数
    CGFloat titleImageViewEndPointY = -50;
    //自身高度参数
    CGFloat selfMinHeight = 64;
    //scrollView参数
    CGFloat scrollViewEndPointY = 64;
    CGFloat scrollViewMaxHeight = SCREEN_HEIGHT - 64 - 44;
    
    if (self.scrollView.contentOffset.y > 0 && self.scrollView.contentOffset.y < distance) {
        if (isIncreased) {
            CGRect frame = self.frame;
            if (frame.size.height > selfMinHeight) {
                frame.size.height -= moveHeight;
            }
            frame.size.height = frame.size.height < selfMinHeight ? selfMinHeight : frame.size.height;
            self.frame = frame;
            
            frame = self.scrollView.frame;
            if (frame.origin.y > scrollViewEndPointY) {
                frame.size.height += moveHeight;
                frame.origin.y -= moveHeight;
            }
            frame.origin.y = frame.origin.y < scrollViewEndPointY ? scrollViewEndPointY : frame.origin.y;
            frame.size.height = frame.size.height > scrollViewMaxHeight ? scrollViewMaxHeight : frame.size.height;
            self.scrollView.frame = frame;
            
            frame = self.titleImageView.frame;
            frame.origin.y -= moveHeight;
            frame.origin.y = frame.origin.y < titleImageViewEndPointY ? titleImageViewEndPointY : frame.origin.y;
            self.titleImageView.frame = frame;
            
            self.titleImageView.alpha -= moveHeight / 20;
            
            frame = self.titleLabel.frame;
            if (frame.origin.y > searchBarEndPointY) {
                frame.origin.y -= moveHeight;
            }
            frame.origin.y = frame.origin.y < searchBarEndPointY ? searchBarEndPointY : frame.origin.y;
            if (frame.size.width > searchBarMinWidth) {
                frame.size.width -= searchBarWidthDecreaseRatio * moveHeight;
            }
            frame.size.width = frame.size.width < searchBarMinWidth ? searchBarMinWidth : frame.size.width;
            if (frame.origin.x < searchBarEndPointX) {
                frame.origin.x += searchBarPointXIncreaseRatio * moveHeight;
            }
            frame.origin.x = frame.origin.x > searchBarEndPointX ? searchBarEndPointX : frame.origin.x;
            
            self.titleLabel.frame = frame;
            
            self.isCollapsed = YES;
        }
    }else if (self.scrollView.contentOffset.y >= distance){
        self.isCollapsed = YES;
        CGRect frame = self.frame;
        frame.size.height = selfMinHeight;
        self.frame = frame;
        
        frame = self.scrollView.frame;
        frame.size.height = scrollViewMaxHeight;
        frame.origin.y = scrollViewEndPointY;
        self.scrollView.frame = frame;
        
        frame = self.titleImageView.frame;
        frame.origin.y = titleImageViewEndPointY;
        self.titleImageView.frame = frame;
        
        self.titleImageView.alpha = 0;
        
        frame = self.titleLabel.frame;
        frame.origin.y = searchBarEndPointY;
        frame.size.width = searchBarMinWidth;
        frame.origin.x = searchBarEndPointX;
        self.titleLabel.frame = frame;
        
    }else if(self.isCollapsed && self.scrollView.contentOffset.y <= 10){//复原
        [UIView animateWithDuration:.2f animations:^{
            CGRect frame = self.frame;
            frame.size.height = 150;
            self.frame = frame;
            
            UIImage *titleImg = [UIImage imageNamed:@"pas_160"];
            frame = self.titleImageView.frame;
            frame.origin.y = kDefaultStatusBarHeight+(self.bounds.size.height - titleImg.size.height)/2;
            self.titleImageView.frame = frame;
            
            self.titleImageView.alpha = 1;
            
            frame = self.titleLabel.frame;
            frame.origin.y = 150 - 8 -10;
            frame.size.width = SCREEN_WIDTH - 2 * 15;
            frame.origin.x = 15;
            self.titleLabel.frame = frame;
            
            self.scrollView.frame = self.scrollViewOriginalFrame;
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.isCollapsed = NO;
        }];
    }
}

@end
