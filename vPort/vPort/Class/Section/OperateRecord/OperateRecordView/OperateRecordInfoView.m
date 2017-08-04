//
//  OperateRecordInfoView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/28.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "OperateRecordInfoView.h"

@implementation OperateRecordInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.backgroundView];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.borderWidth = 0.5;
        self.backgroundView.layer.borderColor = LINECOLOR.CGColor;
//        self.backgroundView.layer.cornerRadius = 4;
        
        self.titleLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(5, 0, 80, frame.size.height)];
        [self.backgroundView addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];
//        self.titleLabel.text = @"登录昵称：";
        
        self.contentLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x + 5, 0, frame.size.width - (self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x + 5) - 5, frame.size.height)];
        [self.backgroundView addSubview:self.contentLabel];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];
//        self.contentLabel.text = @"A应用";
        
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
