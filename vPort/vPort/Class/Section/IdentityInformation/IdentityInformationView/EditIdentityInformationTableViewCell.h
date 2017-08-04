//
//  EditIdentityInformationTableViewCell.h
//  vPort
//
//  Created by MengFanJun on 2017/6/20.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditIdentityInformationTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) NSString *titleStr;

@end
