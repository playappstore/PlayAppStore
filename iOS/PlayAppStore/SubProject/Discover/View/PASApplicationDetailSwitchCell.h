//
//  PASApplicationDetailSwitchCell.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PASApplicationDetailSwitchCellDelegate <NSObject>

- (void)switchButtonStateChanged:(BOOL)state;

@end

@interface PASApplicationDetailSwitchCell : UITableViewCell

@property (nonatomic, weak) id<PASApplicationDetailSwitchCellDelegate> delegate;

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView;

@end
