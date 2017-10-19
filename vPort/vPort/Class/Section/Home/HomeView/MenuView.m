//
//  MenuView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/16.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self addSubview:self.menuImage];
        self.menuImage.center = CGPointMake(frame.size.width / 2, frame.size.height / 2 - 10);
        self.menuImage.contentMode = UIViewContentModeScaleAspectFill;
        
        self.menuTitle = [[BaseLabel alloc] initWithFrame:CGRectMake(0, self.menuImage.frame.size.height + self.menuImage.frame.origin.y + 18, frame.size.width, 14)];
        [self addSubview:self.menuTitle];
        self.menuTitle.textColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
        self.menuTitle.textAlignment = NSTextAlignmentCenter;
        self.menuTitle.font = [UIFont systemFontOfSize:13];
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
