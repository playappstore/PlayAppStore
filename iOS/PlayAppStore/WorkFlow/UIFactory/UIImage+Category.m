//
//  UIImage+Category.m
//  SocialShareDemo20170221
//
//  Created by Winn on 2017/2/24.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    //Plan B
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    
//    // 1. 创建bitmap
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    
//    // 2.保存bitmap图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
    
    //Plan A
    CGRect rect  = CGRectInset(image.extent, 1, 1);
    CIImage *outputImage = [image imageByCroppingToRect:rect];
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    
    UIGraphicsBeginImageContext(start_image.size);
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    UIImage *icon_image = [UIImage imageNamed:@"logoimage"];
    CGFloat icon_imageWH = start_image.size.width * 0.2;
    CGFloat icon_imageXY = (start_image.size.width - icon_imageWH) * 0.5;
    [icon_image drawInRect:CGRectMake(icon_imageXY, icon_imageXY, icon_imageWH, icon_imageWH)];
    
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final_image;
}

@end
