//
//  HomeScanView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/16.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "HomeScanView.h"
#import "ScanViewController.h"

@implementation HomeScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 104, 96)];
        [self addSubview:self.menuImage];
        self.menuImage.contentMode = UIViewContentModeScaleAspectFill;
        self.menuImage.image = [UIImage imageNamed:@"scanImage"];
        
        self.menuTitle = [[BaseLabel alloc] initWithFrame:CGRectMake(0, self.menuImage.frame.size.height + self.menuImage.frame.origin.y + 18, frame.size.width, 14)];
        [self addSubview:self.menuTitle];
        self.menuTitle.textColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
        self.menuTitle.textAlignment = NSTextAlignmentCenter;
        self.menuTitle.font = [UIFont systemFontOfSize:13];
        self.menuTitle.text = @"扫一扫";
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanTap)]];
        
    }
    return self;
}

- (void)scanTap
{
    ScanViewController *scanViewController = [[ScanViewController alloc] init];
    [[self viewController].navigationController pushViewController:scanViewController animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
