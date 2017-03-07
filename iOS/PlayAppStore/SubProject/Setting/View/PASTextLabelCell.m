//
//  PASTextLabelCell.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/3.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASTextLabelCell.h"

@interface PASTextLabelCell ()

@end

@implementation PASTextLabelCell

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView{
    static NSString * ID = @"PASTextLabelCell";
    PASTextLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        self.backgroundView = [[UIImageView alloc] init];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    [self.contentView addSubview:self.des1];
    [self setupViewConstraints];
}

#pragma mark - 添加约束
- (void)setupViewConstraints{
    [self.des1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-20);
    }];
}

- (UILabel *)des1 {
    if (!_des1) {
        _des1 = [[UILabel alloc] init];
        _des1.font = [UIFont systemFontOfSize:14];
        _des1.textColor = RGBCodeColor(0x666666);
        _des1.numberOfLines = 0;
    }
    return _des1;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
