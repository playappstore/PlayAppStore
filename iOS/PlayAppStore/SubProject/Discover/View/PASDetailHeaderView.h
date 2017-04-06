//
//  PASDetailHeaderView.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/4/6.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASDetailHeaderView : UIView
- (void)addScrollview:(UIScrollView *)scrollView;
- (void)headerRemoveOber;
@property (nonatomic, strong) UIImage *snap;
@property (nonatomic ,strong) UIImage *logoImage;
@property (nonatomic, strong) UILabel *label;


@end
