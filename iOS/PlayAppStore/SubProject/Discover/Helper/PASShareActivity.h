//
//  PASShareAcrivity.h
//  SocialShareDemo20170221
//
//  Created by Winn on 2017/2/21.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PASShareActivityDelegate <NSObject>

- (void)qrCodeTaped;

@end

@interface PASShareActivity : UIActivity

@property (nonatomic, weak) id <PASShareActivityDelegate> delegate;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) NSArray * shareContexts;

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type  withShareContext:(NSArray *)shareContexts;




@end
