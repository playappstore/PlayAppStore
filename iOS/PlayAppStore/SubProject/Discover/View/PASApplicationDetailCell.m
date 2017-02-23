//
//  PASApplicationDetailCell.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASApplicationDetailCell.h"

@interface PASApplicationDetailCell ()

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *des1;
@property (strong, nonatomic) UILabel *des2;
@property (strong, nonatomic) UILabel *des3;
@property (strong, nonatomic) UIView *grayLine1;

@end

@implementation PASApplicationDetailCell

#pragma mark - 初始化Cell
+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView{
    static NSString * ID = @"PASApplicationDetailCell";
    PASApplicationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.des1];
    [self.contentView addSubview:self.des3];
    [self.contentView addSubview:self.des2];
    self.grayLine1 = [[UIView alloc] init];
    self.grayLine1.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.grayLine1];
    [self setupViewConstraints];
    
    [self configData];
}

- (void)configData {
    self.title.text = @"What's New";
    self.des1.text = @"XXXXXXXXXXXXXXXX";
    self.des2.text = @"EEEEEEEEEEEEEEEE";
    self.des3.text = @"IIIIIIIIIIIIIIIIII";
}

#pragma mark - 添加约束
- (void)setupViewConstraints{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(21.0);
    }];
    
    [self.des1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(17.0);
    }];
    
    [self.des2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.des1);
        make.top.mas_equalTo(self.des1.mas_bottom).with.offset(10.0);
        make.height.mas_equalTo(17.0);
    }];
    
    [self.des3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.des1);
        make.top.mas_equalTo(self.des2.mas_bottom).with.offset(10.0);
        make.height.mas_equalTo(17.0);
    }];
    
    [self.grayLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}


- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:18];
    }
    return _title;
}

- (UILabel *)des1 {
    if (!_des1) {
        _des1 = [[UILabel alloc] init];
        _des1.font = [UIFont systemFontOfSize:14];
    }
    return _des1;
}

- (UILabel *)des2 {
    if (!_des2) {
        _des2 = [[UILabel alloc] init];
        _des2.font = [UIFont systemFontOfSize:14];
    }
    return _des2;
}

- (UILabel *)des3 {
    if (!_des3) {
        _des3 = [[UILabel alloc] init];
        _des3.font = [UIFont systemFontOfSize:14];
    }
    return _des3;
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
