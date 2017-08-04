//
//  AuthorizedIdentityCardView.h
//  vPort
//
//  Created by MengFanJun on 2017/6/27.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseView.h"

@interface AuthorizedIdentityCardView : BaseView

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *identityCardImage;
@property (nonatomic, strong) BaseLabel *identityCardLabel;
@property (nonatomic, strong) UIButton *identityCardBtn;

@end
