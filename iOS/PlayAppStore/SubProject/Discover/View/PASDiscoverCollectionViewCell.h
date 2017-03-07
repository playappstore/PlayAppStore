//
//  PASDiscoverCollectionViewCell.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
@class PASDiscoverModel;
@interface PASDiscoverCollectionViewCell : UICollectionViewCell<BEMCheckBoxDelegate>

@property (nonatomic ,copy) void (^favoriteClicked)(BOOL selected);
//应用logo
@property (nonatomic ,strong) UIImageView *PAS_AppLogoImageView;
//应用名称
@property (nonatomic ,strong) UILabel *PAS_AppNameLabel;
//收藏按钮
@property (nonatomic ,strong)BEMCheckBox *checkBox;

@end
