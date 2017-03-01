//
//  FFFPOnePickerAcrionSheet.m
//  PersonaInformationDemo
//
//  Created by He Wei on 6/5/16.
//  Copyright © 2016 Winn.He. All rights reserved.
//

#import "PASQRCodeActionSheet.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+Category.h"
#import "Masonry.h"

@interface PASQRCodeActionSheet ()

@property (nonatomic, strong) UIImageView *qrCodeView;
@property (nonatomic, strong) UILabel *saveLabel;
@property (nonatomic, strong) UIImageView *saveImageView;
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) UILabel *shareLabel;

@end

@implementation PASQRCodeActionSheet

- (id)initWithDownloadURLString:(NSString *)downloadString {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        UIButton *maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        maskButton.frame = self.bounds;
        maskButton.backgroundColor = RGBCodeColor(0xe6e6e6);
        [maskButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maskButton];
        
        UIImageView *qrImageView = [[UIImageView alloc] init];
        self.qrCodeView = qrImageView;
        [self addSubview:self.qrCodeView];
        [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@200);
        }];
        
        UILabel *saveLabel = [[UILabel alloc] init];
        saveLabel.text = @"save";
        saveLabel.font = [UIFont systemFontOfSize:14];
        self.saveLabel = saveLabel;
        [self addSubview:self.saveLabel];

        UIImageView *saveImageView = [[UIImageView alloc] init];
        saveImageView.backgroundColor = [UIColor orangeColor];
        self.saveImageView = saveImageView;
        [self addSubview:self.saveImageView];
        [self.saveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-50);
            make.left.equalTo(self.mas_centerX).offset(-150);
            make.width.height.equalTo(@40);
        }];
        
        [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.saveImageView);
            make.left.equalTo(self.saveImageView.mas_right).offset(3);
            make.height.equalTo(@17);
            make.width.equalTo(@50);
        }];

        UILabel *shareLabel = [[UILabel alloc] init];
        shareLabel.text = @"share";
        shareLabel.font = [UIFont systemFontOfSize:14];
        self.shareLabel = shareLabel;
        [self addSubview:self.shareLabel];
        
        UIImageView *shareImageView = [[UIImageView alloc] init];
        shareImageView.backgroundColor = [UIColor orangeColor];
        self.shareImageView = shareImageView;
        [self addSubview:self.shareImageView];
        [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-50);
            make.left.equalTo(self.mas_centerX).offset(90);
            make.width.height.equalTo(@40);
        }];
        
        [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.shareImageView);
            make.left.equalTo(self.shareImageView.mas_right).offset(3);
            make.height.equalTo(@17);
            make.width.equalTo(@50);
        }];

        [self creatPASQRCodeImageWithURLString:downloadString];

    }
    return self;
}

- (void)creatPASQRCodeImageWithURLString:(NSString *)downloadString {
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    //    NSString *dataString = @"http://7xrm0o.com1.z0.glb.clouddn.com/publictransport.jpg";
    NSString *dataString = @"https://github.com/endust";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.qrCodeView.image = [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:250];
    
}

- (void)show {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.hidden = NO;

    CGRect temp = self.frame;
    temp.origin.y = SCREEN_HEIGHT;
    self.frame = temp;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2f animations:^{
    
    } completion:^(BOOL finished) {
        
        if (finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }
    }];
}

- (void)doneButtonClicked:(id)sender {
    [self hide];
}

@end
