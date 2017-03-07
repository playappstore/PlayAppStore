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
#import "PKDownloadButton.h"
#import "UIImage+PKDownloadButton.h"
#import "UIButton+PKDownloadButton.h"
#import "PASDiscoverModel.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface PASDisListTableViewCell () <PKDownloadButtonDelegate>

@property (nonatomic ,strong) UIImageView *logoImageView;
//更新时间
@property (nonatomic ,strong) UILabel *upDataTimeLabel;
//版本
@property (nonatomic ,strong) UILabel *versionsLabel;
//描述
@property (nonatomic ,strong) UILabel *describeLabel;
//下载按钮
@property (nonatomic ,strong) PKDownloadButton *downloadButton;

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

    NSLog(@"%f",self.height);
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    [self.logoImageView zy_cornerRadiusAdvance:10.0 rectCornerType:UIRectCornerAllCorners];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.logoImageView];
    
    //更新时间
    _upDataTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.logoImageView.right + 20, self.logoImageView.top , SCREEN_WIDTH - (self.logoImageView.right + 20) , 15)];
    //_upDataTimeLabel.text = @"更新时间：2017.02.28 10:10";
    _upDataTimeLabel.font = [UIFont systemFontOfSize:13];
    _upDataTimeLabel.textColor = RGBCodeColor(0x666666);
    [self.contentView addSubview:_upDataTimeLabel];
    
    //版本
    _versionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_upDataTimeLabel.left, _upDataTimeLabel.bottom + 10, _upDataTimeLabel.width - 40, _upDataTimeLabel.height)];
    _versionsLabel.textColor = _upDataTimeLabel.textColor;
    _versionsLabel.font = _upDataTimeLabel.font;
    //_versionsLabel.text = @"版本：5.0.1";
    [self.contentView addSubview:_versionsLabel];
    

    //下载按钮
    _downloadButton = [[PKDownloadButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, _upDataTimeLabel.bottom , 100, 30)];
    _downloadButton.backgroundColor = [UIColor clearColor];
    [self.downloadButton.downloadedButton cleanDefaultAppearance];
    [self.downloadButton.downloadedButton setTitle:@"h" forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.downloadButton.stopDownloadButton.tintColor = [UIColor blackColor];
    self.downloadButton.stopDownloadButton.filledLineStyleOuter = YES;
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",PASLocalizedString(@"DOWNLOAD", nil)] attributes:@{ NSForegroundColorAttributeName : [UIColor defaultDwonloadButtonBlueColor],NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
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
    //_describeLabel.text = @"这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容这是更新内容";
    _describeLabel.numberOfLines = 0;
    [self.contentView addSubview:_describeLabel];

}

- (void)configViewWithData:(PASDiscoverModel *)model {
      [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.PAS_AppLogo] placeholderImage:[UIImage imageNamed:@"images-2.jpeg"] options:SDWebImageRefreshCached];
    self.upDataTimeLabel.text = model.PAS_uploadTime;
    self.versionsLabel.text = model.version;
    self.describeLabel.text = model.chengelog;
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
