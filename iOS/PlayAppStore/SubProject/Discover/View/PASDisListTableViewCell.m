//
//  PASDisListTableViewCell.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDisListTableViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "UIColor+PKDownloadButton.h"
#import <Masonry/Masonry.h>

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

    NSLog(@"%f",self.height);
    UIImage *topImage = [UIImage imageNamed:@"images-2.jpeg"];
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    [self.logoImageView zy_cornerRadiusAdvance:10.0 rectCornerType:UIRectCornerAllCorners];
    self.logoImageView.image = topImage;
    self.logoImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.logoImageView];
    
    //更新时间
    _upDataTimeLabel = [[UILabel alloc] init];
//                        WithFrame:CGRectMake(self.logoImageView.right + 20, self.logoImageView.top , SCREEN_WIDTH - (self.logoImageView.right + 20) , 15)];
    _upDataTimeLabel.text = @"更新时间：2017.02.28 10:10 2234444444";
    _upDataTimeLabel.font = [UIFont systemFontOfSize:13];
    _upDataTimeLabel.textColor = RGBCodeColor(0x666666);
    [self.contentView addSubview:_upDataTimeLabel];
    
    //版本
    _versionsLabel = [[UILabel alloc] init];
//                      .WithFrame:CGRectMake(_upDataTimeLabel.left, _upDataTimeLabel.bottom + 10, _upDataTimeLabel.width - 40, _upDataTimeLabel.height)];
    _versionsLabel.textColor = _upDataTimeLabel.textColor;
    _versionsLabel.font = _upDataTimeLabel.font;
    _versionsLabel.text = @"版本：5.0.1";
    [self.contentView addSubview:_versionsLabel];
    

    //下载按钮
    _downloadButton = [[PKDownloadButton alloc] init];
    _downloadButton.backgroundColor = [UIColor clearColor];
    [self.downloadButton.downloadedButton cleanDefaultAppearance];
    [self.downloadButton.downloadedButton setTitle:@"h" forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.downloadButton.stopDownloadButton.tintColor = [UIColor blackColor];
    self.downloadButton.stopDownloadButton.filledLineStyleOuter = YES;
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",NSLocalizedString(@"DOWNLOAD", nil)] attributes:@{ NSForegroundColorAttributeName : [UIColor defaultDwonloadButtonBlueColor],NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    self.downloadButton.startDownloadButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self.downloadButton.startDownloadButton setAttributedTitle:title forState:UIControlStateNormal];
    self.downloadButton.pendingView.tintColor = [UIColor defaultDwonloadButtonBlueColor];
    self.downloadButton.stopDownloadButton.tintColor = [UIColor defaultDwonloadButtonBlueColor];
    self.downloadButton.pendingView.radius = 14.f;
    self.downloadButton.pendingView.emptyLineRadians = 1.f;
    self.downloadButton.pendingView.spinTime = 3.f;
    self.downloadButton.delegate = self;
    [self.contentView addSubview:_downloadButton];
    
    //更新能容
    _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_upDataTimeLabel.left, self.downloadButton.bottom + 5, SCREEN_WIDTH -_upDataTimeLabel.left - 10 , PASDisListTableViewCellHeight -self.downloadButton.bottom - 10 )];
    _describeLabel.textColor = _upDataTimeLabel.textColor;
    _describeLabel.font = _upDataTimeLabel.font;
//    _describeLabel.text = @"这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容";
    _describeLabel.numberOfLines = 0;
    [self.contentView addSubview:_describeLabel];
//    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(-14);
//        make.height.mas_equalTo(30);
//        make.centerY.equalTo(self.contentView);
//    }];
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

    


}
- (void)downloadButtonTapped:(PKDownloadButton *)downloadButton
                currentState:(PKDownloadButtonState)state {
    switch (state) {
        case kPKDownloadButtonState_StartDownload:
            self.downloadButton.state = kPKDownloadButtonState_Pending;
//            [self.pendingSimulator startDownload];
            [self performSelector:@selector(delay3:) withObject:downloadButton afterDelay:3];
            break;
        case kPKDownloadButtonState_Pending:
//            [self.pendingSimulator cancelDownload];
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case kPKDownloadButtonState_Downloading:
//            [self.downloaderSimulator cancelDownload];
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case kPKDownloadButtonState_Downloaded:
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            self.imageView.hidden = YES;
            break;
        default:
            NSAssert(NO, @"unsupported state");
            break;
    }
}
- (void)delay3:(PKDownloadButton *)downloadButton {

    downloadButton.state = kPKDownloadButtonState_Downloading;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
