//
//  HomeMenuView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/16.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "HomeMenuView.h"
#import "NameCardViewController.h"
#import "IdentityInformationViewController.h"
#import "OperateRecordViewController.h"

@implementation HomeMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        [self addSubview:self.line1];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.3];
        
        self.nameCardView = [[MenuView alloc] initWithFrame:CGRectMake(0, 0.5, (frame.size.width - 1) / 3, frame.size.height - 1)];
        [self addSubview:self.nameCardView];
        self.nameCardView.menuImage.image = [UIImage imageNamed:@"nameCardImage"];
        self.nameCardView.menuTitle.text = @"vPort名片";
        
        self.line2 = [[UIView alloc] initWithFrame:CGRectMake(self.nameCardView.frame.origin.x + self.nameCardView.frame.size.width, 0, 0.5, frame.size.height)];
        [self addSubview:self.line2];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.3];
        
        self.identityInformationView = [[MenuView alloc] initWithFrame:CGRectMake(self.line2.frame.size.width + self.line2.frame.origin.x, 0.5, (frame.size.width - 1) / 3, frame.size.height - 1)];
        [self addSubview:self.identityInformationView];
        self.identityInformationView.menuImage.image = [UIImage imageNamed:@"identityInformationImage"];
        self.identityInformationView.menuTitle.text = @"身份信息";
        
        self.line3 = [[UIView alloc] initWithFrame:CGRectMake(self.identityInformationView.frame.origin.x + self.identityInformationView.frame.size.width, 0, 0.5, frame.size.height)];
        [self addSubview:self.line3];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.3];
        
        self.operateRecordView = [[MenuView alloc] initWithFrame:CGRectMake(self.line3.frame.size.width + self.line3.frame.origin.x, 0.5, (frame.size.width - 1) / 3, frame.size.height - 1)];
        [self addSubview:self.operateRecordView];
        self.operateRecordView.menuImage.image = [UIImage imageNamed:@"operateRecordImage"];
        self.operateRecordView.menuTitle.text = @"操作记录";
        
        self.line4 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        [self addSubview:self.line4];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.3];
        
        [self.nameCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameCardViewTap)]];
        [self.identityInformationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identityInformationViewTap)]];
        [self.operateRecordView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operateRecordViewTap)]];

    }
    return self;
}

- (void)nameCardViewTap
{
    NameCardViewController *nameCardViewController = [[NameCardViewController alloc] init];
    [[self viewController].navigationController pushViewController:nameCardViewController animated:YES];
}

- (void)identityInformationViewTap
{
    IdentityInformationViewController *identityInformationViewController = [[IdentityInformationViewController alloc] init];
    [[self viewController].navigationController pushViewController:identityInformationViewController animated:YES];
}

- (void)operateRecordViewTap
{
    OperateRecordViewController *operateRecordViewController = [[OperateRecordViewController alloc] init];
    [[self viewController].navigationController pushViewController:operateRecordViewController animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
