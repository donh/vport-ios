//
//  NameCardTableViewCell.h
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameCardTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseLabel *titleLabel;//标题
@property (nonatomic, strong) BaseLabel *contentLabel;//内容
@property (nonatomic, strong) UIImageView *moreImage;//更多
@property (nonatomic, strong) UIView *line;//细线

@end
