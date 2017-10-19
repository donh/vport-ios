//
//  OperateRecordTableViewCell.h
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OperateRecordModel;

@interface OperateRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) BaseLabel *statusLabel;
@property (nonatomic, strong) BaseLabel *timeLabel;
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) OperateRecordModel *operateRecordModel;

@end
