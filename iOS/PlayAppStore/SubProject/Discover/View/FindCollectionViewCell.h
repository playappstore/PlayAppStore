//
//  FindCollectionViewCell.h
//  collectionView
//
//  Created by cheyipai.com on 2017/2/20.
//  Copyright © 2017年 kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
@interface FindCollectionViewCell : UICollectionViewCell<BEMCheckBoxDelegate>
@property (nonatomic ,strong)UIImageView *topImageView;
@property (nonatomic ,strong)UILabel *botlabel;
@property (nonatomic ,strong)UILabel *timeLabel;
//收藏按钮
@property (nonatomic ,strong)BEMCheckBox *checkBox;
@property (nonatomic ,copy) void (^favoriteClicked)(BOOL selected);
@end
