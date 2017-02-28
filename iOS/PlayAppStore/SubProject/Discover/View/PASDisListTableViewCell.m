//
//  PASDisListTableViewCell.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDisListTableViewCell.h"
#import "UIImageView+CornerRadius.h"
@implementation PASDisListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {


    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self initMySuber];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initMySuber {

    UIImage *topImage = [UIImage imageNamed:@"images-2.jpeg"];
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    [self.logoImageView zy_cornerRadiusAdvance:10.0 rectCornerType:UIRectCornerAllCorners];
    self.logoImageView.image = topImage;
    self.logoImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.logoImageView];
    
    //更新时间
    _upDataTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.logoImageView.right + 20, self.logoImageView.top , SCREEN_WIDTH - (self.logoImageView.right + 20) , 15)];
    _upDataTimeLabel.text = @"2017.02.28";
    _upDataTimeLabel.font = [UIFont systemFontOfSize:13];
    _upDataTimeLabel.textColor = RGBCodeColor(0x666666);
    [self.contentView addSubview:_upDataTimeLabel];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
