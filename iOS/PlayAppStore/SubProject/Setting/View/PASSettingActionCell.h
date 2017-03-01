//
//  PASSettingActionCell.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/28.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASSettingActionCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
// 内容栏
@property (nonatomic, strong) UILabel *detailLabel;

// 第一个cell 显示topLine
@property (nonatomic, assign) BOOL isFirstCell;
// 最后一个cell 显示bottomLine
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, assign) BOOL showIndicator;

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView;

@end
