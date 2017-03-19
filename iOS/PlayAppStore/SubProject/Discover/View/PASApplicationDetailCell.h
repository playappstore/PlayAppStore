//
//  PASApplicationDetailCell.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PASDiscoverModel;

@interface PASApplicationDetailCell : UITableViewCell

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView;

- (void)configWithModel:(PASDiscoverModel *)model;

@end
