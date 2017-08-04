//
//  UITableViewCell+StringHeight.h
//  Mall
//
//  Created by MengFanJun on 2017/3/8.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (StringHeight)

/*
 *通过宽度计算高度
 */
- (CGFloat)heightForStr:(NSString *)string width:(CGFloat)width font:(UIFont *)font;


/*
 *通过高度计算宽度
 */
- (CGFloat)widthForStr:(NSString *)string height:(CGFloat)height font:(UIFont *)font;

@end
