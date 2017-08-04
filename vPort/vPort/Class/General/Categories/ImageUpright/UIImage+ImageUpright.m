/*
 * Copyright (C) 2016-2016, The Little-Sparkle Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS-IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "UIImage+ImageUpright.h"

@implementation UIImage (ImageUpright)

- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
    
}

- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)cornerRadius {
//    CGFloat w = self.size.width;
//    CGFloat h = self.size.height;
    CGFloat w = 20;
    CGFloat h = 20;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (cornerRadius < 0)
        cornerRadius = 0;
    else if (cornerRadius > MIN(w, h))
        cornerRadius = MIN(w, h) / 2.;
    
    UIImage *image = nil;
//    CGRect imageFrame = CGRectMake(0., 0, w, h);
    CGRect imageFrame = CGRectMake(self.size.width / 2 - w / 2, self.size.height / 2 - h / 2, w, h);//让图片绘制在最中心
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:cornerRadius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//图片重新绘制，达到旋转的功能
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees image:(UIImage *)image
{
    //    image = [UIImage imageNamed:@"userPosition"];
    degrees = M_PI * degrees / 180;
//    UIImage *image = [UIImage imageNamed:@"moveCar"];
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    //    UIGraphicsBeginImageContext(rotatedSize);
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, image.scale);
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    
    //   // Rotate the image context
    //    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    CGContextRotateCTM(bitmap, degrees);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    
    
    CGContextDrawImage(bitmap, CGRectMake(-(image.size.width) / 2, -(image.size.height)/ 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //    CGContextRelease(bitmap);
    
    return newImage;
    
}

@end
