//
//  HomeMenuView.h
//  vPort
//
//  Created by MengFanJun on 2017/6/16.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseView.h"
#import "MenuView.h"

@interface HomeMenuView : BaseView

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) MenuView *nameCardView;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) MenuView *identityInformationView;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) MenuView *operateRecordView;
@property (nonatomic, strong) UIView *line4;

@end
