//
//  OperateRecordDetailsView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/28.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "OperateRecordDetailsView.h"
#import "OperateRecordInfoView.h"
#import "OperateRecordModel.h"
#import "CharacterImage.h"
@interface OperateRecordDetailsView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *changeImage;
//@property (nonatomic, strong) UIImageView *targetLogoImage;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) BaseLabel *contentLabel;
@property (nonatomic, strong) BaseLabel *statusLabel;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) OperateRecordInfoView *nameInfoView;
@property (nonatomic, strong) OperateRecordInfoView *webNameInfoView;
@property (nonatomic, strong) OperateRecordInfoView *webUrlInfoView;
@property (nonatomic, strong) OperateRecordInfoView *timeInfoView;

@property (nonatomic, strong) CharacterImage *targetLogoImage;

@end

@implementation OperateRecordDetailsView

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
//        self.backgroundView.layer.masksToBounds = YES;
        
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 25 * HEIGHT / 667, 70, 70)];
        [self.backgroundView addSubview:self.headImage];
        self.headImage.layer.cornerRadius = 35;
        self.headImage.layer.masksToBounds = YES;
        
        self.changeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 10)];
        [self.backgroundView addSubview:self.changeImage];
        self.changeImage.center = CGPointMake(self.backgroundView.frame.size.width / 2, self.headImage.center.y);
        self.changeImage.image = [UIImage imageNamed:@"authorizedImage"];

        self.targetLogoImage = [[CharacterImage alloc] initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 40 - 80, self.headImage.frame.origin.y, 70, 70)];
        [self.backgroundView addSubview:self.targetLogoImage];
        self.targetLogoImage.layer.cornerRadius = 35;
        self.targetLogoImage.layer.masksToBounds = YES;
        
        self.line1 = [[UIView alloc] initWithFrame:CGRectMake(15, self.headImage.frame.size.height + self.headImage.frame.origin.y + 25 * HEIGHT / 667, self.backgroundView.frame.size.width - 30, 0.5)];
        [self.backgroundView addSubview:self.line1];
        self.line1.backgroundColor = LINECOLOR;

        self.statusLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 55 - 15, self.line1.frame.size.height + self.line1.frame.origin.y + 15 * HEIGHT / 667, 55, 20)];
        [self.backgroundView addSubview:self.statusLabel];
        self.statusLabel.font = [UIFont systemFontOfSize:13];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        self.statusLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
        
        self.contentLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(15, self.statusLabel.frame.origin.y, self.statusLabel.frame.origin.x - 20, 20)];
        [self.backgroundView addSubview:self.contentLabel];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];

        self.line2 = [[UIView alloc] initWithFrame:CGRectMake(15, self.statusLabel.frame.size.height + self.statusLabel.frame.origin.y + 15 * HEIGHT / 667, self.backgroundView.frame.size.width - 30, 0.5)];
        [self.backgroundView addSubview:self.line2];
        self.line2.backgroundColor = LINECOLOR;
        
        self.nameInfoView = [[OperateRecordInfoView alloc] initWithFrame:CGRectMake(15, self.line2.frame.size.height + self.line2.frame.origin.y + 15 * HEIGHT / 667, self.backgroundView.frame.size.width - 30, 40)];
        [self.backgroundView addSubview:self.nameInfoView];
        
        self.webNameInfoView = [[OperateRecordInfoView alloc] initWithFrame:CGRectMake(15, self.nameInfoView.frame.size.height + self.nameInfoView.frame.origin.y + 15 * HEIGHT / 667, self.backgroundView.frame.size.width - 30, 40)];
        [self.backgroundView addSubview:self.webNameInfoView];
        
        self.webUrlInfoView = [[OperateRecordInfoView alloc] initWithFrame:CGRectMake(15, self.webNameInfoView.frame.size.height + self.webNameInfoView.frame.origin.y + 15 * HEIGHT / 667, self.backgroundView.frame.size.width - 30, 40)];
        [self.backgroundView addSubview:self.webUrlInfoView];
        
        self.timeInfoView = [[OperateRecordInfoView alloc] initWithFrame:CGRectMake(15, self.webUrlInfoView.frame.size.height + self.webUrlInfoView.frame.origin.y + 15 * HEIGHT / 667, self.backgroundView.frame.size.width - 30, 40)];
        [self.backgroundView addSubview:self.timeInfoView];
        
    }
    return self;
}

