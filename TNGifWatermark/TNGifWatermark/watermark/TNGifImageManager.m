//
//  TNGifImageManager.m
//
//
//  Created by neon on 2020/3/19.
//  Copyright © 2020 hunantv. All rights reserved.
//

#import "TNGifImageManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation TNGifImageManager


+ (NSArray *)convertToImageList:(NSURL *)gifURL {
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifURL, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        if (i%2 != 0) { //减少图片数量，可注释
            continue;
        }
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
    }
    return frames;
}


+ (NSData *)generateGifWithImageList:(NSArray *)sourceImageList {
    NSMutableData *gifData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)gifData, kUTTypeGIF, sourceImageList.count, NULL);
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.001f], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];

    for (UIImage *sourceImage in sourceImageList) {
        CGImageDestinationAddImageAndMetadata(destination, sourceImage.CGImage, nil, (__bridge CFDictionaryRef)frameProperties);
    }
    
    CGImageDestinationSetProperties(destination, nil);
    BOOL success = CGImageDestinationFinalize(destination);
    if (!success) {
        NSLog(@"合成失败");
    }
    CFRelease(destination);
    return gifData;
}


+ (UIImage *)compositeMarkImage:(UIImage *)markImage sourceImage:(UIImage *)sourceImage canvasSize:(CGSize)canvasSize {
    UIGraphicsBeginImageContextWithOptions(canvasSize, true, [UIScreen mainScreen].scale);
    CGRect canvasBounds = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    [sourceImage drawInRect:canvasBounds];
    [markImage drawInRect:canvasBounds];

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    #if DEBUG
        UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);//开发用于验证
    #endif
    UIGraphicsEndImageContext();
    return resultImage;

}

+ (NSData *)embedWaterMarkImage:(UIImage *)markImage toGif:(NSURL *)gifURL canvasSize:(CGSize)canvasSize {
    NSArray *sourceImageList = [TNGifImageManager convertToImageList:gifURL];
    NSMutableArray *generateGifImageList = [NSMutableArray array];
    for (UIImage *sourceImage in sourceImageList) {
        UIImage *image = [TNGifImageManager compositeMarkImage:markImage sourceImage:sourceImage canvasSize:canvasSize];
        [generateGifImageList addObject:image];
    }
    
    NSData *gifData = [TNGifImageManager generateGifWithImageList:generateGifImageList];
    return gifData;
}

@end
