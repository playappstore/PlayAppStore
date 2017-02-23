//
//  PASApplicationDetailHeadView.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PASApplicationDetailHeadViewDelegate <NSObject>

- (void)backButtonDidTap:(UIButton *)cityButton;
- (void)shareButtonDidTap:(UIButton *)shareButton;

@end

@interface PASApplicationDetailHeadView : UIView

@property (nonatomic, weak) id<PASApplicationDetailHeadViewDelegate> delegate;
/**观察监听的scrollView*/
@property (nonatomic, weak) UIScrollView *scrollView;

@end
