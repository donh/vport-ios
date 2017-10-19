//
//  ConfirmLoginView.h
//  vPort
//
//  Created by MengFanJun on 2017/6/26.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseView.h"

@class ConfirmLoginView;

@protocol ConfirmLoginViewDelegate <NSObject>
@optional
- (void)confirmLoginView:(ConfirmLoginView *)confirmLoginView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ConfirmLoginView : BaseView

- (ConfirmLoginView *)initWithDelegate:(id)delegate;

@property (nonatomic, assign) id<ConfirmLoginViewDelegate> delegate;
@property (nonatomic, copy) NSString *contentStr;

//显示
- (void)show;
//隐藏
- (void)hide;

@end
