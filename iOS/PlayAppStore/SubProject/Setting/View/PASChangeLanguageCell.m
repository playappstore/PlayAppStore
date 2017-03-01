//
//  PASChangeLanguageCell.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASChangeLanguageCell.h"

@implementation PASChangeLanguageCell

+ (instancetype)cellCreatedWithTableView:(UITableView *)tableView{
    static NSString * ID = @"PASChangeLanguageCell";
    PASChangeLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)createSubViews {
    

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
