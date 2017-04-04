//
//  PASTextLabelCell.h
//  PlayAppStore
//
//  Created by Winn on 2017/3/3.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASTextLabelCell : UITableViewCell

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) UILabel *des1;


@end
