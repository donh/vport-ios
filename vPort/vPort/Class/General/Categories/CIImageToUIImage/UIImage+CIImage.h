//
//  UIImage+CIImage.h
//  VPort
//
//  Created by MengFanJun on 2017/5/26.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CIImage)

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

@end
