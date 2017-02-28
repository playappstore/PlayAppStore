//
//  PASDisListTableViewCell.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKDownloadButton.h"
#import "UIImage+PKDownloadButton.h"
#import "UIButton+PKDownloadButton.h"
#define PASDisListTableViewCellHeight 120
@interface PASDisListTableViewCell : UITableViewCell <PKDownloadButtonDelegate>
@property (nonatomic ,strong) UIImageView *logoImageView;
//更新时间
@property (nonatomic ,strong) UILabel *upDataTimeLabel;
//版本
@property (nonatomic ,strong) UILabel *versionsLabel;
//描述
@property (nonatomic ,strong) UILabel *describeLabel;
//下载按钮
@property (nonatomic ,strong) PKDownloadButton *downloadButton;
@end

