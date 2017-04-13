//
//  PASApplicationDetailCell.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASApplicationDetailCell.h"
#import "PASDiscoverModel.h"

@interface PASApplicationDetailCell ()

@property (strong, nonatomic) UILabel *pasTitleLabel;
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
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
//    self.grayLine1 = [[UIView alloc] init];
//    self.grayLine1.backgroundColor = [UIColor grayColor];
//    [self.contentView addSubview:self.grayLine1];
    [self setupViewConstraints];
}
- (void)configWithModel:(PASDiscoverModel *)model index:(int)index{
    if (index == 1) {
        
        self.pasTitleLabel.text = @"Changelog";
        self.des1.text = model.changelog;
    }else if(index == 2) {
         self.pasTitleLabel.text = @"LastCommitMessage";
        self.des1.text = model.lastCommitMsg;
    }else {
    
        self.pasTitleLabel.text = @"Information";
        NSString *str = [NSString stringWithFormat:@"Update:%@\nVersion:%@\nSize:%@", model.updatedAt,model.version,model.size];
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:str];
       
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,str.length)];
        self.des1.attributedText = att;
    }
}

#pragma mark - 添加约束
- (void)setupViewConstraints{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
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
//        make.height.mas_equalTo(17.0);
    }];
    
//    [self.des2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self.des1);
//        make.top.mas_equalTo(self.des1.mas_bottom).with.offset(10.0);
//        make.height.mas_equalTo(17.0);
//    }];
    
//    [self.des3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self.des1);
//        make.top.mas_equalTo(self.des2.mas_bottom).with.offset(10.0);
//        make.height.mas_equalTo(17.0);
//    }];
//    
//    [self.grayLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom);
//        make.height.mas_equalTo(0.5);
//    }];
}


- (UILabel *)title {
    if (!_pasTitleLabel) {
        _pasTitleLabel = [[UILabel alloc] init];
        _pasTitleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _pasTitleLabel;
}

- (UILabel *)des1 {
    if (!_des1) {
        _des1 = [[UILabel alloc] init];
        _des1.font = [UIFont systemFontOfSize:14];
        _des1.numberOfLines = 0;
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

- (CGSize)sizeThatFits:(CGSize)size {

    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat contentLabelWidth = size.width - 30;
    CGFloat resultHeight = 0;
    
    if (self.pasTitleLabel.text.length > 0) {
        CGSize contentSize = [self.pasTitleLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += contentSize.height + 10;
    }
    
    if (self.des1.text.length > 0) {
        CGSize timeSize = [self.des1 sizeThatFits:CGSizeMake(contentLabelWidth - 10, CGFLOAT_MAX)];
        resultHeight += timeSize.height + 18;
    }
    
    resultSize.height = resultHeight;
    return resultSize;

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
