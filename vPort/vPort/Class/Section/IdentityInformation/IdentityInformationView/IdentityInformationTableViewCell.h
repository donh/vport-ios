//
//  IdentityInformationTableViewCell.h
//  vPort
//
//  Created by MengFanJun on 2017/6/20.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IdentityInformationModel;

@interface IdentityInformationTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseLabel *identityCardLabel;
@property (nonatomic, strong) UIImageView *identityCardImage;
@property (nonatomic, strong) BaseLabel *statusLabel;
@property (nonatomic, strong) BaseLabel *identityCardNumberLabel;
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, strong) IdentityInformationModel *identityInformationModel;

@end
