//
//  EditIdentityInformationTableViewCell.m
//  vPort
//
//  Created by MengFanJun on 2017/6/20.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "EditIdentityInformationTableViewCell.h"

@implementation EditIdentityInformationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"898989" alpha:1];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        self.valueTextField = [[UITextField alloc] init];
        [self.contentView addSubview:self.valueTextField];
        self.valueTextField.textAlignment = NSTextAlignmentRight;
        self.valueTextField.textColor = [UIColor colorWithHexString:@"363636" alpha:1];
        self.valueTextField.font = [UIFont systemFontOfSize:13];
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = LINECOLOR;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(20, 10, 80, self.contentView.frame.size.height - 20);
    
    self.valueTextField.frame = CGRectMake(self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x + 10, 10, self.contentView.frame.size.width - (self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x + 10) - 20, self.contentView.frame.size.height - 20);
//    self.valueTextField.text = @"342224199900002212";
    [self.valueTextField setValue:[UIColor colorWithHexString:@"898989" alpha:1]forKeyPath:@"_placeholderLabel.textColor"];
    
    self.line.frame = CGRectMake(5, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width - 10, 0.5);
    
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr copy];
    if ([titleStr isEqualToString:@"姓名"]) {
        self.valueTextField.placeholder = @"请填写姓名";
    }
    else if ([titleStr isEqualToString:@"身份证号"])
    {
        self.valueTextField.placeholder = @"请填写身份证号";
    }
    else if ([titleStr isEqualToString:@"签发机关"])
    {
        self.valueTextField.placeholder = @"请填写签发机关";
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
