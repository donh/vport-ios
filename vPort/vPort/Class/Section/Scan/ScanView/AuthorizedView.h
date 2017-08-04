//
//  AuthorizedView.h
//  vPort
//
//  Created by MengFanJun on 2017/6/27.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseView.h"

@class AuthorizedView;

@protocol AuthorizedViewDelegate <NSObject>
@optional
- (void)authorizedView:(AuthorizedView *)authorizedView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface AuthorizedView : BaseView

- (AuthorizedView *)initWithDelegate:(id)delegate;

@property (nonatomic, assign) id<AuthorizedViewDelegate> delegate;

//显示
- (void)show;
//隐藏
- (void)hide;

@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSString *webNameStr;


@end
