//
//  OperateRecordTableViewCell.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "OperateRecordTableViewCell.h"
#import "UITableViewCell+StringHeight.h"
#import "OperateRecordModel.h"

@implementation OperateRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];
        
        self.titleLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
        
        self.statusLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.statusLabel];
        self.statusLabel.font = [UIFont systemFontOfSize:12];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        self.statusLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
        
        self.timeLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"464646" alpha:1];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.moreImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.moreImage];
        self.moreImage.image = [UIImage imageNamed:@"editImage"];
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = LINECOLOR;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headImage.frame = CGRectMake(15, 0, 60, 60);
    self.headImage.layer.cornerRadius = 30;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.center = CGPointMake(self.headImage.center.x, self.contentView.frame.size.height / 2);
    NSString *headImageUrl = [NSString stringWithFormat:@"http://58.83.219.152:8080%@",self.operateRecordModel.userImageUrl];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"userHeadImage"]];

    self.moreImage.frame = CGRectMake(self.contentView.frame.size.width - 5 - 22, self.contentView.frame.size.height / 2 - 11, 22, 22);

    self.statusLabel.frame = CGRectMake(self.moreImage.frame.origin.x - 50, self.headImage.frame.origin.y + 5, 50, 15);
//    self.statusLabel.text = @"认证成功";
    if ([self.operateRecordModel.operateRecordeType isEqualToString:@"1"]) {
        //登录
        if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"登录成功";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"登录失败";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"登录取消";
        }
    }
    else if ([self.operateRecordModel.operateRecordeType isEqualToString:@"2"]) {
        //授权
        if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"授权成功";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"授权失败";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"授权取消";
        }
    }
    else if ([self.operateRecordModel.operateRecordeType isEqualToString:@"3"]) {
        //认证
        if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"认证成功";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"认证失败";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"认证取消";
        }
    }

    else if ([self.operateRecordModel.operateRecordeType isEqualToString:@"4"])
    {
        //声明
        if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
            self.statusLabel.text = @"声明成功";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"2"]) {
            self.statusLabel.text = @"声明失败";
        }
        else if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"3"]) {
            self.statusLabel.text = @"声明取消";
        }
    }
    
    if ([self.operateRecordModel.operateRecordeStatus isEqualToString:@"1"]) {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"1b93ef" alpha:1];
    }
    else
    {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
    }
    
    self.titleLabel.frame = CGRectMake(self.headImage.frame.size.width + self.headImage.frame.origin.x + 5, self.headImage.frame.origin.y + 5, self.statusLabel.frame.origin.x - 5 - (self.headImage.frame.size.width + self.headImage.frame.origin.x + 5), 15);
//    self.titleLabel.text = @"北京市朝阳区人社局";
    self.titleLabel.text = self.operateRecordModel.webName;

    self.timeLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.headImage.frame.origin.y + self.headImage.frame.size.height - 15 - 5, self.moreImage.frame.origin.x - self.titleLabel.frame.origin.x - 5, 15);
//    self.timeLabel.text = @"10分钟前";
    self.timeLabel.text = [self getDateAccordingTime:[self.operateRecordModel.time integerValue] formatStyle:@"yyyy-MM-dd hh:mm"];
    
    self.line.frame = CGRectMake(0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width - 0, 0.5);
    
}

//根据NSString类型时间戳转换为日期格式
- (NSString *)getDateAccordingTime:(NSTimeInterval )aTime formatStyle:(NSString *)formate
{
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:aTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    return[formatter stringFromDate:nowDate];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
