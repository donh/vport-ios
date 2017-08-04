/*
 * Copyright (C) 2016-2016, The Little-Sparkle Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS-IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "UserHeadImageTableViewCell.h"

@implementation UserHeadImageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];
        
        self.moreImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.moreImage];
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        
        self.titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.line.backgroundColor = [UIColor blackColor];
        self.line.alpha = 0.1;
        self.moreImage.image = [UIImage imageNamed:@"editImage"];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.frame = CGRectMake(15, 10, 150, 15);
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.contentView.center.y);
    self.moreImage.frame = CGRectMake(self.contentView.frame.size.width - 20 - 3, 15, 20, 20);
    self.moreImage.center = CGPointMake(self.moreImage.center.x, self.contentView.center.y);
    self.headImage.frame = CGRectMake(self.moreImage.frame.origin.x - 60 - 5, 0, 60, 60);
    self.headImage.layer.cornerRadius = 30;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.center = CGPointMake(self.headImage.center.x, self.contentView.center.y);
//    self.headImage.image = [UIImage imageNamed:@"headImageUser"];
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