- (void)setOperateRecordModel:(OperateRecordModel *)operateRecordModel
{
    _operateRecordModel = operateRecordModel;
    
    NSString *headImageUrl = [NSString stringWithFormat:@"http://58.83.219.152:8080%@",self.operateRecordModel.userImageUrl];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"userHeadImage"]];
//    [self.targetLogoImage sd_setImageWithURL:[NSURL URLWithString:self.operateRecordModel.webImageUrl] placeholderImage:[UIImage imageNamed:@"targetLogoImage"]];
    self.targetLogoImage.characterStr = operateRecordModel.webName;
    if ([operateRecordModel.operateRecordeType isEqualToString:@"1"]) {
        //登录
        if ([operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"登录成功";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"登录失败";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"登录取消";
        }
        self.contentLabel.text = [NSString stringWithFormat:@"登录：%@",operateRecordModel.operateRecordeInfo];
        self.nameInfoView.titleLabel.text = @"登录昵称";
        self.webNameInfoView.titleLabel.text = @"登录网站";
        self.webUrlInfoView.titleLabel.text = @"登录网址";
        self.timeInfoView.titleLabel.text = @"登录时间";
    }
    else if ([operateRecordModel.operateRecordeType isEqualToString:@"2"]) {
        //授权
        if ([operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"授权成功";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"授权失败";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"授权取消";
        }
        self.contentLabel.text = [NSString stringWithFormat:@"授权：%@",operateRecordModel.operateRecordeInfo];
        self.nameInfoView.titleLabel.text = @"授权昵称";
        self.webNameInfoView.titleLabel.text = @"授权网站";
        self.webUrlInfoView.titleLabel.text = @"授权网址";
        self.timeInfoView.titleLabel.text = @"授权时间";
    }
    else if ([operateRecordModel.operateRecordeType isEqualToString:@"3"]) {
        //认证
        if ([operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"认证成功";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"认证失败";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"认证取消";
        }
        self.contentLabel.text = [NSString stringWithFormat:@"认证：%@",operateRecordModel.operateRecordeInfo];
        self.nameInfoView.titleLabel.text = @"认证昵称";
        self.webNameInfoView.titleLabel.text = @"认证网站";
        self.webUrlInfoView.titleLabel.text = @"认证网址";
        self.timeInfoView.titleLabel.text = @"认证时间";
    }
    else if ([operateRecordModel.operateRecordeType isEqualToString:@"4"]) {
        //声明
        if ([operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"声明成功";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"声明失败";
        }
        else if ([operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"声明取消";
        }
        self.contentLabel.text = [NSString stringWithFormat:@"声明：%@",operateRecordModel.operateRecordeInfo];
        self.nameInfoView.titleLabel.text = @"声明昵称";
        self.webNameInfoView.titleLabel.text = @"声明网站";
        self.webUrlInfoView.titleLabel.text = @"声明网址";
        self.timeInfoView.titleLabel.text = @"声明时间";
    }

    if ([operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"1b93ef" alpha:1];
    }
    else
    {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
    }
    
    self.nameInfoView.contentLabel.text = operateRecordModel.userName;
    self.webNameInfoView.contentLabel.text = operateRecordModel.webName;
    self.webUrlInfoView.contentLabel.text = operateRecordModel.webUrl;
    self.timeInfoView.contentLabel.text = [self getDateAccordingTime:[operateRecordModel.time integerValue] formatStyle:@"yyyy-MM-dd hh:mm"];
    
}


//根据NSString类型时间戳转换为日期格式
- (NSString *)getDateAccordingTime:(NSTimeInterval )aTime formatStyle:(NSString *)formate
{
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:aTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    return[formatter stringFromDate:nowDate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
