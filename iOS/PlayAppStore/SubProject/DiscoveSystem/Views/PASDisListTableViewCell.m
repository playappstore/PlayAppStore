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

    UIImage *topImage = [UIImage imageNamed:@"Icon-60.png"];
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, topImage.size.width, topImage.size.height)];
    [self.logoImageView zy_cornerRadiusAdvance:10.0 rectCornerType:UIRectCornerAllCorners];
    self.logoImageView.image = topImage;
    [self.contentView addSubview:self.logoImageView];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
