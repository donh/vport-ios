//
//  PassWordView.h
//  VPort
//
//  Created by MengFanJun on 2017/6/14.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseView.h"

@class PassWordView;

@protocol  PassWordViewDelegate<NSObject>

@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(PassWordView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(PassWordView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(PassWordView *)passWord;


@end

IB_DESIGNABLE

@interface PassWordView : BaseView <UIKeyInput>

@property (assign, nonatomic) NSUInteger passWordNum;//密码的位数
@property (assign, nonatomic) CGFloat squareWidth;//正方形的大小
@property (assign, nonatomic) CGFloat pointRadius;//黑点的半径
@property (strong, nonatomic) UIColor *pointColor;//黑点的颜色
@property (strong, nonatomic) UIColor *rectColor;//边框的颜色
@property (weak, nonatomic) id<PassWordViewDelegate> delegate;
@property (strong, nonatomic, readonly) NSMutableString *textStore;//保存密码的字符串
- (void)clearText;

@end
