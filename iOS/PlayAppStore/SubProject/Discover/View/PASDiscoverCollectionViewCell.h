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
- (void)configViewWithData:(PASDiscoverModel *)model;

@end
