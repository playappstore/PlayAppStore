//
//  PASFollowTableViewCell.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASFollowTableViewCell.h"
#import "UIImageView+CornerRadius.h"
@implementation PASFollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSuber];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initSuber {

    //竖线
    CGFloat lineheight = 15.0;
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(20,(self.height - lineheight)/2.0, 3, lineheight)];
    lineView.backgroundColor = [UIColor blackColor];
    [lineView zy_cornerRadiusAdvance:200.0 rectCornerType:UIRectCornerAllCorners];
    [self.contentView addSubview:lineView];
    
    //应用名称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + 10, 0, SCREEN_WIDTH - (lineView.right + 10) - 60, self.height)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.text = @"这是应用名称";
    [self.contentView addSubview:_nameLabel];
    
    //更多
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 50, self.height) ;
    [_moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreButton setTitleColor:RGBCodeColor(0x666666) forState:UIControlStateNormal];
    _moreButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_moreButton];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
