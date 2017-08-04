//
//  NameCardTableViewCell.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "NameCardTableViewCell.h"

@implementation NameCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        
        self.moreImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.moreImage];
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        
        self.titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.line.backgroundColor = [UIColor blackColor];
        self.line.alpha = 0.1;
        
        self.moreImage.image = [UIImage imageNamed:@"editImage"];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"a3a3a3" alpha:1];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.numberOfLines = 0;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.frame = CGRectMake(15, 10, 60, 15);
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.contentView.center.y);
    
    self.moreImage.frame = CGRectMake(self.contentView.frame.size.width - 20 - 3, 15, 20, 20);
    self.moreImage.center = CGPointMake(self.moreImage.center.x, self.contentView.center.y);
    if (self.moreImage.hidden) {
        self.contentLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5, 5, self.contentView.frame.size.width - (self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5) - 10, self.contentView.frame.size.height - 10);
    }
    else
    {
        self.contentLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5, 5, self.moreImage.frame.origin.x - (self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5), self.contentView.frame.size.height - 10);
    }
    self.contentLabel.center = CGPointMake(self.contentLabel.center.x, self.contentView.center.y);
    
    self.line.frame = CGRectMake(0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width - 0, 0.5);
    
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
