//
//  PASApplicationDetailSwitchCell.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//
#import "PASApplicationDetailSwitchCell.h"

@interface PASApplicationDetailSwitchCell()
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UISwitch *connectSwitch;
@property(nonatomic, weak) UIView *seperateLine;
@end

@implementation PASApplicationDetailSwitchCell

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView{
    static NSString * ID = @"PASApplicationDetailSwitchCell";
    PASApplicationDetailSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)init
{
    if(self = [super init]) {
        [self addSubviewsAndLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self addSubviewsAndLayout];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviewsAndLayout];
    }
    return self;
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    self.titleLabel.text = nil;
//}

- (void)addSubviewsAndLayout
{
    self.backgroundColor = RGBCodeColor(0xe6e6e6);
    [self addTitleLabelAndLayout];
    [self addConnectSwitchAndLayout];
    [self addSeperateLineAndLayout];
}

- (void)addTitleLabelAndLayout
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15.];
    titleLabel.text = PASLocalizedString(@"Push notification", nil);
    [self.contentView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@200);
    }];
}

- (void)addConnectSwitchAndLayout
{
    UISwitch *connectSwitch = [UISwitch new];
    connectSwitch.onTintColor = RGBCodeColor(0x26BEFD);
    connectSwitch.tintColor = [UIColor purpleColor];
    [connectSwitch addTarget:self action:@selector(connectSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:connectSwitch];
    
    self.connectSwitch = connectSwitch;
    
    [self.connectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
}

- (void)addSeperateLineAndLayout
{
    UIView *seperateLine = [UIView new];
    seperateLine.backgroundColor = RGBCodeColor(0xe6e6e6);
    
    [self.contentView addSubview:seperateLine];
    self.seperateLine = seperateLine;
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@.5);
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.seperateLine.backgroundColor = RGBCodeColor(0xe6e6e6);
}

#pragma mark - 
- (void)connectSwitchChanged:(id)sender
{
    UISwitch *switchBtn = sender;
    NSLog(@"switch 按钮状态变更为 ： %@", @(switchBtn.on));
    if ([self.delegate respondsToSelector:@selector(switchButtonStateChanged:)]) {
        [self.delegate switchButtonStateChanged:switchBtn.on];
    }
}
@end
