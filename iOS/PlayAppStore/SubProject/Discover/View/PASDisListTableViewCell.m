//
//  PASDisListTableViewCell.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDisListTableViewCell.h"


@interface PASDisListTableViewCell () <PKDownloadButtonDelegate>
@end


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

    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    [self.logoImageView zy_cornerRadiusAdvance:10.0 rectCornerType:UIRectCornerAllCorners];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.logoImageView];
    
    //更新时间
    _upDataTimeLabel = [[UILabel alloc] init];
    _upDataTimeLabel.font = [UIFont systemFontOfSize:15];
    _upDataTimeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_upDataTimeLabel];
    
    //版本
    _versionsLabel = [[UILabel alloc] init];
    _versionsLabel.textColor = RGBCodeColor(0x666666);
    _versionsLabel.font = _upDataTimeLabel.font;
    [self.contentView addSubview:_versionsLabel];
    

    //下载按钮
    _downloadButton = [[PKDownloadButton alloc] init];
    _downloadButton.backgroundColor = [UIColor clearColor];
    [self.downloadButton.downloadedButton cleanDefaultAppearance];
    [self.downloadButton.downloadedButton setTitle:NSLocalizedString(@"OPEN", nil) forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor defaultDwonloadButtonBlueColor] forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.downloadButton.stopDownloadButton.tintColor = [UIColor blackColor];
    self.downloadButton.stopDownloadButton.filledLineStyleOuter = NO;
    self.downloadButton.startDownloadButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",PASLocalizedString(@"DOWNLOAD", nil)] attributes:@{ NSForegroundColorAttributeName : [UIColor defaultDwonloadButtonBlueColor],NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    [self.downloadButton.startDownloadButton setAttributedTitle:title forState:UIControlStateNormal];
    self.downloadButton.pendingView.tintColor = [UIColor defaultDwonloadButtonBlueColor];
    self.downloadButton.stopDownloadButton.tintColor = [UIColor defaultDwonloadButtonBlueColor];
    self.downloadButton.pendingView.radius = 14.f;
    self.downloadButton.pendingView.emptyLineRadians = 1.f;
    self.downloadButton.pendingView.spinTime = 3.f;
    self.downloadButton.delegate = self;
    [self.contentView addSubview:_downloadButton];
    
    //更新内容
    _describeLabel = [[UILabel alloc] init];
    _describeLabel.textColor = RGBCodeColor(0x666666);
    _describeLabel.font = _upDataTimeLabel.font;
    _describeLabel.numberOfLines = 0;
    [self.contentView addSubview:_describeLabel];
    [self PAS_mas_makeConstraints];

}
- (void)PAS_mas_makeConstraints {

    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.logoImageView);
    }];
    [self.upDataTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.downloadButton.mas_left).offset(- 10).priorityLow();
        make.top.equalTo(self.logoImageView.mas_top);
        make.left.equalTo(self.logoImageView.mas_right).offset(20);
    }];
    [self.versionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upDataTimeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.upDataTimeLabel.mas_left);
    }];

    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);

    }];

}
- (void)downloadButtonTapped:(PKDownloadButton *)downloadButton
                currentState:(PKDownloadButtonState)state {
    switch (state) {
        case kPKDownloadButtonState_StartDownload:
            self.downloadButton.state = kPKDownloadButtonState_Pending;
            if (self.downloadClicked) {
                self.downloadClicked (self.downloadButton.state);
            }
            break;
        case kPKDownloadButtonState_Pending:
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case kPKDownloadButtonState_Downloading:
//            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case kPKDownloadButtonState_Downloaded:
            if (self.downloadClicked) {
                self.downloadClicked (self.downloadButton.state);
            }
//            self.imageView.hidden = YES;
            break;
        default:
            NSAssert(NO, @"unsupported state");
            break;
    }
}
- (void)setValueWithUploadTime:(NSString *)uploadTime
                       version:(NSString *)version
                     changelog:(NSString *)changelog
                       iconUrl:(NSString *)iconUrl  {

    self.upDataTimeLabel.text = [NSString stringWithFormat:@"更新时间：%@", uploadTime];
    self.versionsLabel.text = [NSString stringWithFormat:@"版本：%@", version];
    self.describeLabel.text = changelog;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
