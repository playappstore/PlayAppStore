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
    UIImage *image = self.backImage;
    if ([UIScreen mainScreen].bounds.size.width/image.size.width *image.size.height > self.bgImageView.frame.size.height) {
        
        image = [image qmui_imageWithScaleToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width *image.size.height) contentMode:UIViewContentModeScaleAspectFill];
        if (self.bgImageView.frame.size.height <= height) {
           
            if (image.size.height == height) {
                
            }else {
            
                
                image = [image qmui_imageWithClippedRect: CGRectMake(0, (image.size.height - height)/2.0, [UIScreen mainScreen].bounds.size.width, height)];
                image = [image applyDarkEffect];
            }
           
        }else {
            image = [image qmui_imageWithClippedRect: CGRectMake(0, (image.size.height - self.bgImageView.frame.size.height)/2.0, [UIScreen mainScreen].bounds.size.width, self.bgImageView.frame.size.height)];
            image = [image applyDarkEffect];
        }
        
        
    }else {
        
        image = [image qmui_imageWithScaleToSize:CGSizeMake(self.bgImageView.frame.size.height/image.size.height*image.size.width, self.frame.size.height) contentMode:UIViewContentModeScaleAspectFill];
        image = [image qmui_imageWithClippedRect: CGRectMake((image.size.width - [UIScreen mainScreen].bounds.size.width)/2.0, 0, [UIScreen mainScreen].bounds.size.width, self.bgImageView.frame.size.height)];
        image = [image applyDarkEffect];
        
    }
    
    
    self.bgImageView.image = image;
    
}

- (void)setupSubviews {
    //self.clipsToBounds = YES;
    
    self.bgImageView = [UIImageView new];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.clipsToBounds = YES;
    self.iconImageView = [UIImageView new];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.label = [UILabel new];
    self.label.text = @"应用名称";
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.label];
    
    self.testImageView = [UIImageView new];
    [self addSubview:self.testImageView];
    [self.testImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(64);
        make.bottom.offset(0);
    }];
    
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.testImageView.mas_top).offset(-10);
        make.left.right.offset(0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self.label.mas_top).offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.top = make.top.offset(0);
        make.left.right.offset(0);
        self.height = make.height.mas_equalTo(height);
        //make.bottom.equalTo(self.iconImageView.mas_top).offset(-10);
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
    
    
    
    
    image = [image qmui_imageWithScaleToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width *image.size.height) contentMode:UIViewContentModeScaleAspectFill];
    image = [image qmui_imageWithClippedRect: CGRectMake(0, (image.size.height - 160)/2.0, [UIScreen mainScreen].bounds.size.width, 160)];
    image = [image applyDarkEffect];
    
    self.bgImageView.image = image;
    
    self.snap = image;


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
