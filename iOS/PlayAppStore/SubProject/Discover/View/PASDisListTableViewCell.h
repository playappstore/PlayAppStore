//
//  PASDisListTableViewCell.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>


#define PASDisListTableViewCellHeight 120
@class PASDiscoverModel;
@interface PASDisListTableViewCell : UITableViewCell 

- (void)configViewWithData:(PASDiscoverModel *)model;

@end

