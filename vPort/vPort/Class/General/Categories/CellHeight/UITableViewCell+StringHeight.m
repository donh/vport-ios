//
//  UITableViewCell+StringHeight.m
//  Mall
//
//  Created by MengFanJun on 2017/3/8.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "UITableViewCell+StringHeight.h"

@implementation UITableViewCell (StringHeight)

/*
 *通过宽度计算高度
 */
- (CGFloat)heightForStr:(NSString *)string width:(CGFloat)width font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

/*
 *通过高度计算宽度
 */
- (CGFloat)widthForStr:(NSString *)string height:(CGFloat)height font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

@end
