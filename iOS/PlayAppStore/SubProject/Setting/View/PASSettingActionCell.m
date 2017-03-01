//
//  PASSettingActionCell.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/28.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASSettingActionCell.h"

@interface PASSettingActionCell ()


@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;


@end

@implementation PASSettingActionCell

#pragma mark - 初始化Cell
+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView{
    static NSString * ID = @"PASSettingActionCell";
    PASSettingActionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    // indicatorImageView
    UIImage *indicatorImage = [UIImage imageNamed:@"oc_cm_youjiantou"];
    CGSize indicatorSize = indicatorImage.size;
    UIImageView *indicator = [[UIImageView alloc] init];
    indicator.image = indicatorImage;
    indicator.hidden = NO;
    self.indicatorImageView = indicator;
    [self addSubview:self.indicatorImageView];
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.equalTo([NSNumber numberWithDouble:indicatorSize.width]);
        make.height.equalTo([NSNumber numberWithDouble:indicatorSize.height]);
    }];

    // detailLabel
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    self.detailLabel = detailLabel;
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.indicatorImageView.mas_left).offset(-3);
        make.centerY.mas_equalTo(self.contentView);
        make.width.equalTo(@80);
        make.height.equalTo(@17);
    }];
    
    // topLine
    self.topLineView = [[UIView alloc] init];
    self.topLineView.hidden = YES;
    self.topLineView.backgroundColor = RGBCodeColor(0xe6e6e6);
    [self addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    // bottomLine
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.hidden = NO;
    self.bottomLineView.backgroundColor = RGBCodeColor(0xe6e6e6);
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];

}

- (void)setIsFirstCell:(BOOL)isFirstCell
{
    _isFirstCell = isFirstCell;
    _topLineView.hidden = NO;
}

- (void)setIsLastCell:(BOOL)isLastCell
{
    _isLastCell = isLastCell;
    
    _bottomLineView.frame = CGRectMake(0, self.height-1, self.width, 1);
}

- (void)setShowIndicator:(BOOL)showIndicator
{
    _showIndicator = showIndicator;
    if (showIndicator) {
        return;
    } else {
        _indicatorImageView.hidden = YES;
        
    }
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
