//
//  HomeNavigationView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/16.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "HomeNavigationView.h"
#import <Masonry.h>

@implementation HomeNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.statusView = [[UIView alloc] init];
        [self addSubview:self.statusView];
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.size.sizeOffset(CGSizeMake(WIDTH, 20));
        }];
        
        self.backgroundView = [[UIView alloc] init];
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView.mas_bottom).offset(0);
            make.left.offset(0);
            make.bottom.offset(0);
            make.right.offset(0);
        }];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.leftBtn];
        [self.leftBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
            make.size.sizeOffset(CGSizeMake(30, 30));
        }];
        self.leftBtn.hidden = YES;
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.rightBtn];
        [self.rightBtn setImage:[UIImage imageNamed:@"setUpImage"] forState:UIControlStateNormal];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.offset(0);
            make.size.sizeOffset(CGSizeMake(30, 30));
        }];
        
        self.titleLabel = [[BaseLabel alloc] init];
        [self.backgroundView addSubview:self.titleLabel];
        self.titleLabel.font = TitleFont;
        self.titleLabel.textColor = TitleColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView.mas_top).offset(0);
            make.left.equalTo(self.leftBtn.mas_right).offset(3);
            make.bottom.equalTo(self.backgroundView.mas_bottom).offset(0);
            make.right.equalTo(self.rightBtn.mas_left).offset(3);
        }];
        
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
