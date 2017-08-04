//
//  IdentityInformationDateTableViewCell.m
//  vPort
//
//  Created by MengFanJun on 2017/6/20.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "IdentityInformationDateTableViewCell.h"

@implementation IdentityInformationDateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"898989" alpha:1];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        self.valueLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.valueLabel];
        self.valueLabel.textColor = [UIColor colorWithHexString:@"898989" alpha:1];
        self.valueLabel.font = [UIFont systemFontOfSize:13];
        self.valueLabel.textAlignment = NSTextAlignmentRight;

        
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
    
    self.titleLabel.frame = CGRectMake(20, 10, 100, self.contentView.frame.size.height - 20);
    
    self.moreImage.frame = CGRectMake(self.contentView.frame.size.width - 20 - 3, 15, 20, 20);
    self.moreImage.center = CGPointMake(self.moreImage.center.x, self.contentView.center.y);
    
    self.valueLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5, 10, self.moreImage.frame.origin.x - (self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5) - 5, self.contentView.frame.size.height - 20);
    
    self.line.frame = CGRectMake(5, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width - 10, 0.5);

}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr copy];
    if ([titleStr isEqualToString:@"有效期开始日期"]) {
        
    }
    else if ([titleStr isEqualToString:@"有效期结束日期"])
    {
        
    }
    self.titleLabel.text = titleStr;
    
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
