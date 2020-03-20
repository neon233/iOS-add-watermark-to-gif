//
//  TNGifImageManager.h
//  
//
//  Created by neon on 2020/3/19.
//  Copyright © 2020 hunantv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TNGifImageManager : NSObject

/// 合并图片
/// @param markImage 水印图片
/// @param sourceImage 原图片
/// @param canvasSize 画布大小
+ (UIImage *)compositeMarkImage:(UIImage *)markImage sourceImage:(UIImage *)sourceImage canvasSize:(CGSize)canvasSize;


/// gif转成图片数组
/// @param gifURL gif文件路径
+ (NSArray *)convertToImageList:(NSURL *)gifURL;

/// 生成gif
/// @param sourceImageLis 图片数组
+ (NSData *)generateGifWithImageList:(NSArray *)sourceImageLis;

/// 新增水印到gif
/// @param markImage 水印图片
/// @param gifURL gif文件
/// @param canvasSize 画布大小
+ (NSData *)embedWaterMarkImage:(UIImage *)markImage toGif:(NSURL *)gifURL canvasSize:(CGSize)canvasSize;


@end

NS_ASSUME_NONNULL_END
