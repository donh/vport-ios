//
//  IdentityInformationTableViewCell.m
//  vPort
//
//  Created by MengFanJun on 2017/6/20.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "IdentityInformationTableViewCell.h"
#import "IdentityInformationModel.h"

@implementation IdentityInformationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.identityCardLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.identityCardLabel];
        self.identityCardLabel.font = [UIFont systemFontOfSize:15];
        self.identityCardLabel.textColor = [UIColor colorWithHexString:@"111111" alpha:1];
        self.identityCardLabel.text = @"身份证";
        
        self.statusLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.statusLabel];
        self.statusLabel.font = [UIFont systemFontOfSize:12];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1];
        self.statusLabel.layer.cornerRadius = 4;
        self.statusLabel.layer.masksToBounds = YES;
        self.statusLabel.layer.borderWidth = 0.5;
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1].CGColor;
        self.statusLabel.text = @"待认证";

        self.identityCardImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.identityCardImage];
        self.identityCardImage.image = [UIImage imageNamed:@"identityCardImage"];
        
        self.identityCardNumberLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.identityCardNumberLabel];
        self.identityCardNumberLabel.font = [UIFont systemFontOfSize:13];
        self.identityCardNumberLabel.textColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1];
        self.identityCardNumberLabel.text = @"请填写真实有效的身份证信息";
        
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
    
    self.identityCardLabel.frame = CGRectMake(20, 20, 80, 16);
    
    self.statusLabel.frame = CGRectMake(self.contentView.frame.size.width - 50 - 13, 20, 50, 20);
    self.statusLabel.center = CGPointMake(self.statusLabel.center.x, self.identityCardLabel.center.y);
    
    self.identityCardImage.frame = CGRectMake(25, self.identityCardLabel.frame.origin.y + self.identityCardLabel.frame.size.height + 20, 22, 17);
    
    self.moreImage.frame = CGRectMake(self.contentView.frame.size.width - 8 - 22, 0, 22, 22);
    self.moreImage.center = CGPointMake(self.moreImage.center.x, self.identityCardImage.center.y);

    self.identityCardNumberLabel.frame = CGRectMake(self.identityCardImage.frame.size.width + self.identityCardImage.frame.origin.x + 15, 0, self.moreImage.frame.origin.x - (self.identityCardImage.frame.size.width + self.identityCardImage.frame.origin.x + 15) - 10, 13);
    self.identityCardNumberLabel.center = CGPointMake(self.identityCardNumberLabel.center.x, self.identityCardImage.center.y);
    
    self.line.frame = CGRectMake(20, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width - 40, 0.5);
    
}

- (void)setStatusStr:(NSString *)statusStr
{
    _statusStr = [statusStr copy];
    if (statusStr.length == 0) {
        //没有认证
        self.statusLabel.text = @"待认证";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1].CGColor;
        self.identityCardNumberLabel.text = @"请填写真实有效的身份证信息";
        self.identityCardNumberLabel.textColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1];
    }
    else if ([statusStr isEqualToString:@"待认证"]) {
        self.statusLabel.text = @"待认证";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"7d7d7d" alpha:1].CGColor;
        self.identityCardNumberLabel.textColor = [UIColor colorWithHexString:@"111111" alpha:1];
    }
    else if ([statusStr isEqualToString:@"认证成功"]) {
        self.statusLabel.text = @"认证成功";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"1b93ef" alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"1b93ef" alpha:1].CGColor;
        self.identityCardNumberLabel.textColor = [UIColor colorWithHexString:@"111111" alpha:1];
    }
    else if ([statusStr isEqualToString:@"认证中"]) {
        self.statusLabel.text = @"认证中";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"eb212e" alpha:1].CGColor;
        self.identityCardNumberLabel.textColor = [UIColor colorWithHexString:@"111111" alpha:1];
    }
    else if ([statusStr isEqualToString:@"认证失败"]) {
        self.statusLabel.text = @"认证失败";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"eb212e" alpha:1].CGColor;
        self.identityCardNumberLabel.textColor = [UIColor colorWithHexString:@"111111" alpha:1];
    }
}

- (void)setIdentityInformationModel:(IdentityInformationModel *)identityInformationModel
{
    _identityInformationModel = identityInformationModel;
    if ([identityInformationModel.identityInformationStatus isEqualToString:@"1"]) {
        self.statusStr = @"待认证";
    }
    else if ([identityInformationModel.identityInformationStatus isEqualToString:@"2"])
    {
        self.statusStr = @"认证成功";
    }
    else if ([identityInformationModel.identityInformationStatus isEqualToString:@"3"])
    {
        self.statusStr = @"认证中";
    }
    else if ([identityInformationModel.identityInformationStatus isEqualToString:@"4"])
    {
        self.statusStr = @"认证失败";
    }
    self.identityCardNumberLabel.text = identityInformationModel.identityInformationNumber;
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
