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

#import "SetUpTableViewCell.h"

@implementation SetUpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
//        self.contentLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:self.contentLabel];
        
        self.moreImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.moreImage];
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        
        self.titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.moreImage.image = [UIImage imageNamed:@"editImage"];
//        self.contentLabel.textColor = [UIColor blackColor];
//        self.contentLabel.textAlignment = NSTextAlignmentRight;
//        self.contentLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.frame = CGRectMake(20, 10, 150, 15);
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.contentView.center.y);
    self.moreImage.frame = CGRectMake(self.contentView.frame.size.width - 20 - 8, 15, 20, 20);
    self.moreImage.center = CGPointMake(self.moreImage.center.x, self.contentView.center.y);
//    self.contentLabel.frame = CGRectMake(self.moreImage.frame.origin.x - 70, 0, 70, 15);
//    self.contentLabel.center = CGPointMake(self.contentLabel.center.x, self.contentView.center.y);
    self.line.backgroundColor = [UIColor blackColor];
    self.line.alpha = 0.1;
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
