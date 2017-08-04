//
//  IdentityInformationGenderTableViewCell.h
//  vPort
//
//  Created by MengFanJun on 2017/7/4.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentityInformationGenderTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) BaseLabel *valueLabel;
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) NSString *titleStr;
@end
