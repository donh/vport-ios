//
//  AuthorizedIdentityCardView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/27.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "AuthorizedIdentityCardView.h"

@implementation AuthorizedIdentityCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.backgroundView];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.borderWidth = 0.5;
        self.backgroundView.layer.borderColor = LINECOLOR.CGColor;
        
        self.identityCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.identityCardBtn];
        self.identityCardBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.identityCardBtn setImage:[UIImage imageNamed:@"identityCardImage-1"] forState:UIControlStateNormal];
        [self.identityCardBtn setTitle:@"  身份证" forState:UIControlStateNormal];
        [self.identityCardBtn setTitleColor:[UIColor colorWithHexString:@"363636" alpha:1] forState:UIControlStateNormal];
        self.identityCardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
//        self.identityCardImage
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
