//
//  PASDetailHeaderView.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/4/6.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDetailHeaderView.h"
#import "Masonry.h"
#import "UIImage+QMUI.h"
#import "UIImage+ImageEffects.h"
static CGFloat height = 160;
@interface PASDetailHeaderView ()

@property (nonatomic, weak) UIScrollView *scrollView;


@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIImageView *testImageView;

@property (nonatomic, strong) MASConstraint *top;
@property (nonatomic, strong) MASConstraint *height;
@property (nonatomic ,strong) UIImage *backImage;
@end
@implementation PASDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupSubviews];
    return self;
}

- (void)addScrollview:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.scrollView.contentOffset.y >self.frame.size.height) {
        return;
    }
    
    if (self.scrollView.contentOffset.y < 0) {
        
        CGFloat offset = -self.scrollView.contentOffset.y;
        [self.top setOffset:-offset];
        self.height.mas_equalTo(height+offset);
        
    } else {
        [self.top setOffset:0];
        self.height.mas_equalTo(height);
    }
//    UIImage *image = self.backImage;
//    if ([UIScreen mainScreen].bounds.size.width/image.size.width *image.size.height > self.bgImageView.frame.size.height) {
//        
//        image = [image qmui_imageWithScaleToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width *image.size.height) contentMode:UIViewContentModeScaleAspectFill];
//        if (self.bgImageView.frame.size.height <= height) {
//            
//            image = [image qmui_imageWithClippedRect: CGRectMake(0, (image.size.height - height)/2.0, [UIScreen mainScreen].bounds.size.width, height)];
//        }else {
//            image = [image qmui_imageWithClippedRect: CGRectMake(0, (image.size.height - self.bgImageView.frame.size.height)/2.0, [UIScreen mainScreen].bounds.size.width, self.bgImageView.frame.size.height)];
//        }
//        
//        
//    }else {
//        
//        image = [image qmui_imageWithScaleToSize:CGSizeMake(self.bgImageView.frame.size.height/image.size.height*image.size.width, self.frame.size.height) contentMode:UIViewContentModeScaleAspectFill];
//        image = [image qmui_imageWithClippedRect: CGRectMake((image.size.width - [UIScreen mainScreen].bounds.size.width)/2.0, 0, [UIScreen mainScreen].bounds.size.width, self.bgImageView.frame.size.height)];
//        
//    }
//    
//    image = [image applyDarkEffect];
//    
//    self.bgImageView.image = image;
    
}

- (void)setupSubviews {
    //self.clipsToBounds = YES;
    
    self.bgImageView = [UIImageView new];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    self.iconImageView = [UIImageView new];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.label = [UILabel new];
    self.label.text = @"应用名称";
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    
    //下载按钮
    _downloadButton = [[PKDownloadButton alloc] init];
    _downloadButton.backgroundColor = [UIColor clearColor];
    [self.downloadButton.downloadedButton cleanDefaultAppearance];
    [self.downloadButton.downloadedButton setTitle:NSLocalizedString(@"OPEN", nil) forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor defaultDwonloadButtonBlueColor] forState:UIControlStateNormal];
    [self.downloadButton.downloadedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.downloadButton.stopDownloadButton.tintColor = [UIColor blackColor];
    self.downloadButton.stopDownloadButton.filledLineStyleOuter = NO;
    self.downloadButton.startDownloadButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",PASLocalizedString(@"DOWNLOAD", nil)] attributes:@{ NSForegroundColorAttributeName : [UIColor defaultDwonloadButtonBlueColor],NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    [self.downloadButton.startDownloadButton setAttributedTitle:title forState:UIControlStateNormal];
    self.downloadButton.pendingView.tintColor = [UIColor defaultDwonloadButtonBlueColor];
    self.downloadButton.stopDownloadButton.tintColor = [UIColor defaultDwonloadButtonBlueColor];
    self.downloadButton.pendingView.radius = 14.f;
    self.downloadButton.pendingView.emptyLineRadians = 1.f;
    self.downloadButton.pendingView.spinTime = 3.f;
    self.downloadButton.delegate = self;
    [self addSubview:_downloadButton];
    
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.label];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.top = make.top.offset(0);
        make.left.right.offset(0);
        self.height = make.height.mas_equalTo(height);
        //make.bottom.equalTo(self.iconImageView.mas_top).offset(-10);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self);
    }];

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.left.right.offset(0);
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self);
    }];
 
}
-(void)setLogoImage:(UIImage *)logoImage {
    UIImage *image = logoImage;
    self.iconImageView.image = image;
    
    if (image.size.width == 120) {
        // 当 width = 120时，试图裁剪掉圆角矩形
        image = [image qmui_imageWithClippedRect:CGRectMake(10, 10, 100, 100)];
    }
    if (image.size.width == 180) {
        // 当 width = 180时，试图裁剪掉圆角矩形
        image = [image qmui_imageWithClippedRect:CGRectMake(15, 15, 150, 150)];
    }
    self.backImage = image;
    image = [image applyDarkEffect];
    self.bgImageView.image = image;
    
    
    image = [image qmui_imageWithScaleToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width *image.size.height) contentMode:UIViewContentModeScaleAspectFill];
    
    image = [image qmui_imageWithClippedRect: CGRectMake(0, (image.size.height - 160)/2.0, [UIScreen mainScreen].bounds.size.width, 160)];
    
    self.snap = image;


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

- (void)headerRemoveOber {

     [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];

}
-(void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
